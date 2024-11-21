//
//  CompetitionDetailsViewController.swift
//  MomentumTask
//
//  Created by Salma on 21/11/2024.
//

import UIKit
import RxSwift

class CompetitionDetailsViewController: UIViewController {
  @IBOutlet private weak var matchesCollectionView: UICollectionView!
  @IBOutlet private weak var emptyLabel: UILabel!
  private let disposeBag = DisposeBag()
  private var viewModel: CompetitionDetailsViewModelProtocol
  private var matches: [Match] = []
  var competitionID: Int?
  var competitionName: String?
  
  
  init(viewModel: CompetitionDetailsViewModelProtocol = CompetitionDetailsViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = competitionName ?? ""
    addBackButton()
    configureViews()
    viewModel.competitionID = competitionID
    viewModel.fetchCompetitionDetails()
    bindViewModel()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    self.navigationItem.hidesBackButton = true
  }
  
  private func configureViews() {
    matchesCollectionView.dataSource = self
    matchesCollectionView.delegate = self
    let nib = UINib(nibName: "MatchesCollectionViewCell", bundle: nil)
    matchesCollectionView.register(nib, forCellWithReuseIdentifier: "matches")
    emptyLabel.isHidden = true
  }
  private func bindViewModel() {
    viewModel.competitionDetailsData?
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] competitions in
        print("DETAILS:\(competitions)")
        self?.matches = competitions
        self?.matchesCollectionView.reloadData()
      }, onError: { [weak self] error in
        print("Error: \(error)")
      })
      .disposed(by: disposeBag)
    
    viewModel.errorMessage?
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] errorMessage in
        if errorMessage == "An unknown error occurred."  || errorMessage == "No Internet Connection" {
          self?.viewModel.coreDataCompetitionDetails = self?.viewModel.retrieveCompetitionFromCoreData()
          self?.emptyLabel.isHidden = false
          self?.matchesCollectionView.reloadData()
          print("CORE DATA")
        } else {
          print("Received Error:\(errorMessage)")
        }
      })
      .disposed(by: disposeBag)
  }
}

//MARK: -UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension CompetitionDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if viewModel.isUsingCoreData{
      if viewModel.coreDataCompetitionDetails?.count == 0 {
        emptyLabel.isHidden = false
        return 0
      }else{
        emptyLabel.isHidden = true
        return viewModel.coreDataCompetitionDetails?.count ?? 0
      }
    }else{
      return matches.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matches", for: indexPath) as! MatchesCollectionViewCell
    if viewModel.isUsingCoreData{
      cell.configureCell(homeTeamImage: viewModel.coreDataCompetitionDetails?[indexPath.row].value(forKey: "homeTeamImage") as? Data ?? Data(), homeTeamName: viewModel.coreDataCompetitionDetails?[indexPath.row].value(forKey: "homeTeamName")  as! String, homeShortName: viewModel.coreDataCompetitionDetails?[indexPath.row].value(forKey: "homeShortName")  as! String, awayTeamImage:  viewModel.coreDataCompetitionDetails?[indexPath.row].value(forKey: "awayTeamImage") as? Data ?? Data(), awayTeamName: viewModel.coreDataCompetitionDetails?[indexPath.row].value(forKey: "awayTeamName")  as! String, awayShortName: viewModel.coreDataCompetitionDetails?[indexPath.row].value(forKey: "awayShortName")  as! String, score: viewModel.coreDataCompetitionDetails?[indexPath.row].value(forKey: "score")  as! String, status: viewModel.coreDataCompetitionDetails?[indexPath.row].value(forKey: "status")  as! String)
    }else {
      let score = "\(matches[indexPath.row].score?.fullTime?.away ?? 0) - \(matches[indexPath.row].score?.fullTime?.home ?? 0)"
      
      cell.configureCell(homeTeamImage: matches[indexPath.row].homeTeam?.crest ?? "", homeTeamName: matches[indexPath.row].homeTeam?.name ?? "", homeShortName: matches[indexPath.row].homeTeam?.shortName ?? "", awayTeamImage: matches[indexPath.row].awayTeam?.crest ?? "", awayTeamName: matches[indexPath.row].awayTeam?.name ?? "", awayShortName: matches[indexPath.row].awayTeam?.shortName ?? "", score: score, status: matches[indexPath.row].status ?? "")
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let match = MatchDetailsViewController()
    if viewModel.isUsingCoreData {
      match.indexPath = indexPath.row
      match.matchID = viewModel.coreDataCompetitionDetails?[indexPath.row].value(forKey: "matchID") as? Int
    }else{
      match.indexPath = indexPath.row
      match.matchID = matches[indexPath.row].id
    }
    self.navigationController?.pushViewController(match, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 348, height: 155)
  }
}
