//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNAnimatedTransform<TranslationType, RotationType, ScaleType> {
    public var translation: PNKeyframeAnimation<TranslationType>
    public var rotation: PNKeyframeAnimation<RotationType>
    public var scale: PNKeyframeAnimation<ScaleType>
    public init(translation: PNKeyframeAnimation<TranslationType>,
                rotation: PNKeyframeAnimation<RotationType>,
                scale: PNKeyframeAnimation<ScaleType>) {
        self.translation = translation
        self.rotation = rotation
        self.scale = scale
    }
}
