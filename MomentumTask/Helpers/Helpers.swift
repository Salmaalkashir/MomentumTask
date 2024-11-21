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
  
static func convertUTCDateString(_ utcDateString: String) -> String? {
      let utcFormatter = DateFormatter()
      utcFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      utcFormatter.timeZone = TimeZone(abbreviation: "UTC")

      guard let date = utcFormatter.date(from: utcDateString) else {
          print("Invalid date format")
          return nil
      }
    
      let displayFormatter = DateFormatter()
      displayFormatter.dateFormat = "yyyy/MM/dd, HH:mm"
      displayFormatter.timeZone = TimeZone.current

      let formattedDate = displayFormatter.string(from: date)
      
      return formattedDate
  }
}
