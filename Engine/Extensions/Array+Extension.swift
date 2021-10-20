//
//  Array+Extension.swift
//  Array+Extension
//
//  Created by Mateusz Stompór on 20/10/2021.
//

extension Array {
    public mutating func inplaceMap(transform: (Element)->Element) {
        for i in 0 ..< count {
            self[i] = transform(self[i])
        }
    }
}
