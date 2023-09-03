//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Combine

/// A subject for observing PNScenePiece changes.
public typealias PNScenePieceSubject = PNSubject<PNWeakRef<PNScenePiece>>
