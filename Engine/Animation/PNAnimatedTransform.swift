//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNAnimatedTransform<TranslationType, RotationType, ScaleType> {
    public var translation: PNAnyAnimatedValue<TranslationType>
    public var rotation: PNAnyAnimatedValue<RotationType>
    public var scale: PNAnyAnimatedValue<ScaleType>
    public init(translation: PNAnyAnimatedValue<TranslationType>,
                rotation: PNAnyAnimatedValue<RotationType>,
                scale: PNAnyAnimatedValue<ScaleType>) {
        self.translation = translation
        self.rotation = rotation
        self.scale = scale
    }
}
