//
//  SearchDetailViewController.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/5/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import UIKit

public protocol SetSearchDetailViewDelegate {
  func setTitle(navItem: UINavigationItem)
  func setImageView(imageView: UIImageView)
}

class SearchDetailViewController: UIViewController {

  //  MARK :- Outlets
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var detailImageView: UIImageView!
  
  @IBOutlet weak var detailImageHeight: NSLayoutConstraint!
  @IBOutlet weak var detailImageWidth: NSLayoutConstraint!
  
  
  //   MARK :- Properties
  var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
  }
  
  var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
  }
  var delegate: SetSearchDetailViewDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate?.setTitle(navItem: self.navigationItem)
    delegate?.setImageView(imageView: detailImageView)
    configureImageView()
    }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    configureImageView()
  }
  
  private func configureImageView() {
    if screenWidth < screenHeight {
      detailImageWidth.constant = screenWidth * 0.7
      detailImageHeight.constant = screenWidth * 0.7
    } else {
      detailImageWidth.constant = screenHeight * 0.7
      detailImageHeight.constant = screenHeight * 0.7
    }
    detailImageView.layer.cornerRadius = detailImageWidth.constant / 2
    detailImageView.clipsToBounds = true
    detailImageView.layer.borderWidth = 0.5
    detailImageView.layer.masksToBounds = true
  }

}
