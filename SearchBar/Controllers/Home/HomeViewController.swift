//
//  HomeViewController.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/4/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  //   MARK : - Outlets
  @IBOutlet var searchTableView: UITableView!
  
  
  // MARK: - Constants
  let searchNavBar = UISearchBar()
  let heightForCell: CGFloat = 90
  let searchService = SearchService()
  static let defaultSearchParam: String = "beach"
  
  // MARK: - Properties
  var searchData: [SearchResultContainer]?
  var tempData: [SearchResultContainer] = []
  var currentTitle: String?
  var currentImageUrlString: String?
  var pagIndex: Int = 1
  var currentSearchText: String?
  

  override func viewDidLoad() {
    super.viewDidLoad()
    configureSearchBar()
    loadSearchResults()
    registerNibs()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  /// Load Search Data
  ///
  /// - Parameter searchTerm: User input
  private func loadSearchResults(searchTerm: String = defaultSearchParam, page: Int = 1) {
    searchService.getSearchResults(searchTerm: searchTerm, page: page) { data in
      switch data {
      case .success(let result):
        if let data = result.data {
          self.tempData.append(contentsOf: data)
          self.searchData = self.tempData
          self.reloadSearchData()
        }
      case .failure(_):
        //TODO: Throw nice error on UI
        print("Unable to fetch search results, please try again..")
      }
    }
  }
  

  /// Register nibs
  private func registerNibs() {
    searchTableView.register(UINib(nibName: SearchCell.searchCellId, bundle: nil), forCellReuseIdentifier: SearchCell.searchCellId)
  }
  
  private func reloadSearchData() {
    DispatchQueue.main.async {
      self.searchTableView.reloadData()
    }
  }
  
  
  /// Configure Search nav bar item
  private func configureSearchBar() {
    searchNavBar.showsCancelButton = false
    searchNavBar.placeholder = "Search here"
    searchNavBar.delegate = self
    self.navigationItem.titleView = searchNavBar
  }
  
  private func getData(at row: Int) -> SearchResultContainer? {
    if let data = searchData {
      if row < data.count {
        return data[row]
      }
    }
    return nil
  }
}



// MARK: - UITableViewDelegate implementation

extension HomeViewController: UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let data = searchData {
      return data.count
    }
    return 0
  }
  
  
  /// Open New view when cell is selected
  ///
  /// - Parameters:
  ///   - tableView: tableview from which cell is selected
  ///   - indexPath: Index at cell is selected
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let data = getData(at: indexPath.row) {
      currentTitle = data.title
      if let image = data.images?.first, let imageType = image.imageType, let imageUrl = image.imageLink {
        if imageType == "image/jpeg" {
          currentImageUrlString = imageUrl
        }
      }
    }
    
    let searchDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchDetailViewController") as? SearchDetailViewController
    
    if let viewController = searchDetailViewController {
      viewController.delegate = self
      self.navigationController?.pushViewController(viewController, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return heightForCell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let data = searchData {
      if indexPath.row == data.count - 1 {
        if let searchText = currentSearchText {
          loadSearchResults(searchTerm: searchText, page: pagIndex + 1)
        } else {
          loadSearchResults(page: pagIndex + 1)
        }
        
      }
    }
  }
}

// MARK: - UITableViewDataSource implementation

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.searchCellId, for: indexPath) as? SearchCell else { return UITableViewCell() }
    
    if let data = getData(at: indexPath.row) {
      cell.configure(searchData: data)
    }
    return cell
  }
}


// MARK: - UIScrollViewDelegate implementation

extension HomeViewController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    searchNavBar.endEditing(true)
  }
}


// MARK: - UISearchBarDelegate implementation
extension HomeViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchNavBar.endEditing(true)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    if searchText == "" {
      currentSearchText = HomeViewController.defaultSearchParam
      loadSearchResults(searchTerm: HomeViewController.defaultSearchParam)
    } else {
        currentSearchText = searchText
        loadSearchResults(searchTerm: searchText)
    }
   
  }
}


// MARK: - SetSearchDetailView title
extension HomeViewController: SetSearchDetailViewTitleDelegate {
  func setImageView(imageView: UIImageView) {
    if let imageUrlString = currentImageUrlString {
      imageView.loadImage(from: imageUrlString)
    }
  }
  
  func setTitle(navItem: UINavigationItem) {
    navItem.title = currentTitle
  }
}

