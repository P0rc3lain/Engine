//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

import PNShared

class PNBoundingBoxCreator {
    static func vertices(boundingBoxes: [PNBoundingBox?]) -> [VertexP] {
        boundingBoxes.compactMap { $0 } .map { vertices(bb: $0) }.reduce(+) ?? []
    }
    static private func vertices(bb: PNBoundingBox) -> [VertexP] {
        [
            VertexP(position: bb.cornersLower.columns.0.xyz),
            VertexP(position: bb.cornersLower.columns.1.xyz),
            
            VertexP(position: bb.cornersLower.columns.1.xyz),
            VertexP(position: bb.cornersLower.columns.3.xyz),
            
            VertexP(position: bb.cornersLower.columns.1.xyz),
            VertexP(position: bb.cornersLower.columns.2.xyz),
            
            VertexP(position: bb.cornersLower.columns.2.xyz),
            VertexP(position: bb.cornersLower.columns.3.xyz),
            
            VertexP(position: bb.cornersLower.columns.2.xyz),
            VertexP(position: bb.cornersLower.columns.0.xyz),
            
            VertexP(position: bb.cornersLower.columns.3.xyz),
            VertexP(position: bb.cornersLower.columns.0.xyz),
            
            VertexP(position: bb.cornersUpper.columns.0.xyz),
            VertexP(position: bb.cornersLower.columns.0.xyz),
            
            VertexP(position: bb.cornersUpper.columns.1.xyz),
            VertexP(position: bb.cornersLower.columns.1.xyz),
            
            VertexP(position: bb.cornersUpper.columns.2.xyz),
            VertexP(position: bb.cornersLower.columns.2.xyz),
            
            VertexP(position: bb.cornersUpper.columns.3.xyz),
            VertexP(position: bb.cornersLower.columns.3.xyz),
            
            VertexP(position: bb.cornersUpper.columns.0.xyz),
            VertexP(position: bb.cornersUpper.columns.1.xyz),
            
            VertexP(position: bb.cornersUpper.columns.1.xyz),
            VertexP(position: bb.cornersUpper.columns.3.xyz),
            
            VertexP(position: bb.cornersUpper.columns.1.xyz),
            VertexP(position: bb.cornersUpper.columns.2.xyz),
            
            VertexP(position: bb.cornersUpper.columns.2.xyz),
            VertexP(position: bb.cornersUpper.columns.3.xyz),
            
            VertexP(position: bb.cornersUpper.columns.2.xyz),
            VertexP(position: bb.cornersUpper.columns.0.xyz),
            
            VertexP(position: bb.cornersUpper.columns.3.xyz),
            VertexP(position: bb.cornersUpper.columns.0.xyz)
        ]
    }
}
