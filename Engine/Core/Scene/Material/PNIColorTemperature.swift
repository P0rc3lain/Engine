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
        let a: PNColorComponent = 329.698727446
        let b: PNColorComponent = -0.1332047592
        return clamp(value: a * pow(temperature - 60, b),
                     min: 0,
                     max: 255)
    }
    private func green(_ temperature: PNColorComponent) -> PNColorComponent {
        if temperature <= 66 {
            let a: PNColorComponent = 99.4708025861
            let b: PNColorComponent = 161.1195681661
            return clamp(value: a * log(temperature) - b,
                         min: 0,
                         max: 255)
        }
        let a: PNColorComponent = 288.1221695283
        let b: PNColorComponent = -0.0755148492
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
        let a: PNColorComponent = 138.5177312231
        let b: PNColorComponent = 305.0447927307
        return clamp(value: a * log(temperature - 10) - b,
                     min: 0,
                     max: 255)
    }
}
