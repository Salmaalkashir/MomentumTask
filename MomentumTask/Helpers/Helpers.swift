//
//  Helpers.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import Foundation

class Helpers {
    // Convert string to data asynchronously and return synchronously
    static func convertStringToDataAsync(image: String) -> Data? {
      var resultData: Data?
      
      DispatchQueue.global(qos: .background).async {
        // Check if the string represents a valid local file path
        if let url = URL(string: image), FileManager.default.fileExists(atPath: url.path) {
          do {
            resultData = try Data(contentsOf: url)
          } catch {
            print("Error loading data from file: \(error)")
          }
        } else {
          print("Invalid or non-existent file path.")
        }
        
        // Now, switch back to the main thread to update any UI or handle further tasks
        DispatchQueue.main.async {
          // Here you can use the resultData or update the UI
          // resultData can be used by your view controller or model
        }
      }
      
      // Since the method is async, it will return `nil` immediately, but the work is happening in the background
      return resultData
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
