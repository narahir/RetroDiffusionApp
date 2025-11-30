//
//  GenerationTask.swift
//  RetroDiffusionApp
//
//  Created by Thomas Ricouard on 29/11/25.
//

import Foundation
import UIKit

enum GenerationTaskType {
  case generate
  case pixelate
}

enum GenerationTaskState: Equatable {
  case pending
  case inProgress
  case completed(UIImage)
  case failed(String)

  static func == (lhs: GenerationTaskState, rhs: GenerationTaskState) -> Bool {
    switch (lhs, rhs) {
    case (.pending, .pending), (.inProgress, .inProgress):
      return true
    case (.completed(let lhsImage), .completed(let rhsImage)):
      return lhsImage.pngData() == rhsImage.pngData()
    case (.failed(let lhsError), .failed(let rhsError)):
      return lhsError == rhsError
    default:
      return false
    }
  }
}

struct GenerationTask: Identifiable, Equatable {
  let id: UUID
  let type: GenerationTaskType
  let createdAt: Date
  let prompt: String?
  let model: RetroDiffusionModel?
  let width: Int?
  let height: Int?
  let sourceImage: UIImage?

  var state: GenerationTaskState

  init(
    id: UUID = UUID(),
    type: GenerationTaskType,
    state: GenerationTaskState = .pending,
    createdAt: Date = Date(),
    prompt: String? = nil,
    model: RetroDiffusionModel? = nil,
    width: Int? = nil,
    height: Int? = nil,
    sourceImage: UIImage? = nil
  ) {
    self.id = id
    self.type = type
    self.state = state
    self.createdAt = createdAt
    self.prompt = prompt
    self.model = model
    self.width = width
    self.height = height
    self.sourceImage = sourceImage
  }

  static func == (lhs: GenerationTask, rhs: GenerationTask) -> Bool {
    lhs.id == rhs.id && lhs.state == rhs.state
  }

  var isPending: Bool {
    if case .pending = state {
      return true
    }
    return false
  }

  var isInProgress: Bool {
    if case .inProgress = state {
      return true
    }
    return false
  }

  var isCompleted: Bool {
    if case .completed = state {
      return true
    }
    return false
  }

  var isFailed: Bool {
    if case .failed = state {
      return true
    }
    return false
  }

  var resultImage: UIImage? {
    if case .completed(let image) = state {
      return image
    }
    return nil
  }

  var errorMessage: String? {
    if case .failed(let message) = state {
      return message
    }
    return nil
  }
}
