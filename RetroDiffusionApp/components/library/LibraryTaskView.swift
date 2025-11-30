//
//  LibraryTaskView.swift
//  RetroDiffusionApp
//
//  Created by Thomas Ricouard on 29/11/25.
//

import SwiftUI

struct LibraryTaskView: View {
    let task: GenerationTask

    var body: some View {
        Group {
            if task.isInProgress {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay {
                        VStack(spacing: 8) {
                            ProgressView()
                                .tint(.white)
                            Text("Processing...")
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }
            } else if task.isPending {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "clock")
                                .foregroundColor(.secondary)
                            Text("Queued")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
            } else if let image = task.resultImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            } else if task.isFailed {
                Rectangle()
                    .fill(Color.red.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                            Text("Failed")
                                .font(.caption2)
                                .foregroundColor(.red)
                        }
                    }
            }
        }
    }
}

#Preview {
    LibraryTaskView(
        task: GenerationTask(
            type: .generate,
            state: .inProgress,
            prompt: "A test prompt"
        )
    )
}
