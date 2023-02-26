//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// Interprets interactions made by the user.
public protocol PNScreenInteractor {
    func pick(camera: PNCameraNode,
              scene: PNScene,
              point: PNPoint2D) -> [PNScenePiece]
}
