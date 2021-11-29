//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

extension Array {
    public mutating func inplaceMap(transform: (Element) -> Element) {
        for index in indices {
            self[index] = transform(self[index])
        }
    }
    init(minimalCapacity: Int) {
        self.init()
        reserveCapacity(minimalCapacity)
    }
    public mutating func insert(_ newElement: Element) {
        insert(newElement, at: 0)
    }
}
