//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public class PNWeakRef<T: AnyObject> {
    public weak var reference: T?
    public init(_ reference: T?) {
        self.reference = reference
    }
}
