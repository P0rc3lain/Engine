//
//  Extension+PieceDescription.swift
//  Engine
//
//  Created by Mateusz Stompór on 14/10/2021.
//

import Metal

extension RamPieceDescription {
    func upload(device: MTLDevice) -> GPUPieceDescription? {
        guard let drawDescription = drawDescription.upload(device: device) else {
            return nil
        }
        return GPUPieceDescription(materialIdx: materialIdx,
                                   drawDescription: drawDescription)
    }
}
