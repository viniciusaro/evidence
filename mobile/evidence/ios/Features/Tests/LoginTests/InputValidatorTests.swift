//
//  inputValidatorTests.swift
//  
//
//  Created by Cris Messias on 16/05/24.
//

import XCTest
@testable import Login
@testable import Models
import Dependencies

final class InputValidatorTests: XCTestCase {
    @Dependency(\.inputValidator) var inputValidator

    func testIsValidEmailValid() {
        XCTAssertTrue(inputValidator.isValidEmail("test@example.com"))
    }

    func testIsValidEmailInvalid() {
        XCTAssertFalse(inputValidator.isValidEmail("invalid-email"))
    }

    func testIsValidEmailEmpty() {
        XCTAssertFalse(inputValidator.isValidEmail(""))
    }

    func testIsValidPasswordValid() {
        XCTAssertTrue(inputValidator.isValidEmail("test@example.com"))
    }

    func testIsValidPasswordInvalid() {
        XCTAssertFalse(inputValidator.isValidEmail("invalid-email"))
    }

    func testIsValidPasswordEmpty() {
        XCTAssertFalse(inputValidator.isValidEmail(""))
    }
}
