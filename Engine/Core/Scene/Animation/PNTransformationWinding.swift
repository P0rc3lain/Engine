//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// Defines how transformations should be stacked together
public enum PNTransformationWinding {
    /// translation * rotation * scale
    case trs
    /// rotation * translation * scale
    case rts
}
