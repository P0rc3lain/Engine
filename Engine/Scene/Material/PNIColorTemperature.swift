//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

class PNIColorTemperature: PNColorTemperature {
    func convert(temperature: PNKelvin) -> PNColorRGB {
        assertInBound(value: temperature, min: 1_000, max: 40_000)
        let tmp = PNColorComponent(temperature / 100)
        return [red(tmp), green(tmp), blue(tmp)]
    }
    private func red(_ temperature: PNColorComponent) -> PNColorComponent {
        if temperature <= 66 {
            return 255
        }
        let a: PNColorComponent = 329.698_727_446
        let b: PNColorComponent = -0.133_204_759_2
        return clamp(value: a * pow(temperature - 60, b),
                     min: 0,
                     max: 255)
    }
    private func green(_ temperature: PNColorComponent) -> PNColorComponent {
        if temperature <= 66 {
            let a: PNColorComponent = 99.470_802_586_1
            let b: PNColorComponent = 161.119_568_166_1
            return clamp(value: a * log(temperature) - b,
                         min: 0,
                         max: 255)
        }
        let a: PNColorComponent = 288.122_169_528_3
        let b: PNColorComponent = -0.075_514_849_2
        return clamp(value: a * pow(temperature - 60, b),
                     min: 0,
                     max: 255)
    }
    private func blue(_ temperature: PNColorComponent) -> PNColorComponent {
        if temperature >= 66 {
            return 255
        } else if temperature <= 19 {
            return 0
        }
        let a: PNColorComponent = 138.517_731_223_1
        let b: PNColorComponent = 305.044_792_730_7
        return clamp(value: a * log(temperature - 10) - b,
                     min: 0,
                     max: 255)
    }
}
