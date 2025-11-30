//
//  LibraryManager.swift
//  RetroDiffusionApp
//
//  Created by Thomas Ricouard on 29/11/25.
//

import UIKit
import Foundation

struct LibraryImage: Identifiable, Codable {
    let id: UUID
    let fileName: String
    let createdAt: Date
    let prompt: String?
    let model: String?
    let width: Int?
    let height: Int?

    init(id: UUID = UUID(), fileName: String, createdAt: Date = Date(), prompt: String? = nil, model: String? = nil, width: Int? = nil, height: Int? = nil) {
        self.id = id
        self.fileName = fileName
        self.createdAt = createdAt
        self.prompt = prompt
        self.model = model
        self.width = width
        self.height = height
    }
}

@MainActor
@Observable
class LibraryManager {
    private(set) var images: [LibraryImage] = []

    private let libraryDirectory: URL
    private let metadataFile: URL

    init() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        libraryDirectory = documentsPath.appendingPathComponent("Library", isDirectory: true)
        metadataFile = libraryDirectory.appendingPathComponent("metadata.json")

        try? FileManager.default.createDirectory(at: libraryDirectory, withIntermediateDirectories: true)

        loadMetadata()
    }

    func save(image: UIImage, prompt: String? = nil, model: String? = nil, width: Int? = nil, height: Int? = nil) {
        let id = UUID()
        let fileName = "\(id.uuidString).png"
        let fileURL = libraryDirectory.appendingPathComponent(fileName)

        guard let imageData = image.pngData() else {
            print("Failed to convert image to PNG data")
            return
        }

        do {
            try imageData.write(to: fileURL)

            let libraryImage = LibraryImage(
                id: id,
                fileName: fileName,
                createdAt: Date(),
                prompt: prompt,
                model: model,
                width: width,
                height: height
            )

            images.insert(libraryImage, at: 0)
            saveMetadata()
        } catch {
            print("Failed to save image: \(error)")
        }
    }

    func loadImage(for libraryImage: LibraryImage) -> UIImage? {
        let fileURL = libraryDirectory.appendingPathComponent(libraryImage.fileName)
        guard let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return UIImage(data: imageData)
    }

    func delete(_ libraryImage: LibraryImage) {
        let fileURL = libraryDirectory.appendingPathComponent(libraryImage.fileName)
        try? FileManager.default.removeItem(at: fileURL)
        images.removeAll { $0.id == libraryImage.id }
        saveMetadata()
    }

    private func loadMetadata() {
        guard let data = try? Data(contentsOf: metadataFile),
              let decoded = try? JSONDecoder().decode([LibraryImage].self, from: data) else {
            // If metadata doesn't exist, try to load from existing files
            loadFromFiles()
            return
        }
        images = decoded.sorted { $0.createdAt > $1.createdAt }
    }

    private func loadFromFiles() {
        guard let files = try? FileManager.default.contentsOfDirectory(at: libraryDirectory, includingPropertiesForKeys: nil) else {
            return
        }

        images = files
            .filter { $0.pathExtension == "png" }
            .compactMap { url in
                let fileName = url.lastPathComponent
                let idString = fileName.replacingOccurrences(of: ".png", with: "")
                guard let id = UUID(uuidString: idString) else { return nil }

                let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)
                let createdAt = attributes?[.creationDate] as? Date ?? Date()

                return LibraryImage(id: id, fileName: fileName, createdAt: createdAt)
            }
            .sorted { $0.createdAt > $1.createdAt }

        saveMetadata()
    }

    private func saveMetadata() {
        guard let data = try? JSONEncoder().encode(images) else {
            return
        }
        try? data.write(to: metadataFile)
    }
}
