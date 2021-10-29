//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO
import simd

public class Translator {
    // MARK: - Initialization
    public init() { }
    // MARK: - Public
    public func process(asset: MDLAsset) -> RamSceneDescription {
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
        return scene
    }
    private func validateScene(scene: inout RamSceneDescription) {
        assert(scene.entityNames.count == scene.entities.count, "There must be the same number of names as objects")
        assert(scene.cameraNames.count == scene.cameras.count, "There must be the same number of names as cameras")
        assert(scene.meshNames.count == scene.meshBuffers.count, "There must be the same number of names as meshes")
        assert(scene.indexDrawsMaterials.count == scene.indexDraws.count, "There must be the same number of material references as draw references")
        assert(scene.indexDrawReferences.count == scene.meshBuffers.count, "There must be the same number of references as buffers")
        assert(scene.materialNames.count == scene.materials.count, "There must be the same number of names as objects")
        assert(Set(scene.entityNames).count == scene.entityNames.count, "Object names must be unique")
        assert(Set(scene.cameraNames).count == scene.cameraNames.count, "Camera names must be unique")
        assert(Set(scene.meshNames).count == scene.meshNames.count, "Mesh names must be unique")
        assert(Set(scene.materialNames).count == scene.materialNames.count, "Mesh names must be unique")
        assert(scene.entities.count == scene.skeletonReferences.count, "Each object should have reference to a skeleton")
    }
    private func add(animation: MDLAnimationBindComponent,
                     scene: inout RamSceneDescription) {
        guard let skeleton = animation.skeleton, !skeleton.jointPaths.isEmpty else {
            fatalError("Animation Bind Component is missing a skeleton or the jointPaths is empty")
        }
        if let jointAnimation = animation.jointAnimation as? MDLPackedJointAnimation {
            assert(skeleton.jointPaths == jointAnimation.jointPaths, "Skeleton and animation must describe exactu number of joints")
            scene.skeletalAnimations.append(AnimatedSkeleton(translation: jointAnimation.translations.porcelain,
                                                             rotation: jointAnimation.rotations.porcelain,
                                                             scale: jointAnimation.scales.porcelain))
            // TODO use geometry bind transform
            let skeleton = Skeleton(localBindTransforms: skeleton.jointBindTransforms.float4x4Array,
                                    parentIndices: jointAnimation.jointPaths.map { parentIndex(jointPaths: jointAnimation.jointPaths, jointPath: $0) })
            scene.animationReferences.append(scene.skeletalAnimations.count - 1 ..< scene.skeletalAnimations.count)
            scene.skeletons.append(skeleton)
            scene.skeletonReferences.append(scene.skeletons.count - 1)
        } else {
            fatalError("Unhandled case")
        }
    }
    private func add(camera: MDLCamera,
                     transform: TransformAnimation,
                     parentIdx: Int,
                     scene: inout RamSceneDescription) {
        scene.cameraNames.append(camera.path)
        scene.cameras.append(camera.porcelain)
        let entity = Entity(transform: transform,
                            type: .camera,
                            referenceIdx: scene.cameras.count - 1)
        scene.entities.add(parentIdx: parentIdx, data: entity)
    }
    private func add(mesh: MDLMesh,
                     transform: TransformAnimation,
                     parentIdx: Int,
                     scene: inout RamSceneDescription) {
        assert(mesh.vertexBuffers.count == 1, "Only object that have a single buffer assigned are supported")
        let buffer = mesh.vertexBuffers[0].rawData
        let dataBuffer = DataBuffer(buffer: buffer, length: buffer.count)
        var pieceDescriptions = [RamPieceDescription]()
        guard let submeshes = mesh.submeshes as? [MDLSubmesh] else {
            fatalError("Malformed object")
        }
        submeshes.forEach {
            var materialIdx = Int.nil
            if let material = $0.material {
                materialIdx = scene.materialNames.firstIndex(of: material.name) ?? .nil
                if materialIdx == .nil {
                    materialIdx = scene.materials.count
                    scene.materialNames.append(material.name)
                    scene.materials.append(material.porcelain)
                }
            }
            guard let indexBasedDraw = $0.porcelainIndexBasedDraw else {
                fatalError("Cannot convert ModelIO type to internal type")
            }
            let description = PieceDescription(materialIdx: materialIdx,
                                               drawDescription: indexBasedDraw)
            pieceDescriptions.append(description)
        }
        scene.meshNames.append(mesh.path)
        scene.meshBuffers.append(dataBuffer)
        scene.indexDrawReferences.append(scene.indexDrawReferences.count ..< scene.indexDrawReferences.count + pieceDescriptions.count)
        for piece in pieceDescriptions {
            scene.indexDraws.append(piece.drawDescription)
            scene.indexDrawsMaterials.append(piece.materialIdx)
        }
        let entity = Entity(transform: transform,
                            type: .mesh,
                            referenceIdx: scene.meshBuffers.count - 1)
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
