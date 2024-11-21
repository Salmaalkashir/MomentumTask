//
//  CompetitionDetailsRepository.swift
//  MomentumTask
//
//  Created by Salma on 21/11/2024.
//

import Foundation
import RxSwift
import CoreData

//MARK: - CompetitionDetailsRepositoryProtocol
protocol CompetitionDetailsRepositoryProtocol {
  func getCompetitionDetailsData(competitionID: Int) -> Observable<Details>
  func saveCompetitionsDetailsToCoreData(match: Match)
  func retrieveCompetitionDetailsFromCoreData(competitionID: Int) -> [NSManagedObject]
}

//MARK: - CompetitionDetailsRepository
class CompetitionDetailsRepository: CompetitionDetailsRepositoryProtocol {
  private let networkService: NetworkServiceProtocol
  private let coreData: CoreDataManagerProtocol
  private let disposeBag = DisposeBag()
  
  init(networkService: NetworkServiceProtocol = NetworkService(), coreData: CoreDataManagerProtocol = CoreDataManager.getObj()) {
    self.networkService = networkService
    self.coreData = coreData
  }
  
  func getCompetitionDetailsData(competitionID: Int) -> Observable<Details> {
    let request = APIBuilder()
      .setUrl(hostUrl: "https://api.football-data.org/v4/competitions/\(competitionID)/matches")
      .setHeaders(key: "X-Auth-Token", value: "43de387ffc01456baaf9f05ba3500e15")
      .build()
    
    return networkService.requestData(Details.self, request: request)
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
  
  func saveCompetitionsDetailsToCoreData(match: Match) {
    coreData.SaveCompetitionDetailsCoreData(matches: match)
  }
  
  func retrieveCompetitionDetailsFromCoreData(competitionID: Int) -> [NSManagedObject] {
    return coreData.RetrieveCompetitionDetailsFromCoreData(competitionID: competitionID) ?? []
  }
}
