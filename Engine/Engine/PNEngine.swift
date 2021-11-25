//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNEngine {
    var scene: PNScene { get set }
    func draw()
    func update(drawableSize: CGSize) -> Suceeded
}
