//
//  Texture.swift
//  Engine
//
//  Created by Mateusz Stompór on 14/10/2021.
//

import simd
import ModelIO

public struct Texture {
    // MARK: - Properties
    public var texture: MDLTexture! = nil
    public let data: Data
    public let dimensions: vector_int2
    public let rowStride: Int
    public let channelCount: Int
    public let channelEncoding: ChannelEncoding
    public let isCube: Bool
    public let mipLevelCount: Int
}
