//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import AppKit

/// Generation of meshes based on bitmap data.
public protocol PNTerrainLoader {
    func loadMesh(image: NSImage, material: PNMaterial) -> PNMesh?
}
