//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import ModelIO

public struct PNISceneTranslator: PNSceneTranslator {
    private let device: MTLDevice
    public init(device: MTLDevice) {
        self.device = device
    }
    public func process(asset: MDLAsset) -> PNScene? {
        let scene = PNScene(rootNode: PNNode(data: PNISceneNode.init(transform: .static)))
        asset.walk(handler: { (object: MDLObject, passedValue: PNNode<PNSceneNode>?) in
            let transform = object.transform?.decompose ?? .static
            var node: PNNode<PNSceneNode>? = nil
            if let object = object as? MDLCamera {
                node =  PNNode(data: PNICameraNode(camera: object.porcelain, transform: transform) as PNSceneNode,
                               parent: passedValue)
                passedValue?.children.append(node!)
                return node
            } /* else if let object = object as? MDLLight {
                fatalError("Not implemented")
            } */ else if let object = object as? MDLMesh {
                guard let mesh = convert(mesh: object) else {
                    fatalError("Could not convert mesh")
                }
                if let component = object.componentConforming(to: MDLComponent.self),
                   let animation = component as? MDLAnimationBindComponent {
                    let skeleton = convert(animation: animation)
                    node = PNNode(data: PNIRiggedMesh(mesh: mesh, skeleton: skeleton, transform: transform) as PNSceneNode,
                                  parent: passedValue)
                } else {
                    node = PNNode(data: PNIMeshNode(mesh: mesh, transform: transform) as PNSceneNode,
                                  parent: passedValue)
                }
                node?.parent = passedValue
                passedValue?.children.append(node!)
            } else {
                node =  PNNode(data: PNISceneNode(transform: transform) as PNSceneNode,
                               parent: passedValue)
                passedValue?.children.append(node!)
            }
            return node
        }, initialValue: scene.rootNode)
        return scene
    }
    private func convert(animation: MDLAnimationBindComponent) -> PNSkeleton {
        guard let skeleton = animation.skeleton, !skeleton.jointPaths.isEmpty else {
            fatalError("Animation Bind Component is missing a skeleton or the jointPaths is empty")
        }
        if let jointAnimation = animation.jointAnimation as? MDLPackedJointAnimation {
            assert(skeleton.jointPaths == jointAnimation.jointPaths, "Skeleton and animation must describe exactu number of joints")
            let animation = PNAnimatedSkeleton(translation: PNAnySampleProvider(jointAnimation.translations.porcelain),
                                               rotation: PNAnySampleProvider(jointAnimation.rotations.porcelain),
                                               scale: PNAnySampleProvider(jointAnimation.scales.porcelain))
            let parentIndices = jointAnimation.jointPaths.map { parentIndex(jointPaths: jointAnimation.jointPaths, jointPath: $0) }
            return PNISkeleton(bindTransforms: skeleton.jointBindTransforms.float4x4Array,
                               parentIndices: parentIndices,
                               animations: [animation])
        } else {
            fatalError("Unhandled case")
        }
    }
    private func getModelBounds(buffer: inout Data) -> PNBound {
        let vertexCount = buffer.count / MemoryLayout<Vertex>.stride
        assert(buffer.count % MemoryLayout<Vertex>.stride == 0, "Data must contain vertices")
        var minX = Float(0)
        var maxX = Float(0)
        var minY = Float(0)
        var maxY = Float(0)
        var minZ = Float(0)
        var maxZ = Float(0)
        buffer.withUnsafeBytes { (pointer: UnsafePointer<Vertex>) in
            let firstVertex = pointer.pointee
            minX = firstVertex.position.x
            maxX = firstVertex.position.x
            minY = firstVertex.position.y
            maxY = firstVertex.position.y
            minZ = firstVertex.position.z
            maxZ = firstVertex.position.z
            for i in 1 ..< vertexCount {
                let vertex = pointer.advanced(by: i).pointee
                minX = min(vertex.position.x, minX)
                maxX = max(vertex.position.x, maxX)
                minY = min(vertex.position.y, minX)
                maxY = max(vertex.position.y, maxX)
                minZ = min(vertex.position.z, minX)
                maxZ = max(vertex.position.z, maxX)
            }

        }
        return PNBound(min: [minX, minY, minZ], max: [maxX, maxY, maxZ])
    }
    private func convert(mesh: MDLMesh) -> PNMesh? {
        assert(mesh.vertexBuffers.count == 1, "Only object that have a single buffer assigned are supported")
        var buffer = mesh.vertexBuffers[0].rawData
        let bounds = getModelBounds(buffer: &buffer)
        guard let deviceBuffer = device.makeBuffer(data: buffer) else {
            return nil
        }
        let dataBuffer = PNDataBuffer(buffer: deviceBuffer, length: buffer.count)
        var pieceDescriptions = [PNPieceDescription]()
        guard let submeshes = mesh.submeshes as? [MDLSubmesh] else {
            fatalError("Malformed object")
        }
        submeshes.forEach {
            if let material = $0.material,
               let uploadedMaterial = material.upload(device: device),
               let submeshBuffer = device.makeBuffer(data: $0.indexBuffer.rawData),
               let indexType = PNIndexBitDepth(modelIO: $0.indexType)?.metal,
               let geometryType = PNPrimitiveType(modelIO: $0.geometryType)?.metal {
                let submesh = PNSubmesh(indexBuffer: PNDataBuffer(buffer: submeshBuffer,
                                                                  length: $0.indexBuffer.length),
                                        indexCount: $0.indexCount,
                                        indexType: indexType,
                                        primitiveType: geometryType)
                let description = PNPieceDescription(material: uploadedMaterial,
                                                     drawDescription: submesh)
                pieceDescriptions.append(description)
            }

        }
        let interactor = PNIBoundingBoxInteractor.default
        return PNMesh(boundingBox: interactor.from(bound: bounds),
                      vertexBuffer: dataBuffer,
                      pieceDescriptions: pieceDescriptions)
    }
    private func parentIndex(jointPaths: [String], jointPath: String) -> Int {
        let components = jointPath.components(separatedBy: "/")
        if components.count > 1 {
            let parentPath = components[0 ..< components.count - 1].joined(separator: "/")
            guard let parentIndex = jointPaths.firstIndex(of: parentPath) else {
                return .nil
            }
            return parentIndex
        } else {
            return .nil
        }
    }
}