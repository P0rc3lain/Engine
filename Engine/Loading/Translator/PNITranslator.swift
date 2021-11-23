//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import ModelIO
import simd

public struct PNITranslator: PNTranslator {
    private let device: MTLDevice
    public init(device: MTLDevice) {
        self.device = device
    }
    public func process(asset: MDLAsset) -> GPUSceneDescription? {
        var scene = RamSceneDescription()
        asset.walk { object in
            scene.entityNames.append(object.path)
            let parentIdx = parentIndex(object: object, scene: &scene)
            let transform = object.transform?.decompose ?? .static
            if let object = object as? MDLCamera {
                add(camera: object, transform: transform, parentIdx: parentIdx, scene: &scene)
            } /* else if let object = object as? MDLLight {
                fatalError("Not implemented")
            } */ else if let object = object as? MDLMesh {
                add(mesh: object, transform: transform, parentIdx: parentIdx, scene: &scene)
            } else {
                let entity = Entity(transform: transform,
                                    type: .group,
                                    referenceIdx: .nil)
                scene.entities.add(parentIdx: parentIdx, data: entity)
            }
            if let component = object.componentConforming(to: MDLComponent.self),
               let animation = component as? MDLAnimationBindComponent {
                add(animation: animation, scene: &scene)
            } else {
                scene.skeletonReferences.append(Int.nil)
            }
        }
        validateScene(scene: &scene)
        return scene.upload(device: device)
    }
    private func validateScene(scene: inout RamSceneDescription) {
        assert(scene.entityNames.count == scene.entities.count, "There must be the same number of names as objects")
        assert(Set(scene.entityNames).count == scene.entityNames.count, "Object names must be unique")
        assert(scene.entities.count == scene.skeletonReferences.count, "Each object should have reference to a skeleton")
    }
    private func add(animation: MDLAnimationBindComponent,
                     scene: inout RamSceneDescription) {
        guard let skeleton = animation.skeleton, !skeleton.jointPaths.isEmpty else {
            fatalError("Animation Bind Component is missing a skeleton or the jointPaths is empty")
        }
        if let jointAnimation = animation.jointAnimation as? MDLPackedJointAnimation {
            assert(skeleton.jointPaths == jointAnimation.jointPaths, "Skeleton and animation must describe exactu number of joints")
            let animation = PNAnimatedSkeleton(translation: PNAnySampleProvider(jointAnimation.translations.porcelain),
                                               rotation: PNAnySampleProvider(jointAnimation.rotations.porcelain),
                                               scale: PNAnySampleProvider(jointAnimation.scales.porcelain))
            let parentIndices = jointAnimation.jointPaths.map { parentIndex(jointPaths: jointAnimation.jointPaths, jointPath: $0) }
            let skeleton = PNISkeleton(bindTransforms: skeleton.jointBindTransforms.float4x4Array,
                                       parentIndices: parentIndices,
                                       animations: [animation])
            scene.skeletons.append(skeleton)
            scene.skeletonReferences.append(scene.skeletons.count - 1)
        } else {
            fatalError("Unhandled case")
        }
    }
    private func add(camera: MDLCamera,
                     transform: PNAnimatedCoordinateSpace,
                     parentIdx: Int,
                     scene: inout RamSceneDescription) {
        scene.cameras.append(camera.porcelain)
        let entity = Entity(transform: transform,
                            type: .camera,
                            referenceIdx: scene.cameras.count - 1)
        scene.entities.add(parentIdx: parentIdx, data: entity)
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
    private func add(mesh: MDLMesh,
                     transform: PNAnimatedCoordinateSpace,
                     parentIdx: Int,
                     scene: inout RamSceneDescription) {
        assert(mesh.vertexBuffers.count == 1, "Only object that have a single buffer assigned are supported")
        var buffer = mesh.vertexBuffers[0].rawData
        let bounds = getModelBounds(buffer: &buffer)
        let dataBuffer = PNDataBuffer(buffer: buffer, length: buffer.count)
        var pieceDescriptions = [PNRamPieceDescription]()
        guard let submeshes = mesh.submeshes as? [MDLSubmesh] else {
            fatalError("Malformed object")
        }
        submeshes.forEach {
            if let material = $0.material,
               let uploadedMaterial = material.upload(device: device),
               let indexBasedDraw = $0.porcelainSubmesh {
                let description = PNPieceDescription(material: uploadedMaterial,
                                                     drawDescription: indexBasedDraw)
                pieceDescriptions.append(description)
            }
                    
        }
        let interactor = PNIBoundingBoxInteractor.default
        scene.meshes.append(PNRamMesh(name: mesh.name,
                                      boundingBox: interactor.from(bound: bounds),
                                      vertexBuffer: dataBuffer,
                                      pieceDescriptions: pieceDescriptions))
        let entity = Entity(transform: transform,
                            type: .mesh,
                            referenceIdx: scene.meshes.count - 1)
        scene.entities.add(parentIdx: parentIdx, data: entity)
    }
    private func parentIndex(object: MDLObject, scene: inout RamSceneDescription) -> Int {
        guard let parent = object.parent,
              let index = scene.entityNames.firstIndex(of: parent.path) else {
            return .nil
        }
        return index
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
