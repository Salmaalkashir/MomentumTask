//
//  CompetitionsRepository.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import Foundation
import RxSwift
import CoreData

//MARK: - CompetitionsRepositoryProtocol
protocol CompetitionsRepositoryProtocol {
  func getNewsData() -> Observable<Competition>
  func saveCompetitionsToCoreData(competition: CompetitionInfo)
  func retrieveCompetitionFromCoreData() -> [NSManagedObject]
}

//MARK: - CompetitionsRepository
class CompetitionsRepository: CompetitionsRepositoryProtocol {
  private let networkService: NetworkServiceProtocol
  private let coreData: CoreDataManagerProtocol
  private let disposeBag = DisposeBag()
  
  init(networkService: NetworkServiceProtocol = NetworkService(), coreData: CoreDataManagerProtocol = CoreDataManager.getObj()) {
    self.networkService = networkService
    self.coreData = coreData
  }
  
  func getNewsData() -> Observable<Competition> {
    let request = APIBuilder()
      .setUrl(hostUrl: "https://api.football-data.org/v2/competitions")
      .build()
    
    return networkService.requestData(Competition.self, request: request)
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
  
  func saveCompetitionsToCoreData(competition: CompetitionInfo) {
    coreData.SaveCompetitionCoreData(competition: competition)
  }
  
  func retrieveCompetitionFromCoreData() -> [NSManagedObject] {
   return coreData.RetrieveCompetitionsFromCoreData() ?? []
  }
}
