//
//  LoginTestsViewModel.swift
//  
//
//  Created by Cris Messias on 27/03/24.
//

import XCTest
@testable import Login
@testable import Models
import Dependencies

final class LoginEmailViewModelTests: XCTestCase {

    func testConfirmationPopupAppears() {
        let viewModel = LoginEmailViewModel()
        viewModel.confirmationPopupAppears()
        let expectation = XCTestExpectation(description: "Confirmation popup should appear")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertEqual(viewModel.alertOffSetY, 1000, "OffsetY should be updated to 1000")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    func testCloseButtonTapped() {
        let viewModel = LoginEmailViewModel()
        var closeButtonCalled = false
        viewModel.delegateCloseButtonTapped = {
            closeButtonCalled = true
        }
        
        viewModel.closeButtonTapped()
        XCTAssertTrue(closeButtonCalled, "The delegate should be called")
    }

    func clearEmailInputTapped() {
        let viewModel = LoginEmailViewModel()
        viewModel.emailInput = "email@valid.com"
        viewModel.isLoginEmailButtonPressed = true

        viewModel.clearEmailInputTapped()
        XCTAssertTrue(viewModel.emailInput.isEmpty, "Should be empty")
        XCTAssertFalse(viewModel.isLoginEmailButtonPressed,  "Should set false")
    }

    func clearPasswordInputTapped() {
        let viewModel = LoginEmailViewModel()
        viewModel.passwordInput = "12345678"
        viewModel.isLoginEmailButtonPressed = true

        viewModel.clearPasswordInputTapped()
        XCTAssertTrue(viewModel.passwordInput.isEmpty, "Should be empty")
        XCTAssertFalse(viewModel.isLoginEmailButtonPressed,  "Should set false")
    }

    func inputEmailTapped() {
        let viewModel = LoginEmailViewModel()
        viewModel.isLoginEmailButtonPressed = true
        
        viewModel.clearEmailInputTapped()
        XCTAssertFalse(viewModel.isLoginEmailButtonPressed, "Should set false")
    }

    func testErrorMessageNoEmailProvided() {
        let viewModel = LoginEmailViewModel()
        viewModel.isLoginEmailButtonPressed = true
        viewModel.emailInput = ""
        viewModel.passwordInput = "12345678"
        let result = viewModel.errorMessage()
        XCTAssertEqual(result, "Email or password not provided.")
    }

    func testErrorMessageNoPasswordProvided() {
        let viewModel = LoginEmailViewModel()
        viewModel.isLoginEmailButtonPressed = true
        viewModel.emailInput = "email@valid.com"
        viewModel.passwordInput = ""
        let result = viewModel.errorMessage()
        XCTAssertEqual(result, "Email or password not provided.")
    }

    func testErrorMessageInvalidEmail() {
        let viewModel = LoginEmailViewModel()
        viewModel.isLoginEmailButtonPressed = true
        viewModel.emailInput = "invalid"
        let result = viewModel.errorMessage()
        XCTAssertEqual(result, "Email or password not provided.")
    }

    @MainActor
    func testErrorMessageValidEmail() {
        let viewModel = LoginEmailViewModel()
        viewModel.emailInput = "email@valid.com"
        viewModel.passwordInput = "12345678"
        viewModel.loginEmailButtonTapped()
        let result = viewModel.errorMessage()
        XCTAssertTrue(viewModel.isValidEmail, "Shoud set true")
        XCTAssertNil(result, "Should not return any message")
    }
}
