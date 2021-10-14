//
//  CGSize.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import Foundation

extension CGSize {
    var aspectRatio: Float {
        Float(width / height)
    }
}
