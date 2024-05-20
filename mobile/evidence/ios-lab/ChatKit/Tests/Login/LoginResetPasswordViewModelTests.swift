//
//  LoginResetPasswordViewModel.swift
//
//
//  Created by Cris Messias on 19/04/24.
//

import XCTest
@testable import ChatKit
@testable import Models

final class LoginResetPasswordViewModelTests: XCTestCase {

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
        XCTAssertTrue(viewModel.isValidEmail(viewModel.emailInput), "Shoud set totrue")
        XCTAssertTrue(viewModel.isResetPasswordButtonPressed, "Should set to true")
        XCTAssertTrue(closeButtonTappedCalled, "Should set to true")
    }

    func testErrorMessageEmailNotProvided() {
        let viewModel = LoginResetPasswordViewModel()
        viewModel.isResetPasswordButtonPressed = true
        viewModel.emailInput = ""

        let result = viewModel.errorMessage()
        XCTAssertEqual(result, "Email not provided.", "The return message should be the same.")
    }

    func testErrorMessageEmailNotValid() {
        let viewModel = LoginResetPasswordViewModel()
        viewModel.isResetPasswordButtonPressed = true
        viewModel.emailInput = "invalid"

        let result = viewModel.errorMessage()
        XCTAssertEqual(result, "Email not valid.", "The return message should be the same.")
    }

    func testErrorMessageNoError() {
        let viewModel = LoginResetPasswordViewModel()
        viewModel.isResetPasswordButtonPressed = false
        viewModel.emailInput = "email@valid.com"

        let result = viewModel.errorMessage()
        XCTAssertTrue(viewModel.isValidEmail(viewModel.emailInput), "Shoud set true")
        XCTAssertNil(result, "Should not return any message")
    }

    func testIsValidEmailValid() {
        let viewModel = LoginResetPasswordViewModel()
        XCTAssertTrue(viewModel.isValidEmail("test@example.com"))
    }
}
