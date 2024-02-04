//
//  ContentView.swift
//  SwiftListDemo
//
//  Created by Balasubramanian Thangavel on 03/02/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ViewModel
    init(viewModel: ViewModel = ViewModel()) {
        self._viewModel = StateObject(wrappedValue:  ViewModel())
    }

    var body: some View {
        List {
            ForEach(viewModel.posts) {
                PostListRow(post: $0)
            }
        }
        .task {
            try? await viewModel.loadPosts()
        }
        .listStyle(.plain)
        .navigationTitle(Text("Posts"))
    }
}

struct PostListRow: View {
    let post: Post
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(post.title)
                .font(.body)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
            Text(post.body)
                .font(.caption)
        }
    }
}

#Preview {
    ContentView()
}
