//
//  Encodable+Extension.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import Foundation

public extension Encodable {
  /// Converting object to postable dictionary
  func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
    let data = try encoder.encode(self)
    let object = try JSONSerialization.jsonObject(with: data)
    guard let json = object as? [String: Any] else {
      let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object isn't dictionary")
      throw DecodingError.typeMismatch(type(of: object), context)
    }
    return json
  }
}
