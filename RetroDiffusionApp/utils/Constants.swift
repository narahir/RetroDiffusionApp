//
//  Constants.swift
//  RetroDiffusionApp
//
//  Created by Thomas Ricouard on 29/11/25.
//

import Foundation

enum Constants {
    enum UserDefaultsKeys {
        static let customAPIKey = "custom_api_key"
    }

    enum URLs {
        static let retrodiffusionWebsite = "https://retrodiffusion.ai"
        static let githubRepository = "https://github.com/Dimillian/RetroDiffusionApp"
    }

    /// Size constraints based on RetroDiffusion API documentation
    /// https://github.com/Retro-Diffusion/api-examples
    enum SizeConstraints {
        /// Minimum size supported by the API (for image editing and tileset single tiles)
        static let minSize = 16

        /// Maximum size for regular image generation models
        static let maxSize = 1024

        /// Maximum size for tileset single tiles
        static let maxTileSize = 64

        /// Maximum size for image editing
        static let maxEditSize = 256
    }
}
