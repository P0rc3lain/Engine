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
    func setup(_ node: PNSceneNode) {
        childrenMergedBoundingBox = node.childrenMergedBoundingBox.receive(on: scheduler).sink(receiveValue: { mergedChildren in
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
        nodeTransformSubscription = node.transform.receive(on: scheduler).sink(receiveValue: { value in
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
        modelUniformsSubscription = node.worldTransform.receive(on: scheduler).sink(receiveValue: { transform in
            node.modelUniforms.send(WModelUniforms.from(transform: transform))
        })
        enclosingNodeSubscription = node.enclosingNode.receive(on: scheduler).sink { [weak self] completion in
            self?.parentSubscription?.cancel()
            self?.childrenSubscription?.cancel()
        } receiveValue: { [weak self] scenePiece in
            guard let scenePiece = scenePiece.reference,
                  let self = self else {
                return
            }
            self.childrenSubscription = scenePiece.childrenSubject.sink(receiveCompletion: { [weak self] completion in
                self?.childrenBoundingBoxSubscription.forEach { $0?.cancel() }
                self?.childrenBoundingBoxSubscription = []
            }, receiveValue: { children in
                guard let self = self else {
                    return
                }
                self.childrenBoundingBoxSubscription = children.map { $0.data.localBoundingBox.sink { _ in
                    let bbs = children.map { $0.data.localBoundingBox.value } .filter { $0 != nil }.map { $0! }
                    let merged = bbs.reduce(self.interactor.merge(_:_:))
                    node.childrenMergedBoundingBox.send(merged)
                }}
            })
            self.parentSubscription = scenePiece.parentSubject.receive(on: self.scheduler)
                                                              .sink { [weak self] completion in
                self?.parentTransformSubscription?.cancel()
                self?.nodeTransformSubscription?.cancel()
            } receiveValue: { [weak self] parent in
                self?.parentTransformSubscription = parent.reference?.data.worldTransform.sink(receiveValue: { value in
                    node.worldTransform.send(value * node.transform.value)
                })
                guard let self = self else {
                    return
                }
                self.localBoundingBoxSubscription = node.localBoundingBox.receive(on: self.scheduler)
                                                                         .sink(receiveValue: { [weak self] value in
                    guard let self = self else {
                        return
                    }
                    if let bb = value {
                        if let parent = node.enclosingNode.value.reference?.parent {
                            let parentTransform = parent.data.worldTransform.value
                            let transformed = self.interactor.multiply(parentTransform, bb)
                            node.worldBoundingBox.send(self.interactor.aabb(transformed))
                        } else {
                            node.worldBoundingBox.send(bb)
                        }
                    } else {
                        node.worldBoundingBox.send(nil)
                    }
                })
            }
        }
    }
}
