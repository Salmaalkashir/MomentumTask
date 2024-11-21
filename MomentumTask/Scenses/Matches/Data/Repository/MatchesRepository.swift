//
//  MatchRepository.swift
//  MomentumTask
//
//  Created by Salma on 2024-11-21.
//

import Foundation
import RxSwift
import CoreData
//MARK: - MatchRepositoryProtocol
protocol MatchRepositoryProtocol {
  func getMatchDetails(matchID: Int) -> Observable<Match>
  func retrieveMatchDetailsFromCoreData(matchID: Int) -> [NSManagedObject]
}

//MARK: - MatchRepository
class MatchRepository: MatchRepositoryProtocol {
  private let networkService: NetworkServiceProtocol
  private let coreData: CoreDataManagerProtocol
  private let disposeBag = DisposeBag()
  
  init(networkService: NetworkServiceProtocol = NetworkService(), coreData: CoreDataManagerProtocol = CoreDataManager.getObj()) {
    self.networkService = networkService
    self.coreData = coreData
  }
  
  func getMatchDetails(matchID: Int) -> Observable<Match> {
    let request = APIBuilder()
      .setUrl(hostUrl: "https://api.football-data.org/v4/matches/\(matchID)")
      .setHeaders(key: "X-Auth-Token", value: "43de387ffc01456baaf9f05ba3500e15")
      .build()
    
    return networkService.requestData(Match.self, request: request)
      .observe(on: MainScheduler.instance)
      .catch { error in
        if let networkError = error as? NetworkError {
          switch networkError {
          case .unAuthorized:
            return Observable.error(NetworkError.unAuthorized)
          case .internetIssue:
            return Observable.error(NetworkError.internetIssue)
          case .timeOut:
            return Observable.error(NetworkError.timeOut)
          case .requestFailed(let error):
            return Observable.error(NetworkError.requestFailed(error))
          case .decodingFailed(let error):
            return Observable.error(NetworkError.decodingFailed(error))
          default:
            return Observable.error(NetworkError.invalidResponse)
          }
        }
        return Observable.error(error)
      }
  }
  
  func retrieveMatchDetailsFromCoreData(matchID: Int) -> [NSManagedObject] {
    return coreData.RetrieveMatchDetailsFromCoreData(matchID: matchID) ?? []
    }
  
}
