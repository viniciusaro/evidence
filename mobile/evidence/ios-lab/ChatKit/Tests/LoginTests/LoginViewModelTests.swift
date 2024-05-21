//
//  LoginTests.swift
//
//
//  Created by Cris Messias on 19/01/24.
//

import XCTest
@testable import ChatKit
@testable import Models
@testable import Dependencies


final class LoginViewModelTests: XCTestCase {
    func testGettingStartedButtonTapped() {
        let viewModel = LoginViewModel(loginSettingViewModel: LoginSettingViewModel())
        viewModel.gettingStartedButtonTapped()
        XCTAssertTrue(viewModel.showLoginAuthModal, "Should to be true")
    }

    func testContinueWithEmailButtonTappedViewModelCreated() {
        let viewModel = LoginViewModel(loginSettingViewModel: LoginSettingViewModel())
        viewModel.continueWithEmailButtonTapped()
        XCTAssertNotNil(viewModel.loginEmailViewModel, "An instance should be created")
    }

    func testContinueWithEmailButtonTappedDelegationCalled() {
        let viewModel = LoginEmailViewModel()
        var closeButtonCalled = false
        viewModel.delegateCloseButtonTapped = {
            closeButtonCalled = true
        }
        viewModel.closeButtonTapped()
        XCTAssertTrue(closeButtonCalled, "The delegate should be called")
    }
}
