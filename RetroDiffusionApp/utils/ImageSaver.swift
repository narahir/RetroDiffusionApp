//
//  ImageSaver.swift
//  RetroDiffusionApp
//
//  Created by Thomas Ricouard on 29/11/25.
//

import UIKit
import Photos

actor ImageSaver {
    enum SaveError: LocalizedError, Sendable {
        case unauthorized
        case saveFailed(String)

        var errorDescription: String? {
            switch self {
            case .unauthorized:
                return "Photo library access is required to save images. Please enable it in Settings."
            case .saveFailed(let message):
                return message
            }
        }
    }

    enum SaveResult: Sendable {
        case success
        case failure(SaveError)
    }

    func save(image: UIImage) async -> SaveResult {
        let status = await requestAuthorization()
        guard status == .authorized || status == .limited else {
            return .failure(.unauthorized)
        }

        do {
            try await performSave(image: image)
            return .success
        } catch let error as SaveError {
            return .failure(error)
        } catch {
            return .failure(.saveFailed(error.localizedDescription))
        }
    }

    private func requestAuthorization() async -> PHAuthorizationStatus {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                continuation.resume(returning: status)
            }
        }
    }

    private func performSave(image: UIImage) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: SaveError.saveFailed("Failed to save image"))
                }
            }
        }
    }
}
