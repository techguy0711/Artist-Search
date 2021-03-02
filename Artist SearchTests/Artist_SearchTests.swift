//
//  Artist_SearchTests.swift
//  Artist SearchTests
//
//  Created by Kristhian De Oliveira on 3/2/21.
//

import XCTest
@testable import Artist_Search

class Artist_SearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    //Tests to see if we can fetch albums from specified artists, and returnss ammount of albums other than 0
    func testAbleToFetchiTunesAlbums() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(searchItunesController().FetchAlbums(forArtistName: "Kanye West").count != 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            
        }
    }

}
