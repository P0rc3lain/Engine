//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// Queue capable of handling task enqueuing and their execution.
public protocol PNRepeatableTaskQueue: AnyObject {
    func schedule(_ task: @escaping () -> PNShouldContinueExecuting)
    func schedule(_ task: PNTask)
    func execute()
}
