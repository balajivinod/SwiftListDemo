//
//  PhotoService.swift
//  SwiftListDemo
//
//  Created by Balasubramanian Thangavel on 03/02/24.
//

import Foundation

enum PhotoRequest: Request {
    case photosByAlbum(id: Int)
    
    var path: String {
        switch self {
        case .photosByAlbum(let id):
            return "/albums/\(id)/photos"
        }
    }
}

protocol PhotoServiceProtocol {
    func getPhotos(albumId: Int) async throws -> [Photo]
}

class PhotoService: PhotoServiceProtocol {
    let networkHandlerProtocol: NetworkHandlerProtocol
    
    init(networkHandlerProtocol: NetworkHandlerProtocol = NetworkManager()) {
        self.networkHandlerProtocol = networkHandlerProtocol
    }
    
    func getPhotos(albumId: Int) async throws -> [Photo] {
        try await networkHandlerProtocol.fetch(request: PhotoRequest.photosByAlbum(id: albumId))
    }
}
