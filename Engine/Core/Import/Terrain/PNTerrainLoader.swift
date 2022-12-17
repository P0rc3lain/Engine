//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import AppKit

public protocol PNTerrainLoader {
    func loadMesh(image: NSImage, material: PNMaterial) -> PNMesh?
}
