//
//  File.swift
//
//
//  Created by Cris Messias on 16/05/24.
//

import Foundation

public enum LoginError: Error {
    case invalidCredential
    case credentialNotProvide
    case emailNotProvide //
    case invalidEmail
    case emailAlreadyInUse
    case userNotFound
    case networkError
    case internalError
    case tooManyRequests
    case userDisabled
    case userAuthenticationFailed
    case unknown

    public var errorDescription: String? {
        switch self {
        case.invalidCredential:
            "Email or password not valid."
        case .credentialNotProvide:
            "Email or password not provided."
        case.emailNotProvide:
            "Email not provided."
        case.invalidEmail:
            "The email address is badly formatted."
        case.emailAlreadyInUse:
            "The email address is already in use by another account."
        case .userNotFound:
            "There is no user record corresponding to this identifier. The user may have been deleted."
        case .networkError:
            "A network error has occurred. Please try again."
        case.internalError:
            "An internal error has occurred. Please try again."
        case .tooManyRequests:
            "Too many requests. Please try again later."
        case .userDisabled:
            "The user account has been disabled by an administrator."
        case .userAuthenticationFailed:
            "Failed to authenticate user."
        case .unknown:
            "Something get wrong, call the manager."
        }
    }
}

