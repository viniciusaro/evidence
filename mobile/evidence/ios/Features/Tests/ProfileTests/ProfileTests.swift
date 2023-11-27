//
//  ProfileTests.swift
//  
//
//  Created by Cris Messias on 12/11/23.
//

import XCTest
@testable import Profile
@testable import Models

final class ProfileTests: XCTestCase {
 
    func testStatusInputButtonTrue() {
        let model = StatusViewModel()
        model.statusInputButtonTapped()
        XCTAssertTrue(model.isModalShowing)
    }
    
    func testCloseModalButtonFalse() {
        let model = StatusViewModel()
        model.CloseModalButtonTapped()
        XCTAssertFalse(model.isModalShowing)
    }
    
    func testClearStatusInputButtonSuccess() {
        let model = StatusViewModel()
        model.statusInput = "Some input"
        model.clearStatusInputButtonTapped()
        XCTAssertTrue(model.statusInput.isEmpty)
        XCTAssertFalse(model.isClearButtonShowing)
    }
    
    func testClearStatusInputTextFieldSuccess() {
        let model = StatusViewModel()
        model.statusInput = "Some input"
        model.clearStatusInputTextFieldTapped()
        XCTAssertTrue(model.statusInput.isEmpty)
        XCTAssertFalse(model.isClearButtonShowing)
    }
    
    func testSaveButtonNotEmptyStatusInput() {
        let model = StatusViewModel()
        model.statusInput = "Some input"
        model.saveButtonTapped()
        XCTAssertTrue(model.isAlertShowing)
        XCTAssertTrue(model.isClearButtonShowing)
        XCTAssertFalse(model.isModalShowing)
    }
}
