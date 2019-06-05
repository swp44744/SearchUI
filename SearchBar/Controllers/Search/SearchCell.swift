//
//  SearchCell.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/4/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

  //  MARK : - Outlets
  @IBOutlet weak var searchImage: UIImageView!
  @IBOutlet weak var title: UILabel!
  
  // MARK :- Constants
  static let searchCellId = "SearchCell"
  
  //  MARK : - Properties
  var searchData: SearchResultContainer? {
    didSet {
      if let data = searchData {
        DispatchQueue.main.async {
          self.updateSearchCellView(searchData: data)
        }
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureImageView()

  }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configure(searchData: SearchResultContainer) {
    self.searchData = searchData
  }
  
  private func configureImageView() {
    searchImage.layer.cornerRadius = searchImage.frame.size.width / 2
    searchImage.clipsToBounds = true
    searchImage.layer.borderWidth = 0.5
    searchImage.layer.masksToBounds = true

  }
  
  private func updateSearchCellView(searchData: SearchResultContainer) {
    // Update Image view
    if let image = searchData.images?.first, let imageType = image.imageType, let imageUrl = image.imageLink {
      if imageType == "image/jpeg" {
        searchImage.loadImage(from: imageUrl)
      }
    }
    
    if let searchItemTitle = searchData.title {
      title.text = searchItemTitle
    }
  }
 
}
