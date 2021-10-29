//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct AnimatedTransform<TranslationType, RotationType, ScaleType> {
    public var translation: AnimatedValue<TranslationType>
    public var rotation: AnimatedValue<RotationType>
    public var scale: AnimatedValue<ScaleType>
    public init(translation: AnimatedValue<TranslationType>,
                rotation: AnimatedValue<RotationType>,
                scale: AnimatedValue<ScaleType>) {
        self.translation = translation
        self.rotation = rotation
        self.scale = scale
    }
}
