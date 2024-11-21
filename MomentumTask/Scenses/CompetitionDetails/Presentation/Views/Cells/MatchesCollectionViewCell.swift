//
//  MatchesCollectionViewCell.swift
//  MomentumTask
//
//  Created by Salma on 2024-11-21.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class MatchesCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet weak var homeTeamImage: UIImageView!
    @IBOutlet weak var awayTeamImage: UIImageView!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var homeShortName: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var awayShortName: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var matchStatus: UIView!
    @IBOutlet weak var status: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellView()
    }
    
    func configureCell(homeTeamImage: Any, homeTeamName: String,  homeShortName: String, awayTeamImage: Any, awayTeamName: String, awayShortName: String, score: String, status: String) {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        if let imageString = homeTeamImage as? String {
            self.homeTeamImage.sd_setImage(with: URL(string: imageString),placeholderImage: UIImage(named: "placeholderImage"))
        } else if let imageData = homeTeamImage as? Data {
            if let image = UIImage(data: imageData) {
                self.homeTeamImage.image = image
            }
        }
        
        if let imageString = awayTeamImage as? String {
            self.awayTeamImage.sd_setImage(with: URL(string: imageString),placeholderImage: UIImage(named: "placeholderImage"))
        } else if let imageData = awayTeamImage as? Data {
            if let image = UIImage(data: imageData) {
                self.awayTeamImage.image = image
            }
        }
        
        self.homeTeamName.text = homeTeamName
        self.homeShortName.text = homeShortName
        self.awayTeamName.text = awayTeamName
        self.awayShortName.text = awayShortName
        self.score.text = score
        self.status.text = status
    }

 private func configureCellView() {
        cellView.layer.shadowColor = UIColor.gray.cgColor
        cellView.layer.shadowOpacity = 0.4
        cellView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cellView.layer.shadowRadius = 3
        cellView.layer.cornerRadius = 24
        layer.cornerRadius = 24
     
     matchStatus.layer.cornerRadius = 15
    }
}
