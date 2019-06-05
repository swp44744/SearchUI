//
//  SearchServiceTest.swift
//  SearchBar
//
//  Created by Swapnil Raut on 6/5/19.
//  Copyright © 2019 Swapnil Raut. All rights reserved.
//

import Foundation
import XCTest
@testable import SearchBar

class DebouncerTest: XCTestCase {
  // MARK: - Properties
  
  var searchService: SearchService!
  let urlString = "https://api.imgur.com/3/gallery/search/time/"
  let authHeaderKey = "Client-ID 126701cd8332f32"
  let contentHeaderKey = "Content-Type"
  let queryParam = "beach"
  
  // MARK: - Overrides
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    searchService = SearchService()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    searchService = .none
    super.tearDown()
  }
  
  
  func testGetSearchResults() {
    
    let testExpectation = expectation(description: "Test fetching search data requested search criteria")
    
    searchService.getSearchResults(searchTerm: queryParam, page: 1) { result in
      switch result {
      case .success(let data):
        XCTAssertNotNil(data)
      case .failure(_):
        XCTFail("Error occurred while fetching search data")
      }
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 5.0) { (error) in
      XCTAssertNil(error)
    }
  }
  
  func testPrepareRequestWithHeaders() {
    let request: NSMutableURLRequest?
    request = searchService.prepareRequestWithHeaders(with: urlString, param: queryParam)
    XCTAssertNotNil(request)
  }
  
}
