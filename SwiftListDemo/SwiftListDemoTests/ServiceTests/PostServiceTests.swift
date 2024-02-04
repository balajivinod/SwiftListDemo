//
//  PostServiceTests.swift
//  SwiftListDemoTests
//
//  Created by Balasubramanian Thangavel on 03/02/24.
//

import XCTest
@testable import SwiftListDemo

class PostServiceTests: XCTestCase {
    var postService: PostService?
    
    override func setUpWithError() throws {
        postService = PostService(networkHandlerProtocol: MockNetworkHandler())
    }
    
    override func tearDownWithError() throws {
        postService = nil
    }
    
    func testGetPostsService() async throws {
        let posts = try await postService!.getPosts()

        let firstPost = try XCTUnwrap(posts.first)
        XCTAssertEqual(firstPost.id, 1)
        XCTAssertEqual(firstPost.userId, 1)
        XCTAssertEqual(firstPost.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
        
        let lastPost = try XCTUnwrap(posts.last)
        XCTAssertEqual(lastPost.id, 100)
        XCTAssertEqual(lastPost.userId, 10)
        XCTAssertEqual(lastPost.title, "at nam consequatur ea labore ea harum")
    }
}

fileprivate class MockNetworkHandler: NetworkHandlerProtocol {
    func fetch<T>(request: Request) async throws -> T where T : Decodable {
        try Bundle.test.decodableObject(forResource: "posts", type: T.self)
    }
}
