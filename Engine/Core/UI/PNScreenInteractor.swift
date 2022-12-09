//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public protocol PNScreenInteractor {
    func pick(camera: PNCameraNode,
              scene: PNScene,
              point: PNPoint2D) -> [PNScenePiece]
}
