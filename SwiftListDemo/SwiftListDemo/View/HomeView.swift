//
//  HomeView.swift
//  SwiftListDemo
//
//  Created by Balasubramanian Thangavel on 03/02/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                NavigationLink(destination: ContentView()) {
                    Text("Show Posts")
                        .modifier(Title())
                }
                NavigationLink(destination: PhotosView()) {
                    Text("Show Albums")
                        .modifier(Title())
                }
            }
            .navigationTitle("Posts and Albums")
        }
    }
}

#Preview {
    HomeView()
}

struct CapsuleButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 200, height: 40, alignment: .center)
            .background(Color(red: 0, green: 0, blue: 0.5))
            .clipShape(Capsule())
            .foregroundColor(.white)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 20, alignment: .center)
            .font(.body)
            .foregroundStyle(.white)
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .clipShape(.rect(cornerRadius: 30))
    }
}
