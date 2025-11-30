//
//  LibraryView.swift
//  RetroDiffusionApp
//
//  Created by Thomas Ricouard on 29/11/25.
//

import SwiftUI

struct LibraryView: View {
    @Environment(LibraryManager.self) private var libraryManager
    @Namespace private var namespace

    private let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 2)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if libraryManager.images.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)

                        Text("No images yet")
                            .font(.title2)
                            .foregroundColor(.secondary)

                        Text("Generated images will appear here")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(libraryManager.images) { libraryImage in
                                NavigationLink {
                                    LibraryDetailView(libraryImage: libraryImage)
                                        .navigationTransition(.zoom(sourceID: libraryImage.id.uuidString, in: namespace))
                                } label: {
                                    LibraryThumbnailView(libraryImage: libraryImage)
                                        .matchedTransitionSource(id: libraryImage.id.uuidString, in: namespace)
                                }
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
            }
            .navigationTitle("Library")
        }
    }
}

#Preview {
    LibraryView()
        .environment(LibraryManager())
}
