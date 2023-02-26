//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// A node for storing model having both skin and associated skeleton.
public protocol PNRiggedMeshNode: PNMeshNode {
    var skeleton: PNSkeleton { get }
}
