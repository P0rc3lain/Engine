//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import ModelIO

public final class PNISceneTranslator: PNSceneTranslator {
    private let device: MTLDevice
    private var materialCache = [String: PNMaterial]()
    public init(device: MTLDevice) {
        self.device = device
    }
    public func process(asset: MDLAsset) -> PNScene? {
        let scene = PNScene.default
        asset.walk(handler: { (object: MDLObject, passedValue: PNScenePiece?) in
            if let object = object as? MDLCamera {
                let node = PNScenePiece.make(data: cameraNode(camera: object.porcelain, transform: object.transform),
                                             parent: passedValue)
                passedValue?.children.append(node)
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
                    let node = PNScenePiece.make(data: riggedMeshNode(mesh: mesh,
                                                                      skeleton: skeleton,
                                                                      transform: object.transform),
                                                 parent: passedValue)
                    node.data.enclosingNode.send(PNWeakRef(node))
                    passedValue?.children.append(node)
                    return node
                } else {
                    let node = PNScenePiece.make(data: meshNode(mesh: mesh,
                                                                transform: object.transform),
                                                 parent: passedValue)
                    passedValue?.children.append(node)
                    return node
                }
            } else {
                let node = PNScenePiece.make(data: groupNode(transfrom: object.transform),
                                             parent: passedValue)
                passedValue?.children.append(node)
                return node
            }
        }, initialValue: scene.rootNode)
        materialCache = [:]
        return scene
    }
    private func convert(animation: MDLAnimationBindComponent) -> PNSkeleton {
        guard let skeleton = animation.skeleton, !skeleton.jointPaths.isEmpty else {
            fatalError("Animation Bind Component is missing a skeleton or the jointPaths is empty")
        }
        if let jointAnimation = animation.jointAnimation as? MDLPackedJointAnimation {
            assert(skeleton.jointPaths == jointAnimation.jointPaths, "Skeleton and animation must describe exactu number of joints")
            let animation = PNAnimatedSkeleton(translation: jointAnimation.translations.porcelain,
                                               rotation: jointAnimation.rotations.porcelain,
                                               scale: jointAnimation.scales.porcelain)
            let parentIndices = jointAnimation.jointPaths.map { parentIndex(jointPaths: jointAnimation.jointPaths, jointPath: $0) }
            return PNISkeleton(bindTransforms: skeleton.jointBindTransforms.float4x4Array,
                               parentIndices: parentIndices,
                               animations: [animation])
        } else {
            fatalError("Unhandled case")
        }
    }
    private func riggedMeshNode(mesh: PNMesh, skeleton: PNSkeleton, transform: MDLTransformComponent?) -> PNSceneNode {
        guard let transfrom = transform?.decomposed else {
            return PNIRiggedMesh(mesh: mesh, skeleton: skeleton, transform: .identity)
        }
        return PNIAnimatedRiggedMesh(mesh: mesh, skeleton: skeleton, animator: PNIAnimator.`defaultTRS`, animation: transfrom)
    }
    private func meshNode(mesh: PNMesh, transform: MDLTransformComponent?) -> PNSceneNode {
        guard let transfrom = transform?.decomposed else {
            return PNIMeshNode(mesh: mesh, transform: .identity)
        }
        return PNIAnimatedMeshNode(mesh: mesh, animator: PNIAnimator.`defaultTRS`, animation: transfrom)
    }
    private func cameraNode(camera: PNCamera, transform: MDLTransformComponent?) -> PNSceneNode {
        guard let transfrom = transform?.decomposed else {
            return PNICameraNode(camera: camera, transform: .identity)
        }
        return PNIAnimatedCameraNode(camera: camera, animator: PNIAnimator.`defaultTRS`, animation: transfrom)
    }
    private func groupNode(transfrom: MDLTransformComponent?) -> PNSceneNode {
        guard let transfrom = transfrom?.decomposed else {
            return PNISceneNode(transform: .identity)
        }
        return PNIAnimatedNode(animator: PNIAnimator.`defaultTRS`, animation: transfrom)
    }
    private func convert(mesh: MDLMesh) -> PNMesh? {
        assert(mesh.vertexBuffers.count == 1,
               "Only object that have a single buffer assigned are supported")
        let buffer = mesh.vertexBuffers[0].rawData
        let bounds = PNIBoundEstimator().bound(vertexBuffer: buffer)
        guard let deviceBuffer = device.makeBufferShared(data: buffer) else {
            return nil
        }
        let dataBuffer = PNDataBuffer(buffer: deviceBuffer, length: buffer.count)
        var pieceDescriptions = [PNPieceDescription]()
        guard let submeshes = mesh.submeshes as? [MDLSubmesh] else {
            fatalError("Malformed object")
        }
        submeshes.forEach {
            if let material = $0.material,
               let submeshBuffer = device.makeBufferShared(data: $0.indexBuffer.rawData),
               let indexType = PNIndexBitDepth(modelIO: $0.indexType)?.metal,
               let geometryType = PNPrimitiveType(modelIO: $0.geometryType)?.metal {
                let submesh = PNSubmesh(indexBuffer: PNDataBuffer(buffer: submeshBuffer,
                                                                  length: $0.indexBuffer.length),
                                        indexCount: $0.indexCount,
                                        indexType: indexType,
                                        primitiveType: geometryType)
                guard let loadedMaterial = materialCache[material.name] ?? material.upload(device: device) else {
                    return
                }
                materialCache[material.name] = loadedMaterial
                let description = PNPieceDescription(drawDescription: submesh,
                                                     material: loadedMaterial)
                pieceDescriptions.append(description)
            }

        }
        let interactor = PNIBoundingBoxInteractor.default
        return PNMesh(boundingBox: interactor.from(bound: bounds),
                      vertexBuffer: dataBuffer,
                      pieceDescriptions: pieceDescriptions,
                      culling: PNCulling(frontCulling: .front,
                                         backCulling: .back,
                                         winding: .counterClockwise))
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
