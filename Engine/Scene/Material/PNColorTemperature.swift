//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public protocol PNColorTemperature {
    func convert(temperature: PNKelvin) -> PNColorRGB
}
