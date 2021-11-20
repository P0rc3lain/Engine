//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct AnimatedTransform<TranslationType, RotationType, ScaleType> {
    public var translation: PNAnySampleProvider<TranslationType>
    public var rotation: PNAnySampleProvider<RotationType>
    public var scale: PNAnySampleProvider<ScaleType>
    public init(translation: PNAnySampleProvider<TranslationType>,
                rotation: PNAnySampleProvider<RotationType>,
                scale: PNAnySampleProvider<ScaleType>) {
        self.translation = translation
        self.rotation = rotation
        self.scale = scale
    }
}
