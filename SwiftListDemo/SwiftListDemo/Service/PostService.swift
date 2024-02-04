//
//  PostService.swift
//  SwiftListDemo
//
//  Created by Balasubramanian Thangavel on 03/02/24.
//

import Foundation

enum PostRequest: Request {
    case getPosts
    var path: String {
        switch self {
        case .getPosts:
            return "/posts"
        }
    }
}

protocol PostServiceProtocol {
    func getPosts() async throws -> [Post]
}

class PostService: PostServiceProtocol {
    let networkHandlerProtocol: NetworkHandlerProtocol
    init(networkHandlerProtocol: NetworkHandlerProtocol = NetworkManager()) {
        self.networkHandlerProtocol = networkHandlerProtocol
    }
    func getPosts() async throws -> [Post] {
        try await networkHandlerProtocol.fetch(request: PostRequest.getPosts)
    }
}
