//
//  DataBuffer.swift
//  Types
//
//  Created by Mateusz Stompór on 09/10/2021.
//

public class DataBuffer<DataType> {
    // MARK: - Properties
    public let buffer: DataType
    public let length: Int
    public let offset: Int
    // MARK: - Initialization
    public init(buffer: DataType, length: Int, offset: Int) {
        self.buffer = buffer
        self.length = length
        self.offset = offset
    }
}
