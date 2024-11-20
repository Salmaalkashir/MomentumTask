//
//  Constants.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import Foundation
//MARK: - HTTPMethods
enum HTTPMethod: String {
  case GET
  case POST
  case PUT
  case DELETE
}

//MARK: - NetworkErrors
enum NetworkError: Error {
  case invalidResponse
  case requestFailed(Error)
  case decodingFailed(Error)
  case unAuthorized
  case internetIssue 
  case timeOut
}
