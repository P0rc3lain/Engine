//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Combine

extension Publisher {
    public func sink(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: receiveValue)
    }
}
