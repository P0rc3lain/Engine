//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// Used to allow possibility of keeping weak references to objects in a collection
public class PNWeakRef<T: AnyObject> {
    public weak var reference: T?
    public init(_ reference: T?) {
        self.reference = reference
    }
}
