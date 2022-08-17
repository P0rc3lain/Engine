//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Combine
import simd

class PNIRefreshController {
    private var enclosingNodeSubscription: AnyCancellable?
    private var parentSubscription: AnyCancellable?
    private var nodeTransformSubscription: AnyCancellable?
    private var parentTransformSubscription: AnyCancellable?
    init() {
        // empty
    }
    func setup(_ node: PNSceneNode) {
        enclosingNodeSubscription = node.enclosingNode.sink { [weak self] completion in
            self?.parentSubscription?.cancel()
        } receiveValue: { [weak self] scenePiece in
            guard let scenePiece = scenePiece.reference else {
                return
            }
            self?.parentSubscription = scenePiece.parentSubject.sink { [weak self] completion in
                self?.parentTransformSubscription?.cancel()
                self?.nodeTransformSubscription?.cancel()
            } receiveValue: { [weak self] parent in
                self?.nodeTransformSubscription = node.transform.sink(receiveCompletion: { completion in
                    return
                }, receiveValue: { value in
                    let parentTransform = node.enclosingNode.value.reference?.parent?.data.worldTransform.value ?? .identity
                    node.worldTransform.send(parentTransform * value)
                })
                self?.parentTransformSubscription = parent.reference?.data.worldTransform.sink(receiveCompletion: { completion in
                    return
                }, receiveValue: { value in
                    node.worldTransform.send(value * node.transform.value)
                })
            }
        }
    }
}
