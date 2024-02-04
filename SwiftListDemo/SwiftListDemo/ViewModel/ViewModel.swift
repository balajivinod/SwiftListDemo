//
//  ViewModel.swift
//  SwiftListDemo
//
//  Created by Balasubramanian Thangavel on 03/02/24.
//

import Foundation

final class ViewModel: ObservableObject {
    private var postService: PostServiceProtocol
    init(postService: PostServiceProtocol = PostService()) {
        self.postService = postService
    }

    @Published var posts: [Post] = []
    
    @MainActor
    func loadPosts() async throws {
        posts = try await postService.getPosts()
    }
}
