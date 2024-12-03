//
//  CVSAssessmentUITests.swift
//  CVSAssessmentUITests
//
//  Created by jiaxing liu on 12/2/24.
//

import XCTest

final class CVSAssessmentUITests: XCTestCase {
    
    var app: XCUIApplication!
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testSearchBarStaysAtTopDuringLoading() throws {
        
        let searchBar = app.textFields["Search..."]
        XCTAssertTrue(searchBar.exists, "Search bar should exist")
    
        let searchBarFrameBeforeLoading = searchBar.frame
        
        searchBar.tap()
        searchBar.typeText("kittens")

        let searchBarFrameDuringLoading = searchBar.frame
        XCTAssertEqual(
            searchBarFrameBeforeLoading.origin.y,
            searchBarFrameDuringLoading.origin.y,
            "Search bar should stay at the top during loading"
        )
    }
    
    func testImageGridAppearsAfterLoading() throws {
        let searchBar = app.textFields["Search..."]
        XCTAssertTrue(searchBar.exists, "Search bar should exist")
        searchBar.tap()
        searchBar.typeText("kittens")
        let gridCell = app.images.element(boundBy: 0)
        let exists = gridCell.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Grid should show images after loading")
    }
}
