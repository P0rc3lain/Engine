//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct Material<DataType> {
    public let albedo: DataType
    public let roughness: DataType
    public let normals: DataType
    public let metallic: DataType
    public init(albedo: DataType,
                roughness: DataType,
                normals: DataType,
                metallic: DataType) {
        self.albedo = albedo
        self.roughness = roughness
        self.normals = normals
        self.metallic = metallic
    }
}
