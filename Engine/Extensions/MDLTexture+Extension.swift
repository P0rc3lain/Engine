//
//  MDLTexture.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

import ModelIO

extension MDLTexture {
    var porcelain: Texture? {
        guard let data = texelDataWithTopLeftOrigin() else {
            return nil
        }
        return Texture(data: data,
                       dimensions: dimensions,
                       rowStride: rowStride,
                       channelCount: channelCount,
                       channelEncoding: ChannelEncoding(rawValue: channelEncoding.rawValue)!,
                       isCube: isCube,
                       mipLevelCount: mipLevelCount)
    }
}
