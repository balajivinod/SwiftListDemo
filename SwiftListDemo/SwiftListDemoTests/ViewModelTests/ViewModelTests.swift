//
//  ViewModelTests.swift
//  SwiftListDemoTests
//
//  Created by Balasubramanian Thangavel on 04/02/24.
//

import XCTest
@testable import SwiftListDemo

final class ViewModelTests: XCTestCase {
    var postListViewModel: ViewModel!
    var postService: MockPostService!
    
    override func setUpWithError() throws {
        postService = MockPostService()
        postListViewModel = ViewModel()
    }
    
    override func tearDownWithError() throws {
        postListViewModel = nil
        postService = nil
    }
    
    func testPostViewModelReturnsPosts() async throws {
        try await postListViewModel!.loadPosts()
        let posts = postListViewModel!.posts
        
        // verify count
        XCTAssertEqual(posts.count, 100)
        
        let first = try XCTUnwrap(posts.first)
        XCTAssertEqual(first.userId, 1)
        XCTAssertEqual(first.id, 1)
        
        let last = try XCTUnwrap(posts.last)
        XCTAssertEqual(last.title, "at nam consequatur ea labore ea harum")
        XCTAssertEqual(last.body, "cupiditate quo est a modi nesciunt soluta\nipsa voluptas error itaque dicta in\nautem qui minus magnam et distinctio eum\naccusamus ratione error aut")
    }
    
}

class MockPostService: PostServiceProtocol {
    var shouldFail: Bool = false
    func getPosts() async throws -> [Post] {
        guard !shouldFail else {
            throw RequestError.failed(description: "No posts found")
        }
        return try Bundle.test.decodableObject(forResource: "posts", type: [Post].self)
    }
}
