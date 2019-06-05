//
//  SearchService.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/4/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import Foundation

 enum httpMethodType: String {
  case GET = "GET"
  case POST = "POST"
}

 enum SearchResponseError {
  case failedToFetchSearchData
  case badRequest
}


class SearchService {
  
  //   MARK :- properties
  
  let urlString = "https://api.imgur.com/3/gallery/search/time/"
  let authHeaderKey = "Client-ID 126701cd8332f32"
  let contentHeaderKey = "Content-Type"
  
  
  // MARK :- Methods
  
  /// Get Search data from server
  ///
  /// - Parameters:
  ///   - term: User entered search criteria
  ///   - completion: completion block to send data back to controller
  func getSearchResults(searchTerm term: String = "dog", page: Int, _ completion: @escaping (_ result: SessionResult<SearchResult, SearchResponseError>) -> Void) {
    
    let session = URLSession.shared
    
    if let request = prepareRequestWithHeaders(with: urlString + "\(page)", param: term) {
      session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
        
        if let data = data {
          let searchData = try! JSONDecoder().decode(SearchResult.self, from: data)
          completion(SessionResult.success(searchData))
        } else {
          completion(SessionResult.failure(.failedToFetchSearchData))
        }
        
      }.resume()
    }
  }
  
  
  
  /// Helper method to set headers, http method, query param etc..
  ///
  /// - Parameters:
  ///   - urlString: API string url
  ///   - param: search criteria to send as a query parameter
  /// - Returns: returns mutable session request
  private func prepareRequestWithHeaders(with urlString: String, param: String) -> NSMutableURLRequest? {
    var urlComponent = URLComponents(string: urlString)
    urlComponent?.queryItems = [URLQueryItem(name: "q", value: param)]
    
    if let component = urlComponent, let url = component.url {
      let request = NSMutableURLRequest(url: url)
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("Client-ID 126701cd8332f32", forHTTPHeaderField: "Authorization")
      
    
      request.httpMethod = httpMethodType.GET.rawValue
      
      return request
    }
    return .none
  }
}
