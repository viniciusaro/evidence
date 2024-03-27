//
//  LoginTests.swift
//  
//
//  Created by Cris Messias on 19/01/24.
//

import XCTest
@testable import Login
@testable import Models


final class LoginViewModelTests: XCTestCase {
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

    func testGetAuthenticationUserSuccess() {
        let autheUser = try? AuthenticatedLoginManager().getAuthenticationUser()
        XCTAssertNotNil(autheUser, "The user should exist")
    }

    func testGetAuthenticationUserFailure() {
        let autheUser = try? FailureAuthenticationLoginManager().getAuthenticationUser()
        XCTAssertNil(autheUser, "Shouldn't exist")
    }

}
