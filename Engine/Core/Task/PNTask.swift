//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public protocol PNTask: AnyObject {
    func execute() -> PNShouldContinueExecuting
}
