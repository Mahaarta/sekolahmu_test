//
//  sekolahmu_testTests.swift
//  sekolahmu_testTests
//
//  Created by macbook on 18/03/22.
//

import XCTest
@testable import sekolahmu_test

class sekolahmu_testTests: XCTestCase {
    var newsDetailVC: NewsDetailViewController?
        
    override func setUpWithError() throws {
        newsDetailVC = NewsDetailViewController()
    }

    // Test bookmark system image
    func testBookmarkFillSystemImage() {
        let bookmarkSystemImage = newsDetailVC?.bookmarkCondition(articleID: "nyt://123", localID: "nyt://123")
        XCTAssertEqual(bookmarkSystemImage, "bookmark.fill", "if meet the condition systemImage should be 'bookmark'")
    }
    
    func testBookmarkSystemImage() {
        let bookmarkSystemImage = newsDetailVC?.bookmarkCondition(articleID: "nyt://1234", localID: "nyt://123")
        XCTAssertEqual(bookmarkSystemImage, "bookmark", "if meet the condition systemImage should be 'bookmark'")
    }
    
    func testSwipedLeft() {
        // news index is the active news that user selected
        var newsIndex = 5
        
        for _ in 0...4 {
            if (newsIndex - 1) >= 0 {
                newsIndex -= 1
            } else {
                return XCTAssertFalse(false, "user can't swipe to left anymore, because data has reach minimum")
            }
        }
    }
    
    func testSwipedRight() {
        // news index is the active news that user selected
        var newsIndex = 2
        let newsCount = 4
        
        
        for _ in 0...newsCount {
            if (newsIndex + 1) < newsCount {
                newsIndex += 1
            } else {
                return XCTAssertFalse(false, "user can't swipe to right anymore, because data has reach maximum")
            }
        }
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        newsDetailVC = nil
    }
}
