//
//  NavigationBarProtocol.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/4/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import Foundation
import UIKit

public protocol NavigationBarProtocol: class {
  var searchController: SearchController? {get set}
  func searchButtonTapped()
}

extension NavigationBarProtocol where Self: UIViewController {
  
  
  /// Helper method to configure Nav bar
  ///
  /// - Parameter searchBarDelegate: searchBarDelegate
  func configureNavigationBar(searchBarDelegate: UISearchBarDelegate? = .none) {
    if searchBarDelegate != nil {
      let searchController = SearchController(searchResultsController: .none)
      searchController.searchBar.placeholder = "Type here"
      searchController.searchBar.delegate = searchBarDelegate
      searchController.dimsBackgroundDuringPresentation = true
      searchController.searchBar.sizeToFit()
      self.searchController = searchController
      navigationItem.titleView = searchController.searchBar
      
    } else {
      self.searchController = nil
    }
  }
}
