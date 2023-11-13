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

    func testButtonClearToggle() {
        // Given - Arrange
        let model = StatusViewModel()
        
        // When - Act
        let initialState =  model.isClearButtonShowing
        model.toggleButton()
        let finalState = model.isClearButtonShowing
        
        // Then - Assert
        XCTAssertNotEqual(initialState, finalState, "Not equal")
    }
    
    func testModalShowingToggle() {
        // Given - Arrange
        let model = StatusViewModel()
        
        // When - Act
        let initialState =  model.showModal
        model.isModalShowing()
        let finalState = model.showModal
        
        // Then - Assert
        XCTAssertNotEqual(initialState, finalState, "Not equal")
    }
    
    func testSaveStatusButtonEmptyInput() {
        // Given - Arrange
        let model = StatusViewModel()
        model.statusInput = ""

        // When - Act
        model.saveStatusButton()
        
        // Then - Assert
        XCTAssertTrue(model.showModal, "is True")
    }
    
    func testSaveStatusButtonNotEmptyInput() {
        // Given - Arrange
        let model = StatusViewModel()
        model.statusInput = "False"
        
        // When - Act
        model.saveStatusButton()
        
        // Then - Assert
        XCTAssertFalse(model.showModal, "is False")
    }
    
    
    func testSuccessClearStatus() {
        // Given - Arrange
        let model = StatusViewModel()
        model.statusInput = "Not Empty"
        
        // When - Act
        model.clearStatus()
        
        // Then - Assert
        XCTAssertTrue(model.statusInput.isEmpty, "Is Empty")
    }
    
    func testAlertaIsShowing() {
        // Given - Arrange
        let model = StatusViewModel()
        
        // When - Act
        model.isAlertShowing()
        
        // Then - Assert
        let expectation = XCTestExpectation(description: "Wait for showAlert to be set to false")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(model.showAlert, "showAlert should be false after 1 second")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}

