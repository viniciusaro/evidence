//
//  LoginTestsViewModel.swift
//  
//
//  Created by Cris Messias on 27/03/24.
//

import XCTest
@testable import Login
@testable import Models

final class LoginEmailViewModelTests: XCTestCase {

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
        viewModel.clearEmailInputTapped()
        XCTAssertTrue(viewModel.loginEmailInput.isEmpty, "Should be empty")
        XCTAssertFalse(viewModel.isNextButtonPressed,  "Should set false")
    }

    func inputEmailTapped() {
        let viewModel = LoginEmailViewModel()
        viewModel.clearEmailInputTapped()
        XCTAssertFalse(viewModel.isNextButtonPressed, "Should set false")
    }

    func testButtonNextTappedValidEmail() {
        let viewModel = LoginEmailViewModel()
        viewModel.loginEmailInput = "email@valid.com"
        viewModel.buttonNextTapped()
        XCTAssertTrue(viewModel.isLoginEmailValidEmail, "Should be a valid email")
        XCTAssertTrue(viewModel.isNextButtonPressed, "Should set True")
        XCTAssertNotNil(viewModel.loginCheckViewModel, "Should create an instance of LoginEmailViewModel()" )
    }


    func testButtonNextTappedNotValidEmail() {
        let viewModel = LoginEmailViewModel()
        viewModel.loginEmailInput = "invalid-email"
        viewModel.buttonNextTapped()
        XCTAssertFalse(viewModel.isLoginEmailValidEmail, "Should not be a valid email")
        XCTAssertTrue(viewModel.isNextButtonPressed, "Should set True")
        XCTAssertNil(viewModel.loginCheckViewModel, "Should not create an instance of LoginEmailViewModel()")
    }

    func testErrorMessageNoEmailProvided() {
        let viewModel = LoginEmailViewModel()
        viewModel.isNextButtonPressed = true
        viewModel.loginEmailInput = ""
        let result = viewModel.errorMessage()
        XCTAssertEqual(result, "No email provided.")
    }

    func testErrorMessageInvalidEmail() {
        let viewModel = LoginEmailViewModel()
        viewModel.isNextButtonPressed = true
        viewModel.loginEmailInput = "invalid"
        let result = viewModel.errorMessage()
        XCTAssertEqual(result, "That doesn't look like a valid email address!")
    }

    func testErrorMessageValidEmail() {
        let viewModel = LoginEmailViewModel()
        viewModel.loginEmailInput = "email@valid.com"
        viewModel.buttonNextTapped()
        let result = viewModel.errorMessage()
        XCTAssertTrue(viewModel.isLoginEmailValidEmail, "Shoud set true")
        XCTAssertNil(result, "Should not return any message")
    }

    func testIsValidEmailValid() {
        let viewModel = LoginEmailViewModel()
        XCTAssertTrue(viewModel.isValidEmail("test@example.com"))
    }

    func testIsValidEmailInvalid() {
        let viewModel = LoginEmailViewModel()
        XCTAssertFalse(viewModel.isValidEmail("invalid-email"))
    }

    func testIsValidEmailEmpty() {
        let viewModel = LoginEmailViewModel()
        XCTAssertFalse(viewModel.isValidEmail(""))
    }

}
