//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

extension Array {
    public mutating func inplaceMap(transform: (Element) -> Element) {
        for i in 0 ..< count {
            self[i] = transform(self[i])
        }
    }
}
