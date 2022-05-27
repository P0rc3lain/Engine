//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Cocoa
import Metal
import MetalBinding
import ModelIO

public struct PNITerrainLoader: PNTerrainLoader {
    private let device: MTLDevice
    public init(device: MTLDevice) {
        self.device = device
    }
    static func indices(width: Int, height: Int) -> [UInt32] {
        var buffer = [UInt32]()
        for i in (height - 1).naturalExclusive {
            for j in width.naturalExclusive {
                for k in 2.naturalExclusive {
                    buffer.append(UInt32(j + width * (i + k)))
                }
            }
        }
        return buffer
    }
    static func vertices(image: NSImage) -> [Vertex]? {
        vertices(image: image) { color in
            let avg = (color.redComponent + color.blueComponent + color.greenComponent) / 3
            return Float(avg * 100)
        }
    }
    static func color(bitmap: NSBitmapImageRep, atX x: Int, atY y: Int) -> NSColor? {
        let normalizedX = max(min(x, bitmap.size.width.int - 1), 0)
        let normalizedY = max(min(y, bitmap.size.height.int - 1), 0)
        return bitmap.colorAt(x: normalizedX, y: normalizedY)
    }
    static func height(bitmap: NSBitmapImageRep,
                       atX x: Int,
                       atY y: Int,
                       heightTransform: (NSColor) -> Float) -> Float? {
        guard let color = color(bitmap: bitmap, atX: x, atY: y) else {
            return nil
        }
        return heightTransform(color)
    }
    static func normal(bitmap: NSBitmapImageRep,
                       atX x: Int,
                       atY y: Int,
                       heightTransform: (NSColor) -> Float) -> simd_float3? {
        guard let hL = height(bitmap: bitmap, atX: x - 1, atY: y, heightTransform: heightTransform),
              let hR = height(bitmap: bitmap, atX: x + 1, atY: y, heightTransform: heightTransform),
              let hU = height(bitmap: bitmap, atX: x, atY: y + 1, heightTransform: heightTransform),
              let hD = height(bitmap: bitmap, atX: x, atY: y - 1, heightTransform: heightTransform) else {
                  return nil
        }
        return simd_float3(hL - hR, hD - hU, 2).normalized
    }
    static func vertices(image: NSImage, heightTransform: (NSColor) -> Float) -> [Vertex]? {
        guard let tiff = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff) else {
            return nil
        }
        var buffer = [Vertex]()
        for i in 0 ..< image.size.height.int {
            for j in 0 ..< image.size.width.int {
                guard let color = bitmap.colorAt(x: i, y: j) else {
                    return nil
                }
                let height = heightTransform(color)
                let u = Float(i) / Float(image.size.height)
                let v = Float(j) / Float(image.size.width)
                guard let normalVector = normal(bitmap: bitmap,
                                                atX: i,
                                                atY: j,
                                                heightTransform: heightTransform) else {
                    return nil
                }
                buffer.append(Vertex(position: [-Float(image.size.height / 2) + Float(i),
                                                Float(height),
                                                -Float(image.size.width) / 2 + Float(j)],
                                      normal: normalVector,
                                      tangent: normalVector.randomPerpendicular(),
                                      textureUV: [u, v]))
            }
        }
        return buffer
    }
    public func loadMesh(image: NSImage, material: PNMaterial) -> PNMesh? {
        guard let verts = PNITerrainLoader.vertices(image: image),
              let buffer = device.makeBuffer(array: verts) else {
            return nil
        }
        var pieces = [PNPieceDescription]()
        let idx = PNITerrainLoader.indices(width: image.size.width.int,
                                           height: image.size.height.int)
        for chunk in idx.chunked(into: Int(image.size.width * 2)) {
            guard let indexBuffer = device.makeBuffer(array: chunk) else {
                return nil
            }
            let submesh = PNSubmesh(indexBuffer: PNDataBuffer(buffer: indexBuffer,
                                                              length: chunk.count),
                                    indexCount: Int(image.size.width * 2),
                                    indexType: .uint32,
                                    primitiveType: .triangleStrip)
            pieces.append(PNPieceDescription(drawDescription: submesh, material: material))
        }
        let bound = PNIBoundEstimator().bound(vertexBuffer: verts)
        return PNMesh(boundingBox: PNIBoundingBoxInteractor.default.from(bound: bound),
                      vertexBuffer: PNDataBuffer(buffer: buffer, length: verts.count),
                      pieceDescriptions: pieces,
                      culling: PNCulling(frontCulling: .front,
                                         backCulling: .back,
                                         winding: .clockwise))
    }
}
