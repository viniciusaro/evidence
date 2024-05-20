//
//  LoginResetPasswordViewModel.swift
//
//
//  Created by Cris Messias on 19/04/24.
//

import AuthClient
@testable import ChatKit
import Dependencies
import Models
import XCTest

final class LoginResetPasswordViewModelTests: XCTestCase {
    @Dependency(\.inputValidator) private var inputValidator
    
    func testCloseButtonTapped() {
        let viewModel = LoginResetPasswordViewModel()
        var closeButtonCalled = false
        viewModel.delegateCloseButtonTapped = {
            closeButtonCalled = true
        }
        viewModel.closeButtonTapped()
        XCTAssertTrue(closeButtonCalled, "The delegate should be called")
    }

    func testClearEmailInputTapped() {
        let viewModel = LoginResetPasswordViewModel()
        viewModel.emailInput = "email@valid.com"
        viewModel.isResetPasswordButtonPressed = true

        viewModel.clearEmailInputTapped()
        XCTAssertFalse(viewModel.isResetPasswordButtonPressed, "Should set to false")
        XCTAssertTrue(viewModel.emailInput.isEmpty, "Should be Empty")
    }

    func testInputEmailTapped() {
        let viewModel = LoginResetPasswordViewModel()
        viewModel.isResetPasswordButtonPressed = true

        viewModel.inputEmailTapped()
        XCTAssertFalse(viewModel.isResetPasswordButtonPressed, "Should set to false")
    }

    func testResetPasswordButtonTappedValidEmail() {
        let viewModel = LoginResetPasswordViewModel()
        viewModel.emailInput = "email@valid.com"
        viewModel.isResetPasswordButtonPressed = false

        var closeButtonTappedCalled = false
        viewModel.delegateCloseButtonTapped = {
            closeButtonTappedCalled = true
        }

        viewModel.resetPasswordButtonTapped()
        XCTAssertTrue(viewModel.inputValidator.isValidEmail(viewModel.emailInput), "Shoud set totrue")
        XCTAssertTrue(viewModel.isResetPasswordButtonPressed, "Should set to true")
        XCTAssertTrue(closeButtonTappedCalled, "Should set to true")
    }

    /// errorMessage
    func testErrorMessageNoEmailProvided() {
        let viewModel = LoginResetPasswordViewModel()
        viewModel.isResetPasswordButtonPressed = true
        viewModel.emailInput = ""
        let errorMessage = viewModel.errorMessage()
        XCTAssertEqual(errorMessage, LoginError.emailNotProvide.errorDescription)
    }

    func testErrorMessageEmailNotValid() {
        let viewModel = LoginResetPasswordViewModel()
        viewModel.isResetPasswordButtonPressed = true
        viewModel.emailInput = "user@email"
        let result = viewModel.errorMessage()
        XCTAssertEqual(result, LoginError.invalidEmail.errorDescription)
    }

    func testSignInMessageError() {
        let viewModel = LoginResetPasswordViewModel()
        viewModel.isResetPasswordButtonPressed = true
        viewModel.resetMessageError = "Custom Message"
        XCTAssertNotNil(viewModel.resetMessageError)
    }

    func testNoError() {
        let viewModel = LoginResetPasswordViewModel()
        viewModel.isResetPasswordButtonPressed = false
        viewModel.emailInput = "test@example.com"
        let errorMessage = viewModel.errorMessage()
        XCTAssertNil(errorMessage)
    }
}
