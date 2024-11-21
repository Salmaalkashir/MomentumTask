//
//  CompetitionsViewController.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import UIKit
import RxSwift

class CompetitionsViewController: UIViewController {
  @IBOutlet private weak var collectionView: UICollectionView!
  private let disposeBag = DisposeBag()
  private var viewModel: CompetitionsViewModelProtocol
  private var competitions: [CompetitionInfo] = []
  
  
  init(viewModel: CompetitionsViewModelProtocol = CompetitionsViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel()
    viewModel.fetchNewsData()
    configureView()
  }
  
  private func configureView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    let nib = UINib(nibName: "CompetitionCollectionViewCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: "competition")
  }
  
  //MARK: - Binding
  private func bindViewModel() {
    viewModel.competitionData?
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] competitions in
        self?.competitions = competitions
        self?.collectionView.reloadData()
      }, onError: { [weak self] error in
        print("Error: \(error)")
      })
      .disposed(by: disposeBag)
    
    viewModel.errorMessage?
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] errorMessage in
        if errorMessage == "No Internet Connection" {
          self?.viewModel.coreDataCompetitions = self?.viewModel.retrieveCompetitionFromCoreData()
          self?.collectionView.reloadData()
        } else {
          print("Received Error:\(errorMessage)")
        }
      })
      .disposed(by: disposeBag)
  }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CompetitionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.getCellsCount()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "competition", for: indexPath) as! CompetitionCollectionViewCell
    if viewModel.isUsingCoreData {
      cell.ConfigureCell(image: viewModel.coreDataCompetitions?[indexPath.row].value(forKey: "image") ?? Data(), competitionName: viewModel.coreDataCompetitions?[indexPath.row].value(forKey: "name") as! String , competitionCode: viewModel.coreDataCompetitions?[indexPath.row].value(forKey: "code") as! String , matchDay: viewModel.coreDataCompetitions?[indexPath.row].value(forKey: "currentMatchDay") as! Int, numberOfSeasons: viewModel.coreDataCompetitions?[indexPath.row].value(forKey: "availableSeasons") as! Int)
    }else{
      if indexPath.row < competitions.count {
        cell.ConfigureCell(image: competitions[indexPath.row].emblemUrl ?? "" ,
                             competitionName: competitions[indexPath.row].name,
                             competitionCode: competitions[indexPath.row].code ?? "",
                             matchDay: competitions[indexPath.row].currentSeason?.currentMatchday ?? 0,
                             numberOfSeasons: competitions[indexPath.row].numberOfAvailableSeasons ?? 0)
      } else {
          print("Index out of range!")
      }
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let competitionDetails = CompetitionDetailsViewController()
    self.navigationController?.pushViewController(competitionDetails, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 342, height: 156)
  }
  
}

