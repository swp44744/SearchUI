//
//  SearchController.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/4/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import UIKit

public class SearchController: UISearchController, UISearchBarDelegate {
  // MARK: - Properties
  
  public lazy var _searchBar: NoCancelSearchBar = {
    let searchBar = NoCancelSearchBar()
    return searchBar
  }()
  
  public override var searchBar: UISearchBar {
    return _searchBar
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  public override init(searchResultsController: UIViewController?) {
    super.init(searchResultsController: searchResultsController)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
}


public class NoCancelSearchBar: UISearchBar {
  

  /// Oerride search bar to hide cancel button
  ///
  /// - Parameters:
  ///   - showsCancelButton: Bool value to show cancel button or not
  ///   - animated: Bool Value
  public override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
    
  }
}
