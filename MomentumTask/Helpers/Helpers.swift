//
//  Helpers.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import Foundation

class Helpers {
  static func convertStringToData(image: String, completion: @escaping (Data?) -> Void) {
      if let url = URL(string: image) {
          // Perform the network request asynchronously on a background thread
          DispatchQueue.global(qos: .userInitiated).async {
              do {
                  // Fetch the data from the URL
                  let data = try Data(contentsOf: url)
                  // Call the completion handler on the main thread with the fetched data
                  DispatchQueue.main.async {
                      completion(data)
                  }
              } catch {
                  // Handle the error if the data could not be fetched
                  DispatchQueue.main.async {
                      completion(nil)
                  }
              }
          }
      } else {
          // If the URL is invalid, return nil immediately
          completion(nil)
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
  static func convertUTCDateAndTime(_ utcDateString: String) -> (date: String, time: String)? {
      let utcFormatter = DateFormatter()
      utcFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      utcFormatter.timeZone = TimeZone(abbreviation: "UTC")

      // Parse the UTC date string
      guard let date = utcFormatter.date(from: utcDateString) else {
          print("Invalid date format")
          return nil
      }

      // Formatter for date
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy/MM/dd"
      dateFormatter.timeZone = TimeZone.current

      // Formatter for time
      let timeFormatter = DateFormatter()
      timeFormatter.dateFormat = "HH:mm"
      timeFormatter.timeZone = TimeZone.current

      // Get the date and time components
      let datePart = dateFormatter.string(from: date)
      let timePart = timeFormatter.string(from: date)

      return (date: datePart, time: timePart)
  }

}
