//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public protocol PNEmitter {
    func emit(rules: PNEmissionRules) -> PNParticle
}
