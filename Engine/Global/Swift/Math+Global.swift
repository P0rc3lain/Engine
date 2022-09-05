//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public func avg<T: FloatingPoint>(_ values: T...) -> T {
    values.reduce(T(0), +) / T(values.count)
}
