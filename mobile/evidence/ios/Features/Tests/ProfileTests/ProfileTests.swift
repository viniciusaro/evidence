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

    /// Set Status View Model
    func testClearStatusInputTextFieldTapped() {
        let model = SetStatusViewModel(statusInput: "Some Text")
        model.clearStatusInputTextFieldTapped()
        XCTAssertTrue(model.statusInput.isEmpty)
    }

    func testClearAndSaveButtonTapped() {
        let model = SetStatusViewModel(statusInput: "Some Text")
        var status: String?
        model.delegateSaveButtonTapped = { newStatus in
            status = newStatus
        }
        model.clearAndSaveButtonTapped()
        XCTAssertTrue(model.statusInput.isEmpty)
        XCTAssertEqual(status, "")
    }

    func testSaveButtonTapped() {
        let model = SetStatusViewModel(statusInput: "Some Text")
        var status: String?
        model.delegateSaveButtonTapped = { newStatus in
            status = newStatus
        }
        model.saveButtonTapped()
        XCTAssertEqual(status, model.statusInput)
    }

    func testCloseButtonTapped() {
        let model = SetStatusViewModel()
        var closeButtonTappedCalled = false
        model.delegateCloseButtonTapped = {
            closeButtonTappedCalled = true
        }
        model.closeButtonTapped()
        XCTAssertTrue(closeButtonTappedCalled)
    }
    
    /// Status View Model
    func testOpenModalButtonTapped() {
        let model = StatusViewModel()
        model.openModalButtonTapped()
        XCTAssertNotNil(model.setStatusViewModel)
    }

    func testCloseModalButtonTapped() {
        let model = StatusViewModel()
        model.closeModalButtonTapped()
        XCTAssertNil(model.setStatusViewModel)
    }

    func testClearStatusInputButtonTapped() {
        let model = StatusViewModel()
        model.clearStatusInputButtonTapped()
        XCTAssertTrue(model.statusInput.isEmpty)
    }

    func testSaveOrClearPopupAppearsAndDisappears() {
        let model = StatusViewModel()
        model.saveOrClearPopupAppears()
        XCTAssertTrue(model.offSetY == 0)
        let expectation = XCTestExpectation(description: "Wait for offSety to be set to equal to 1000")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(model.offSetY == 1000)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
}
