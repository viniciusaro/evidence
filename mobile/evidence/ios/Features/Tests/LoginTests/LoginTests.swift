//
//  LoginTests.swift
//  
//
//  Created by Cris Messias on 19/01/24.
//

import XCTest
@testable import Login
@testable import Models


final class LoginTests: XCTestCase {
    ///LoginViewModel()
    func testGettingStartedButtonTapped() {
        let viewModel = LoginViewModel(loginSettingViewModel: LoginSettingViewModel())
        viewModel.gettingStartedButtonTapped()
        XCTAssertTrue(viewModel.showLoginAuthModal, "Should to be true")
    }

    func testLoginEmailButtonTapped() {
        let viewModel = LoginViewModel(loginSettingViewModel: LoginSettingViewModel())
        viewModel.loginEmailButtonTapped()
        XCTAssertNotNil(viewModel.loginEmailViewModel, "Should create an instance of LoginEmailViewModel()")
    }

    ///LoginEmailViewModel()
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
        XCTAssertTrue(viewModel.emailInput.isEmpty, "Should be empty")
        XCTAssertFalse(viewModel.isNextButtonPressed,  "Should set false")
    }

    func inputEmailTapped() {
        let viewModel = LoginEmailViewModel()
        viewModel.clearEmailInputTapped()
        XCTAssertFalse(viewModel.isNextButtonPressed, "Should set false")
    }

    func testButtonNextTappedValidEmail() {
        let viewModel = LoginEmailViewModel()
        viewModel.emailInput = "email@valid.com"
        viewModel.buttonNextTapped()
        XCTAssertTrue(viewModel.isValidEmail, "Should be a valid email")
        XCTAssertTrue(viewModel.isNextButtonPressed, "Should set True")
        XCTAssertNotNil(viewModel.loginCheckViewModel, "Should create an instance of LoginEmailViewModel()" )
    }


    func testButtonNextTappedNotValidEmail() {
        let viewModel = LoginEmailViewModel()
        viewModel.emailInput = "invalid-email"
        viewModel.buttonNextTapped()
        XCTAssertFalse(viewModel.isValidEmail, "Should not be a valid email")
        XCTAssertTrue(viewModel.isNextButtonPressed, "Should set True")
        XCTAssertNil(viewModel.loginCheckViewModel, "Should not create an instance of LoginEmailViewModel()")
    }

    func testErrorMessageNoEmailProvided() {
        let viewModel = LoginEmailViewModel()
        viewModel.isNextButtonPressed = true
        viewModel.emailInput = ""
        let result = viewModel.errorMessage()
        XCTAssertEqual(result, "No email provided.")
    }

    func testErrorMessageInvalidEmail() {
        let viewModel = LoginEmailViewModel()
        viewModel.isNextButtonPressed = true
        viewModel.emailInput = "invalid"
        let result = viewModel.errorMessage()
        XCTAssertEqual(result, "That doesn't look like a valid email address!")
    }

    func testErrorMessageValidEmail() {
        let viewModel = LoginEmailViewModel()
        viewModel.isNextButtonPressed = true
        viewModel.emailInput = "email@valid.com"
        viewModel.isValidEmail = true
        let result = viewModel.errorMessage()
        XCTAssertNil(result, "Not expecting error message for valid email")
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

    ///LoginCheckEmailViewModel()
}
