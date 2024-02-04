//
//  PhotosView.swift
//  SwiftListDemo
//
//  Created by Balasubramanian Thangavel on 04/02/24.
//

import SwiftUI

struct PhotosView: View {
    @StateObject var viewModel: PhotosViewModel
    init(viewModel: PhotosViewModel = PhotosViewModel()) {
        self._viewModel = StateObject(wrappedValue: PhotosViewModel())
    }
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.photos) {
                    AsyncImage(url: URL(string: $0.thumbnailUrl)) { phase in
                        if let image = phase.image {
                            image.resizable()
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(height: 300)
                }
            }
        }
        .navigationTitle(Text("Lazy Photos"))
        .task {
            try? await viewModel.getPhotos()
        }
    }
}

#Preview {
    PhotosView()
}
