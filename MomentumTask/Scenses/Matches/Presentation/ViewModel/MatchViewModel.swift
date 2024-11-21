//
//  MatchViewModel.swift
//  MomentumTask
//
//  Created by Salma on 2024-11-21.
//

import Foundation
import RxSwift
import CoreData
//MARK: - MatchViewModelProtocol
protocol MatchViewModelProtocol {
  var matchDetailsData: Observable<Match>? {get}
  var errorMessage: Observable<String>? {get}
  var isUsingCoreData: Bool {get}
  func fetchMatchDetails()
  var coreDataMatchDetails: [NSManagedObject]? {get set}
  func retrieveMatchFromCoreData() -> [NSManagedObject]
  var matchID: Int? {get set}
}

//MARK: - MatchViewModel
class MatchViewModel: MatchViewModelProtocol {
  private let repository: MatchRepositoryProtocol
  private let disposeBag = DisposeBag()
  
  var isUsingCoreData: Bool = false
  
  private let matches = PublishSubject<Match>()
  var matchDetailsData: Observable<Match>? {
    return matches.asObservable()
  }
  
  private let errorSubject = PublishSubject<String>()
  var errorMessage: Observable<String>? {
    return errorSubject.asObservable()
  }
  
  init(repository: MatchRepositoryProtocol = MatchRepository()) {
    self.repository = repository
  }
  
  func fetchMatchDetails() {
    print("Fetching data...")
    repository.getMatchDetails(matchID: matchID ?? 0)
      .observe(on: MainScheduler.instance)
      .subscribe(
        onNext: { [weak self] details in
          self?.matches.onNext(details)
          self?.isUsingCoreData = false
        },
        onError: { [weak self] error in
          print("Error occurred: \(error)")
          self?.isUsingCoreData = true
          if let networkError = error as? NetworkError {
            switch networkError {
            case .internetIssue:
              self?.errorSubject.onNext("No Internet Connection")
            case .unAuthorized:
              self?.errorSubject.onNext("Unauthorized access")
            default:
              self?.errorSubject.onNext("An unknown error occurred.")
            }
          } else {
            self?.errorSubject.onNext("An unknown error occurred.")
          }
        }
      )
      .disposed(by: disposeBag)
  }
  
  var coreDataMatchDetails: [NSManagedObject]?
  var matchID: Int?
  
  func retrieveMatchFromCoreData() -> [NSManagedObject] {
    return repository.retrieveMatchDetailsFromCoreData(matchID: matchID ?? 0)
  }
}
