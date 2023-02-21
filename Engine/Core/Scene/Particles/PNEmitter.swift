//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// Used to emit particles over an area of the screen which can have different forms and distributions.
public protocol PNEmitter {
    func emit(rules: PNEmissionRules) -> PNParticle
}
