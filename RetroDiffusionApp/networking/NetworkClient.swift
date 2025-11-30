//
//  NetworkClient.swift
//  RetroDiffusionApp
//
//  Created by Thomas Ricouard on 29/11/25.
//

import Foundation
import UIKit
import Observation

@MainActor
@Observable
final class NetworkClient {
    private let networking = Networking()

    func updateAPIKey(_ newKey: String?) {
        Task { await networking.updateAPIKey(newKey) }
    }

    func pixelateImage(_ image: UIImage) async throws -> UIImage {
        try await networking.pixelateImage(image)
    }

    func generateImage(
        prompt: String,
        style: RetroDiffusionModel,
        width: Int = 256,
        height: Int = 256
    ) async throws -> UIImage {
        try await networking.generateImage(
            prompt: prompt,
            style: style,
            width: width,
            height: height
        )
    }

    func checkCredits() async throws -> Int {
        try await networking.checkCredits()
    }

    func checkPixelateCost(_ image: UIImage) async throws -> Double {
        try await networking.checkPixelateCost(image)
    }

    func checkGenerateCost(
        prompt: String,
        style: RetroDiffusionModel,
        width: Int,
        height: Int
    ) async throws -> Double {
        try await networking.checkGenerateCost(
            prompt: prompt,
            style: style,
            width: width,
            height: height
        )
    }
}
