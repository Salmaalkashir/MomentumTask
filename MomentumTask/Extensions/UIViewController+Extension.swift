//
//  UIViewController+Extension.swift
//  MomentumTask
//
//  Created by admin on 2024-11-21.
//

import UIKit

extension UIViewController {
  func addBackButton() {
    navigationItem.hidesBackButton = true
    let back = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backTapped))
    back.tintColor = UIColor.black
    navigationItem.leftBarButtonItem = back
  }
  
  @objc func backTapped() {
    navigationController?.popViewController(animated: true)
    
  }
}
