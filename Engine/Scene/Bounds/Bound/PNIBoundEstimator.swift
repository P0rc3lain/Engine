//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public struct PNIBoundEstimator: PNBoundEstimator {
    public func bound(vertexBuffer buffer: Data) -> PNBound {
        assert(buffer.count % MemoryLayout<Vertex>.stride == 0, "Data must contain vertices")
        return buffer.withUnsafeBytes { pointer in
            bound(vertexBuffer: pointer)
        }
    }
    public func bound(vertexBuffer: [Vertex]) -> PNBound {
        vertexBuffer.withUnsafeBytes { pointer in
            bound(vertexBuffer: pointer)
        }
    }
    public func bound(vertexBuffer: UnsafeRawBufferPointer) -> PNBound {
        guard let pointer = vertexBuffer.bindMemory(to: Vertex.self).baseAddress else {
            fatalError("Could not cast buffer to a raw pointer")
        }
        let elementsCount = Int(vertexBuffer.count / MemoryLayout<Vertex>.stride)
        let firstVertex = pointer.pointee
        var minX = firstVertex.position.x
        var maxX = firstVertex.position.x
        var minY = firstVertex.position.y
        var maxY = firstVertex.position.y
        var minZ = firstVertex.position.z
        var maxZ = firstVertex.position.z
        for i in 1 ..< elementsCount {
            let vertex = pointer.advanced(by: i).pointee
            minX = min(vertex.position.x, minX)
            maxX = max(vertex.position.x, maxX)
            minY = min(vertex.position.y, minY)
            maxY = max(vertex.position.y, maxY)
            minZ = min(vertex.position.z, minZ)
            maxZ = max(vertex.position.z, maxZ)
        }
        return PNBound(min: [minX, minY, minZ],
                       max: [maxX, maxY, maxZ])
    }
}
