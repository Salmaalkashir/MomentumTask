//
//  NetworkManager.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import Foundation
import RxSwift

//MARK: - NetworkServiceProtocol
protocol NetworkServiceProtocol {
  func requestData<T: Decodable>(_ type: T.Type, request: URLRequest) -> Observable<T>
}

//MARK: - NetworkService
class NetworkService: NetworkServiceProtocol {
  func requestData<T: Decodable>(_ type: T.Type, request: URLRequest) -> Observable<T> {
    return Observable.create { observer in
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
          print("Network error: \(error)")
          if (error as NSError).code == NSURLErrorNotConnectedToInternet {
            observer.onError(NetworkError.internetIssue)
          } else if (error as NSError).code == NSURLErrorTimedOut {
            observer.onError(NetworkError.timeOut)
          } else {
            observer.onError(NetworkError.requestFailed(error))
          }
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
          print("Invalid response")
          observer.onError(NetworkError.invalidResponse)
          return
        }
        
        switch httpResponse.statusCode {
        case 200...300:
          guard let data = data else {
            print("No data received")
            observer.onError(NetworkError.invalidResponse)
            return
          }
          
          do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            print("Decoded data: \(decodedData)")
            observer.onNext(decodedData)
            observer.onCompleted()
          } catch let decodingError {
            print("Decoding failed: \(decodingError)")
            observer.onError(NetworkError.decodingFailed(decodingError))
          }
          
        case 401:
          observer.onError(NetworkError.unAuthorized)
        default:
          observer.onError(NetworkError.invalidResponse)
        }
      }
      
      task.resume() 
      
      return Disposables.create {
        task.cancel()
      }
    }
  }
}
