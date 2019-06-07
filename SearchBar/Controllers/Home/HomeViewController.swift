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
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  
  // MARK: - Constants
  let heightForCell: CGFloat = 90
  let searchService = SearchService()
  static let defaultSearchParam: String = "beach"
  let debouncer = Debouncer(timeInterval: 0.25)
  
  // MARK: - Properties
  var searchData: [SearchResultContainer]?
  var tempSearchData: [SearchResultContainer] = []
  var currentImageUrlString: String?
  var pagIndex: Int = 1
  var currentSearchText: String?
  let searchController = CustomSearchController(searchResultsController: nil)

  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureActivityIndicator()
    stopAnimating()
    loadSearchResults()
    registerNibs()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureSearchBar()
  }

  /// Load Search Data
  ///
  /// - Parameter searchTerm: User input
  private func loadSearchResults(searchTerm: String = defaultSearchParam, page: Int = 1) {
    debouncer.renewInterval()
    debouncer.handler = {
      self.startAnimating()
      self.searchService.getSearchResults(searchTerm: searchTerm, page: page) { data in
        switch data {
        case .success(let result):
          if let data = result.data {
            self.tempSearchData.append(contentsOf: data)
            self.searchData = self.tempSearchData
            self.reloadSearchData()
          }
          self.stopAnimating()
        case .failure(_):
          //TODO: Throw nice error on UI
          print("Unable to fetch search results, please try again..")
          self.stopAnimating()
        }
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
  
  private func configureActivityIndicator() {
    
  }
  
  private func startAnimating() {
    DispatchQueue.main.async {
      self.activityIndicator.isHidden = false
      self.activityIndicator.startAnimating()
    }
  }
  
  private func stopAnimating() {
    DispatchQueue.main.async {
      self.activityIndicator.isHidden = true
      self.activityIndicator.stopAnimating()
    }
  }
  
  
  /// Configure Search nav bar using UISearchController
  private func configureSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
    navigationItem.hidesSearchBarWhenScrolling = false
    self.navigationItem.titleView = searchController.searchBar
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
    
    let searchDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchDetailViewController") as? SearchDetailViewController
    
    if let viewController = searchDetailViewController {
      viewController.delegate = self
      searchController.isActive = false
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
    searchController.searchBar.endEditing(true)
  }
}


// MARK: - UISearchBarDelegate implementation
extension HomeViewController: UISearchBarDelegate {
  
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//    searchButtonTapped()
    print("in begin editing")
    return false
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchController.searchBar.endEditing(true)
  }
}


// MARK: - SetSearchDetailView title
extension HomeViewController: SetSearchDetailViewDelegate {
  func setImageView(imageView: UIImageView) {
    if let row = searchTableView.indexPathForSelectedRow?.row {
      
      /*
            Note: - Some of the items in search API are containing mp4 videos instead of images or empty Image object. if that happens setting imageview to placeholder image.
       */
      
      if let data = getData(at: row), let image = data.images?.first, let imageType = image.imageType, let imageUrl = image.imageLink {
        if imageType == "image/jpeg" || imageType == "image/png" {
          imageView.loadImage(from: imageUrl, placeHolder: UIImage(named: "no_image"))
        } else {
          imageView.image = UIImage(named: "no_image")
        }
      } else {
        imageView.image = UIImage(named: "no_image")
      }
    }
  }
  
  func setTitle(navItem: UINavigationItem) {
    if let row = searchTableView.indexPathForSelectedRow?.row, let data = getData(at: row) {
      navItem.title = data.title
    }
  }
}

// MARK: - UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating {
  // MARK: - UISearchResultsUpdating Delegate
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text {
      tempSearchData = []
      if searchText == "" {
        currentSearchText = HomeViewController.defaultSearchParam
        loadSearchResults(searchTerm: HomeViewController.defaultSearchParam)
      } else {
        currentSearchText = searchText
        loadSearchResults(searchTerm: searchText)
      }
    }
    
  }
}


