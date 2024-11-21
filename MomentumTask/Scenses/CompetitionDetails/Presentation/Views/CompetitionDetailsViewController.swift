//
//  CompetitionDetailsViewController.swift
//  MomentumTask
//
//  Created by Salma on 21/11/2024.
//

import UIKit
import RxSwift

class CompetitionDetailsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var viewModel: CompetitionDetailsViewModelProtocol
    private var competitions: [Match] = []
    var competitionID: Int?
    
    
    init(viewModel: CompetitionDetailsViewModelProtocol = CompetitionDetailsViewModel()) {
      self.viewModel = viewModel
      super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ID:\(competitionID ?? 0)")
        viewModel.fetchCompetitionDetails(competitionID: competitionID ?? 0)
        bindViewModel()
    }
    
    private func bindViewModel() {
      viewModel.competitionDetailsData?
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] competitions in
            print("DETAILS:\(competitions)")
          self?.competitions = competitions
         // self?.collectionView.reloadData()
        }, onError: { [weak self] error in
          print("Error: \(error)")
        })
        .disposed(by: disposeBag)
      
      viewModel.errorMessage?
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] errorMessage in
          if errorMessage == "No Internet Connection" {
print("CORE DATA")
          } else {
            print("Received Error:\(errorMessage)")
          }
        })
        .disposed(by: disposeBag)
    }
}
