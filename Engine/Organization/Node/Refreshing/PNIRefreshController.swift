//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Combine
import simd

class PNIRefreshController {
    private var enclosingNodeSubscription: AnyCancellable?
    private var parentSubscription: AnyCancellable?
    private var nodeTransformSubscription: AnyCancellable?
    private var localBoundingBoxSubscription: AnyCancellable?
    private var parentTransformSubscription: AnyCancellable?
    private var modelUniformsSubscription: AnyCancellable?
    private var childrenSubscription: AnyCancellable?
    private var childrenMergedBoundingBox: AnyCancellable?
    private var childrenBoundingBoxSubscription = [AnyCancellable?]()
    private let interactor = PNIBoundingBoxInteractor.default
    private let scheduler = ImmediateScheduler.shared
    init() {
        // Empty
    }
    private func setupMergedChildrenSubscription(_ node: PNSceneNode) -> AnyCancellable? {
        node.childrenMergedBoundingBox.receive(on: scheduler).sink(receiveValue: { mergedChildren in
            if let bb = node.intrinsicBoundingBox {
                if let childrenBB = mergedChildren {
                    let merged = self.interactor.merge(bb, childrenBB)
                    let aabb = self.interactor.aabb(self.interactor.multiply(node.transform.value, merged))
                    node.localBoundingBox.send(aabb)
                } else {
                    let aabb = self.interactor.aabb(self.interactor.multiply(node.transform.value, bb))
                    node.localBoundingBox.send(aabb)
                }
            } else {
                if let childrenBB = mergedChildren {
                    let aabb = self.interactor.aabb(self.interactor.multiply(node.transform.value, childrenBB))
                    node.localBoundingBox.send(aabb)
                } else {
                    node.localBoundingBox.send(nil)
                }
            }
        })
    }
    private func setupNodeTransformSubscription(_ node: PNSceneNode) -> AnyCancellable? {
        node.transform.receive(on: self.scheduler).sink(receiveValue: { value in
            if let parent = node.enclosingNode.value.reference?.parent {
                let parentTransform = parent.data.worldTransform.value
                node.worldTransform.send(parentTransform * value)
            } else {
                node.worldTransform.send(value)
            }
            if let bb = node.intrinsicBoundingBox {
                if let childrenBB = node.childrenMergedBoundingBox.value {
                    let merged = self.interactor.merge(bb, childrenBB)
                    let aabb = self.interactor.aabb(self.interactor.multiply(value, merged))
                    node.localBoundingBox.send(aabb)
                } else {
                    let aabb = self.interactor.aabb(self.interactor.multiply(value, bb))
                    node.localBoundingBox.send(aabb)
                }
            } else {
                if let childrenBB = node.childrenMergedBoundingBox.value {
                    let aabb = self.interactor.aabb(self.interactor.multiply(value, childrenBB))
                    node.localBoundingBox.send(aabb)
                } else {
                    node.localBoundingBox.send(nil)
                }
            }
        })
    }
    private func setupModelUniformsSubscription(_ node: PNSceneNode) -> AnyCancellable? {
        node.worldTransform.receive(on: scheduler).sink(receiveValue: { transform in
            node.modelUniforms.send(WModelUniforms.from(transform: transform))
        })
    }
    private func setupLocalBoundingBoxSubscription(_ node: PNSceneNode) -> AnyCancellable? {
        node.localBoundingBox.receive(on: scheduler).sink(receiveValue: { [weak self] value in
            guard let self = self else {
                return
            }
            guard let boundingBox = value else {
                node.worldBoundingBox.send(nil)
                return
            }
            guard let parent = node.enclosingNode.value.reference?.parent else {
                node.worldBoundingBox.send(boundingBox)
                return
            }
            let parentTransform = parent.data.worldTransform.value
            let transformed = self.interactor.multiply(parentTransform, boundingBox)
            node.worldBoundingBox.send(self.interactor.aabb(transformed))
        })
    }
    private func setupChildrenSubscription(_ node: PNSceneNode, _ piece: PNScenePiece) -> AnyCancellable? {
        piece.childrenSubject.sink(receiveCompletion: { [weak self] _ in
            self?.childrenBoundingBoxSubscription.forEach { $0?.cancel() }
            self?.childrenBoundingBoxSubscription = []
        }, receiveValue: { children in
            self.childrenBoundingBoxSubscription = children.map {
                $0.data.localBoundingBox.sink { _ in
                    let bbs = children.map { $0.data.localBoundingBox.value }.compactMap { $0 }
                    let merged = bbs.reduce(self.interactor.merge(_:_:))
                    node.childrenMergedBoundingBox.send(merged)
                }
            }
        })
    }
    func setup(_ node: PNSceneNode) {
        childrenMergedBoundingBox = setupMergedChildrenSubscription(node)
        localBoundingBoxSubscription = setupLocalBoundingBoxSubscription(node)
        nodeTransformSubscription = setupNodeTransformSubscription(node)
        modelUniformsSubscription = setupModelUniformsSubscription(node)
        enclosingNodeSubscription = node.enclosingNode.receive(on: scheduler).sink { [weak self] _ in
            self?.parentSubscription?.cancel()
            self?.childrenSubscription?.cancel()
        } receiveValue: { [weak self] scenePiece in
            guard let scenePiece = scenePiece.reference,
                  let self = self else {
                return
            }
            self.childrenSubscription = self.setupChildrenSubscription(node, scenePiece)
            self.parentSubscription = scenePiece.parentSubject.receive(on: self.scheduler).sink { [weak self] _ in
                self?.parentTransformSubscription?.cancel()
                self?.nodeTransformSubscription?.cancel()
                self?.localBoundingBoxSubscription?.cancel()
            } receiveValue: { [weak self] parent in
                guard let worldTransform = parent.reference?.data.worldTransform else {
                    return
                }
                self?.parentTransformSubscription = worldTransform.sink { value in
                    guard let `self` = self else {
                        return
                    }
                    node.worldTransform.send(value * node.transform.value)
                    if let localBB = node.localBoundingBox.value {
                        let aabb = self.interactor.aabb(self.interactor.multiply(value, localBB))
                        node.worldBoundingBox.send(aabb)
                    } else {
                        node.worldBoundingBox.send(nil)
                    }
                }
                self?.nodeTransformSubscription = self?.setupNodeTransformSubscription(node)
                self?.localBoundingBoxSubscription = self?.setupLocalBoundingBoxSubscription(node)
            }
        }
    }
}
