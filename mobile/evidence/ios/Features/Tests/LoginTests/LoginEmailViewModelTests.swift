//
//  LoginTestsViewModel.swift
//  
//
//  Created by Cris Messias on 27/03/24.
//

import XCTest
import Dependencies
@testable import Login
@testable import Models

final class LoginEmailViewModelTests: XCTestCase {
    @Dependency(\.inputValidator) private var inputValidator

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

    
    /// errorMessage
    func testErrorMessageNoEmailProvided() {
        let viewModel = LoginEmailViewModel()
        viewModel.isLoginEmailButtonPressed = true
        viewModel.emailInput = ""
        viewModel.passwordInput = "password"
        let errorMessage = viewModel.errorMessage()
        XCTAssertEqual(errorMessage, LoginError.credentialNotProvide.errorDescription)
    }

    func testErrorMessageNoPasswordProvided() {
        let viewModel = LoginEmailViewModel()
        viewModel.isLoginEmailButtonPressed = true
        viewModel.emailInput = "email@valid.com"
        viewModel.passwordInput = ""
        let errorMessage = viewModel.errorMessage()
        XCTAssertEqual(errorMessage, LoginError.credentialNotProvide.errorDescription)
    }

    func testNoError() {
        let viewModel = LoginEmailViewModel()
        viewModel.isLoginEmailButtonPressed = false
        viewModel.emailInput = "test@example.com"
        viewModel.passwordInput = "password"
        let errorMessage = viewModel.errorMessage()
        XCTAssertNil(errorMessage)
    }
}
