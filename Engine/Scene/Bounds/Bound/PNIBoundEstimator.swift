//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public struct PNIBoundEstimator: PNBoundEstimator {
    public func bound(vertexBuffer buffer: Data) -> PNBound {
        assert(buffer.count % MemoryLayout<Vertex>.stride == 0, "Data must contain vertices")
        var boundToReturn = PNBound(min: .zero, max: .zero)
        buffer.withUnsafeBytes { ptr in
            boundToReturn = bound(vertexBuffer: ptr)
        }
        return boundToReturn
    }
    public func bound(vertexBuffer: [Vertex]) -> PNBound {
        vertexBuffer.withUnsafeBytes { ptr in
            return bound(vertexBuffer: ptr)
        }
    }
    public func bound(vertexBuffer: UnsafeRawBufferPointer) -> PNBound {
        let elementsCount = Int(vertexBuffer.count / MemoryLayout<Vertex>.stride)
        var minX = Float(0)
        var maxX = Float(0)
        var minY = Float(0)
        var maxY = Float(0)
        var minZ = Float(0)
        var maxZ = Float(0)
        guard let pointer = vertexBuffer.bindMemory(to: Vertex.self).baseAddress else {
            fatalError("Could not cast buffer to raw pointer")
        }
        let firstVertex = pointer.pointee
        minX = firstVertex.position.x
        maxX = firstVertex.position.x
        minY = firstVertex.position.y
        maxY = firstVertex.position.y
        minZ = firstVertex.position.z
        maxZ = firstVertex.position.z
        for i in 1 ..< elementsCount {
            let vertex = pointer.advanced(by: i).pointee
            minX = min(vertex.position.x, minX)
            maxX = max(vertex.position.x, maxX)
            minY = min(vertex.position.y, minX)
            maxY = max(vertex.position.y, maxX)
            minZ = min(vertex.position.z, minX)
            maxZ = max(vertex.position.z, maxX)
        }
        return PNBound(min: [minX, minY, minZ], max: [maxX, maxY, maxZ])
    }
}
