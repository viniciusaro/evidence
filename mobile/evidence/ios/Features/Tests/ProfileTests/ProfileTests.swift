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
        XCTAssertTrue(model.showModal)
    }
    
    func testModalCloseButtonFalse() {
        let model = StatusViewModel()
        model.modalCloseButtonTapped()
        XCTAssertFalse(model.showModal)
    }
    
    func testClearStatusInputButtonSuccess() {
        let model = StatusViewModel()
        model.statusInput = "Some input"
        model.clearStatusInputButtonTapped()
        XCTAssertTrue(model.statusInput.isEmpty)
        XCTAssertFalse(model.showClearButton)
    }
    
    func testClearStatusInputTextFieldSuccess() {
        let model = StatusViewModel()
        model.statusInput = "Some input"
        model.clearStatusInputTextFieldTapped()
        XCTAssertTrue(model.statusInput.isEmpty)
        XCTAssertFalse(model.showClearButton)
    }
    
    func testShowClearButtonAndCloseModalSuccess() {
        let model = StatusViewModel()
        model.showClearButtonAndCloseModal()
        XCTAssertTrue(model.showClearButton)
        XCTAssertFalse(model.showModal)
    }
    
    func testSaveButtonNotEmptyStatusInput() {
        let model = StatusViewModel()
        model.statusInput = "Some input"
        model.saveButtonTapped()
        XCTAssertTrue(model.showAlert)
    }

    func testAlertIsShowingSuccess() {
        let model = StatusViewModel()
        model.publicFuncIsAlertShowing()
        XCTAssertTrue(model.showAlert)
        let expectation = XCTestExpectation(description: "Wait for showAlert to be set to true")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(model.showAlert)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
}
