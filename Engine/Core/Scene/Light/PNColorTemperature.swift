//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// Interfece for managing color that is represented in form of white light temperature.
public protocol PNColorTemperature {
    func convert(temperature: PNKelvin) -> PNColorRGB
}
