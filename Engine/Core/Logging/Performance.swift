//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

import os.signpost

let plogger = OSLog(subsystem: Bundle.current.bundleIdentifierSafe, category: "performance")
let psignposter = OSSignposter(logHandle: plogger)
