//
//  MatchViewController.swift
//  MomentumTask
//
//  Created by Salma on 2024-11-21.
//

import UIKit
import RxSwift
import SDWebImage

class MatchDetailsViewController: UIViewController {
  @IBOutlet private weak var teamOneImage: UIImageView!
  @IBOutlet private weak var teamTwoImage: UIImageView!
  @IBOutlet private weak var matchInfoView: UIView!
  @IBOutlet private weak var teamNames: UILabel!
  @IBOutlet private weak var date: UILabel!
  @IBOutlet private weak var time: UILabel!
  @IBOutlet private weak var halfTime: UILabel!
  @IBOutlet private weak var fullTime: UILabel!
  @IBOutlet private weak var duration: UILabel!
  
  var matchID: Int?
  var indexPath: Int?
  private let disposeBag = DisposeBag()
  private var viewModel: MatchViewModelProtocol
  private var match: Match?
  
  init(viewModel: MatchViewModelProtocol = MatchViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.matchID = matchID ?? 0
    viewModel.fetchMatchDetails()
    bindViewModel()
    addBackButton()
    matchInfoView.layer.cornerRadius = 20
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationItem.hidesBackButton = true
  }
  
  
  private func bindViewModel() {
    viewModel.matchDetailsData?
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] competitions in
        self?.match = competitions
        let date = Helpers.convertUTCDateAndTime(self?.match?.utcDate ?? "")
        self?.teamOneImage.sd_setImage(with: URL(string: self?.match?.homeTeam?.crest ?? ""),placeholderImage: UIImage(named: "placeholderImage"))
        self?.teamTwoImage.sd_setImage(with: URL(string: self?.match?.awayTeam?.crest ?? ""),placeholderImage: UIImage(named: "placeholderImage"))
        self?.teamNames.text = ("\(self?.match?.awayTeam?.name ?? "")" + " " + "&" + " " + "\(self?.match?.homeTeam?.name ?? "")")
        self?.date.text = date?.date
        self?.time.text = date?.time
        self?.fullTime.text = ("\(self?.match?.score?.fullTime?.away ?? 0) - \(self?.match?.score?.fullTime?.home ?? 0)")
        self?.halfTime.text = ("\(self?.match?.score?.halfTime?.away ?? 0) - \(self?.match?.score?.halfTime?.home ?? 0)")
        self?.duration.text = self?.match?.score?.duration
      }, onError: { [weak self] error in
        print("Error: \(error)")
      })
      .disposed(by: disposeBag)
    
    viewModel.errorMessage?
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] errorMessage in
        if errorMessage == "No Internet Connection" ||  errorMessage == "An unknown error occurred." {
          self?.viewModel.coreDataMatchDetails = self?.viewModel.retrieveMatchFromCoreData()
          self?.teamOneImage.image = UIImage(data: self?.viewModel.coreDataMatchDetails?[0].value(forKey: "homeTeamImage") as? Data ?? Data())
          self?.teamTwoImage.image = UIImage(data: self?.viewModel.coreDataMatchDetails?[0].value(forKey: "awayTeamImage") as? Data ?? Data())
          self?.teamNames.text = ("\(self?.viewModel.coreDataMatchDetails?[0].value(forKey: "awayTeamName") as? String ?? "")" + " " + "&" + " " + "\(self?.viewModel.coreDataMatchDetails?[0].value(forKey: "homeTeamName") as? String ?? "")")
          self?.date.text = self?.viewModel.coreDataMatchDetails?[0].value(forKey: "matchDate") as? String
          self?.time.text = self?.viewModel.coreDataMatchDetails?[0].value(forKey: "matchTime") as? String
          self?.fullTime.text = self?.viewModel.coreDataMatchDetails?[0].value(forKey: "score") as? String
          self?.halfTime.text = self?.viewModel.coreDataMatchDetails?[0].value(forKey: "halfScore") as? String
          self?.duration.text = self?.viewModel.coreDataMatchDetails?[0].value(forKey: "matchDuration") as? String
        }else {
          print("Received Error:\(errorMessage)")
        }
      })
      .disposed(by: disposeBag)
  }
}
