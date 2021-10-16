//
//  Double+Extension.swift
//  Engine
//
//  Created by Mateusz Stompór on 16/10/2021.
//

extension Double {
    func clamp(min lowerBound: Double, max highBound: Double) -> Double {
        return max(min(self, highBound), lowerBound)
    }
}
