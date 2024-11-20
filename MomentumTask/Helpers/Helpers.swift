//
//  Helpers.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import Foundation

class Helpers {
  static func convertStringToData(image: String) -> Data? {
    guard let url = URL(string: image) else {
      print("Invalid URL")
      return nil
    }
    do {
      return try Data(contentsOf: url)
    } catch {
      print("Error loading data from URL: \(error)")
      return nil
    }
  }
}
