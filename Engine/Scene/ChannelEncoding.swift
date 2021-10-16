//
//  ChannelEncoding.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

public enum ChannelEncoding: Int {
    // MARK: - Cases
    case uInt8 = 1
    case uInt16 = 2
    case uInt24 = 3
    case uInt32 = 4
    case float16 = 258
    case float32 = 260
    case float16SR = 770
}
