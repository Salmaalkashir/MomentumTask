//
//  CompetitionCollectionViewCell.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class CompetitionCollectionViewCell: UICollectionViewCell {
  @IBOutlet private weak var cellView: UIView!
  @IBOutlet weak var competitionName: UILabel!
  @IBOutlet weak var competitionImage: UIImageView!
  @IBOutlet weak var competitionCode: UILabel!
  @IBOutlet weak var numberOfSeasons: UILabel!
  @IBOutlet weak var matchDay: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    ConfigureCellView()
  }
  
  func ConfigureCell(image: Any, competitionName: String, competitionCode: String, matchDay: Int, numberOfSeasons: Int) {
    SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    if let imageString = image as? String {
        self.competitionImage.sd_setImage(with: URL(string: imageString),placeholderImage: UIImage(named: "placeholderImage"))
    } else if let imageData = image as? Data {
        if let image = UIImage(data: imageData) {
            self.competitionImage.image = image
        }
    }
     self.competitionName.text = competitionName
     self.competitionCode.text = "Code: \(competitionCode)"
     self.matchDay.text = "Current match day: \(String(matchDay))"
     self.numberOfSeasons.text = "Number of seasons: \(String(numberOfSeasons))"
   }
  
private func ConfigureCellView() {
    cellView.layer.shadowColor = UIColor.gray.cgColor
    cellView.layer.shadowOpacity = 0.4
    cellView.layer.shadowOffset = CGSize(width: 0, height: 2)
    cellView.layer.shadowRadius = 3
    cellView.layer.cornerRadius = 24
    layer.cornerRadius = 24
    competitionImage.layer.cornerRadius = 16
  }
}
