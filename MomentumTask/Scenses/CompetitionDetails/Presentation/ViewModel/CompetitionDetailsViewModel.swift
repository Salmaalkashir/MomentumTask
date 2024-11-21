//
//  CompetitionDetailsViewModel.swift
//  MomentumTask
//
//  Created by Salma on 21/11/2024.
//

import Foundation
import RxSwift

//MARK: - CompetitionDetailsViewModelProtocol
protocol CompetitionDetailsViewModelProtocol {
  func fetchCompetitionDetails(competitionID: Int)
  var competitionDetailsData: Observable<[Match]>? {get}
  var errorMessage: Observable<String>? {get}
}

//MARK: - CompetitionDetailsViewModel
class CompetitionDetailsViewModel: CompetitionDetailsViewModelProtocol {
  private let repository: CompetitionDetailsRepositoryProtocol
  private let disposeBag = DisposeBag()

  var isUsingCoreData: Bool = false
  
  private let matches = PublishSubject<[Match]>()
  var competitionDetailsData: Observable<[Match]>? {
      return matches.asObservable()
  }
  
  private let errorSubject = PublishSubject<String>()
  var errorMessage: Observable<String>? {
      return errorSubject.asObservable()
  }

  init(repository: CompetitionDetailsRepositoryProtocol = CompetitionDetailsRepository()) {
      self.repository = repository
  }

  func fetchCompetitionDetails(competitionID: Int) {
      print("Fetching news data...")
    repository.getCompetitionDetailsData(competitionID: competitionID)
          .observe(on: MainScheduler.instance)
          .subscribe(
              onNext: { [weak self] details in
                self?.matches.onNext(details.matches ?? [])
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
  
//  var coreDataCompetitions: [NSManagedObject]?
//
//  func retrieveCompetitionFromCoreData() -> [NSManagedObject] {
//    return repository.retrieveCompetitionFromCoreData()
//  }
  
//  func getCellsCount() -> Int {
//    if isUsingCoreData {
//      return coreDataCompetitions?.count ?? 0
//    }else {
//      return freeCompetitionsIds.count
//    }
//  }
}

