//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd
import ModelIO

public class Translator {
    // MARK: - Initialization
    public init() { }
    // MARK: - Public
    public func process(asset: MDLAsset) -> RamSceneDescription {
        var scene = RamSceneDescription()
        asset.walk { object in
            scene.objectNames.append(object.path)
            let parentIdx = object.parent != nil ? scene.objectNames.firstIndex(of: object.parent!.path)! : .nil
            let transform = object.transform?.decompose ?? .static
            if let object = object as? MDLCamera {
                scene.cameraNames.append(object.path)
                scene.cameras.append(object.porcelain)
                let entity = Entity(transform: transform,
                                    type: .camera,
                                    referenceIdx: scene.cameras.count - 1)
                scene.objects.add(parentIdx: parentIdx, data: entity)
            } /* else if let object = object as? MDLLight {
                fatalError("Not implemented")
            } */ else if let object = object as? MDLMesh {
                assert(object.vertexBuffers.count == 1, "Only object that have a single buffer assigned are supported")
                let buffer = object.vertexBuffers[0].rawData
                let dataBuffer = DataBuffer(buffer: buffer, length: buffer.count, offset: 0)
                var pieceDescriptions = [RamPieceDescription]()
                (object.submeshes as! [MDLSubmesh]).forEach {
                    var materialIdx = Int.nil
                    if let material = $0.material {
                        materialIdx = scene.materialNames.firstIndex(of: material.name) ?? .nil
                        if materialIdx == .nil {
                            materialIdx = scene.materials.count
                            scene.materialNames.append(material.name)
                            scene.materials.append(material.porcelain)
                        }
                    }
                    let description = PieceDescription(materialIdx: materialIdx,
                                                       drawDescription: $0.porcelainIndexBasedDraw)
                    pieceDescriptions.append(description)
                }
                let geometry = Geometry(vertexBuffer: dataBuffer, pieceDescriptions: pieceDescriptions)
                scene.meshNames.append(object.path)
                scene.meshes.append(geometry)
                let entity = Entity(transform: transform,
                                    type: .mesh,
                                    referenceIdx: scene.meshes.count - 1)
                scene.objects.add(parentIdx: parentIdx, data: entity)
            } else {
                let entity = Entity(transform: transform,
                                    type: .group,
                                    referenceIdx: .nil)
                scene.objects.add(parentIdx: parentIdx, data: entity)
            }
            if let animationBindComponent = object.componentConforming(to: MDLComponent.self) as?
                MDLAnimationBindComponent {
                guard let skeleton = animationBindComponent.skeleton, !skeleton.jointPaths.isEmpty else {
                    fatalError("Animation Bind Component is missing a skeleton or the jointPaths is empty")
                }
                if let jointAnimation = animationBindComponent.jointAnimation as? MDLPackedJointAnimation {
                    assert(skeleton.jointPaths == jointAnimation.jointPaths, "Skeleton and animation must describe exactu number of joints")
                    scene.skeletalAnimations.append(SkeletalAnimation(translations: jointAnimation.translations,
                                                                      rotations: jointAnimation.rotations,
                                                                      scales: jointAnimation.scales))
                    // TODO use geometry bind transform
                    let skeleton = Skeleton(localBindTransforms: skeleton.jointBindTransforms.float4x4Array,
                                            parentIndices: jointAnimation.jointPaths.map { parentIndex(jointPaths: jointAnimation.jointPaths, jointPath: $0) })
                    scene.animationReferences.append(scene.skeletalAnimations.count - 1 ..< scene.skeletalAnimations.count)
                    scene.skeletons.append(skeleton)
                    scene.skeletonReferences.append(scene.skeletons.count - 1)
                } else {
                    fatalError("Unhandled case")
                }
            } else {
                scene.skeletonReferences.append(Int.nil)
            }
        }
        assert(scene.objectNames.count == scene.objects.count, "There must be the same number of names as objects")
        assert(scene.cameraNames.count == scene.cameras.count, "There must be the same number of names as objects")
        assert(scene.meshNames.count == scene.meshes.count, "There must be the same number of names as objects")
        assert(scene.materialNames.count == scene.materials.count, "There must be the same number of names as objects")
        assert(Set(scene.objectNames).count == scene.objectNames.count, "Object names must be unique")
        assert(Set(scene.cameraNames).count == scene.cameraNames.count, "Camera names must be unique")
        assert(Set(scene.meshNames).count == scene.meshNames.count, "Mesh names must be unique")
        assert(Set(scene.materialNames).count == scene.materialNames.count, "Mesh names must be unique")
        assert(scene.objects.count == scene.skeletonReferences.count, "Each object should have reference to a skeleton")
        return scene
    }
    // MARK: - Private
    private func parentIndex(jointPaths: [String], jointPath: String) -> Int {
        let components = jointPath.components(separatedBy: "/")
        if components.count > 1 {
            let parentPath = components[0..<components.count-1].joined(separator: "/")
            return jointPaths.firstIndex(of: parentPath)!
        } else {
            return .nil
        }
    }
}
