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
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    var bytesCount: Int {
        MemoryLayout<Element>.stride * count
    }
    public func reduce( _ nextPartialResult: (Element, Element) throws -> Element) rethrows -> Element? {
        guard let first = first else {
            // allowed
            // no assertion needed
            return nil
        }
        return try dropFirst().reduce(first, nextPartialResult)
    }
}
