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
        XCTAssertTrue(inputValidator.isValidEmail("user@example.com"))
        XCTAssertTrue(inputValidator.isValidEmail("user91@example.com"))
        XCTAssertTrue(inputValidator.isValidEmail("user@sub.example.com"))
        XCTAssertTrue(inputValidator.isValidEmail("user.test@sub.example.com"))
        XCTAssertTrue(inputValidator.isValidEmail("user.test@example.com"))
        XCTAssertTrue(inputValidator.isValidEmail("user-test@example.com"))
    }

    func testIsValidEmailInvalid() {
        XCTAssertFalse(inputValidator.isValidEmail("user@test"))
        XCTAssertFalse(inputValidator.isValidEmail("user@test-a.com"))
        XCTAssertFalse(inputValidator.isValidEmail("user@-test.com"))
        XCTAssertFalse(inputValidator.isValidEmail("user@.com"))
        XCTAssertFalse(inputValidator.isValidEmail("@user"))
        XCTAssertFalse(inputValidator.isValidEmail("user@"))
        XCTAssertFalse(inputValidator.isValidEmail("user@"))
        XCTAssertFalse(inputValidator.isValidEmail("user@email.com.."))
        XCTAssertFalse(inputValidator.isValidEmail("user@email..com."))
        XCTAssertFalse(inputValidator.isValidEmail("user@email-a.com"))
        XCTAssertFalse(inputValidator.isValidEmail("user@email.com.br.io"))
    }

    func testIsValidEmailEmpty() {
        XCTAssertFalse(inputValidator.isValidEmail(""))
    }

    func testIsValidPasswordValid() {
        XCTAssertTrue(inputValidator.isValidPassword("moreThen8Caracteres"))
    }

    func testIsValidPasswordInvalid() {
        XCTAssertFalse(inputValidator.isValidPassword("123"))
    }

    func testIsValidPasswordEmpty() {
        XCTAssertFalse(inputValidator.isValidPassword(""))
    }
}
