//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Coordinates rendering process.
public protocol PNWorkloadManager {
    func draw(sceneGraph: PNScene, taskQueue: PNRepeatableTaskQueue)
}
