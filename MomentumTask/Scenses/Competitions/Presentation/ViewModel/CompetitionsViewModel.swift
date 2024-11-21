//
//  CompetitionsViewModel.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import Foundation
import RxSwift
import CoreData

//MARK: - CompetitionsViewModelProtocol
protocol CompetitionsViewModelProtocol{
  func fetchCompetitions()
  var competitionData: Observable<[CompetitionInfo]>? {get}
  var errorMessage: Observable<String>? {get}
  var coreDataCompetitions: [NSManagedObject]? {get set}
  func retrieveCompetitionFromCoreData() -> [NSManagedObject]
  func getCellsCount() -> Int
  var isUsingCoreData: Bool {get}
}

//MARK: - CompetitionsViewModel
class CompetitionsViewModel: CompetitionsViewModelProtocol {

  private let repository: CompetitionsRepositoryProtocol
  private let disposeBag = DisposeBag()

  private let freeCompetitionsIds = [2000, 2001, 2002, 2003, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2021]
  
  var isUsingCoreData: Bool = false
  
  private let competitions = PublishSubject<[CompetitionInfo]>()
  var competitionData: Observable<[CompetitionInfo]>? {
      return competitions.asObservable()
  }
  
  private let errorSubject = PublishSubject<String>()
  var errorMessage: Observable<String>? {
      return errorSubject.asObservable()
  }

  init(repository: CompetitionsRepositoryProtocol = CompetitionsRepository()) {
      self.repository = repository
  }

  func fetchCompetitions() {
      print("Fetching news data...")
      repository.getCompetitionData()
          .observe(on: MainScheduler.instance)
          .subscribe(
              onNext: { [weak self] comp in
                let filteredCompetitions = comp.competitions?.filter { self?.freeCompetitionsIds.contains($0.id) == true }
                self?.competitions.onNext(filteredCompetitions ?? [])
                self?.isUsingCoreData = false
                for competition in filteredCompetitions ?? [] {
                  self?.repository.saveCompetitionsToCoreData(competition: competition)
                }
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
  
  var coreDataCompetitions: [NSManagedObject]?
  
  func retrieveCompetitionFromCoreData() -> [NSManagedObject] {
    return repository.retrieveCompetitionFromCoreData()
  }
  
  func getCellsCount() -> Int {
    if isUsingCoreData {
      return coreDataCompetitions?.count ?? 0
    }else {
      return freeCompetitionsIds.count
    }
  }
}
