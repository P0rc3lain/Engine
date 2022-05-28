//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLLibrary {
    func labeled(_ label: String) -> MTLLibrary {
        self.label = label
        return self
    }
}
