//
//  PhotosViewModel.swift
//  SwiftListDemo
//
//  Created by Balasubramanian Thangavel on 03/02/24.
//

import Foundation
class PhotosViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    let photoService: PhotoServiceProtocol
    
    init(service: PhotoServiceProtocol = PhotoService()) {
        self.photoService = service
    }
    
    func getPhotos() async throws {
        let _photos = try await photoService.getPhotos(albumId: 1)
        await MainActor.run {
            self.photos = _photos
        }
    }
    
    func photoUrl(at indexPath: IndexPath) -> String {
        photos[indexPath.row].url
    }
}
