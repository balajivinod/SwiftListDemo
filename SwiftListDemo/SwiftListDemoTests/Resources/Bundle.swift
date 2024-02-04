//
//  Bundle.swift
//  SwiftListDemoTests
//
//  Created by Balasubramanian Thangavel on 03/02/24.
//

import Foundation
extension Bundle {
    static var test: Bundle {
        Bundle(for: PostServiceTests.self)
    }

    func fileData(forResource resource: String) throws -> Data {
        let filePath = path(forResource: resource, ofType: "json") ?? ""
        let url = URL(fileURLWithPath: filePath)
        return try Data(contentsOf: url)
    }
    
    func decodableObject<T: Decodable>(forResource resource: String, type: T.Type) throws -> T {
        let data = try fileData(forResource: resource)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
