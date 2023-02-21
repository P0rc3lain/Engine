//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Defines complete set of transformations for a model.
/// By using generic parameter can be used for rigid bodies as well as meshes that contain skeleton.
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
