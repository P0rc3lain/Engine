//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Combine

/// Subscribable subject that the user can hook to, in order to receive information when change occurs.
public typealias PNSubject<T> = CurrentValueSubject<T, Error>
