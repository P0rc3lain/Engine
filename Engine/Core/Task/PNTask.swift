//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// A general purpose, queueable task.
public protocol PNTask: AnyObject {
    func execute() -> PNShouldContinueExecuting
}
