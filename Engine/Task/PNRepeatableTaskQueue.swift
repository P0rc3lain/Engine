//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public protocol PNRepeatableTaskQueue: AnyObject {
    func schedule(_ task: @escaping () -> ShouldContinueExecuting)
    func schedule(_ task: PNTask)
    func execute()
}
