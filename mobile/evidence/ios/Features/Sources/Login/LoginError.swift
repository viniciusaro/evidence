//
//  File.swift
//  
//
//  Created by Cris Messias on 16/05/24.
//

import Foundation

enum LoginError: Error {
    case emailOrPasswordNotProvide
    case emailNotProvide
    case invalidEmailOrPassword
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
    case userNotFound
    case networkError
    case internalError
    case tooManyRequests
    case userDisabled
    case unknown

    var errorDescription: String? {
        switch self {
        case .emailOrPasswordNotProvide: 
            "Email or password not provided."
        case.emailNotProvide:
            "Email not provided."
        case.invalidEmailOrPassword:
            "Email or password not valid."
        case.invalidEmail:
            "The email address is badly formatted."
        case.emailAlreadyInUse:
            "The email address is already in use by another account."
        case .userNotFound:
            "There is no user record corresponding to this identifier. The user may have been deleted."
        case .weakPassword:
            "The password must be 6 characters long or more."
        case .networkError:
            "A network error has occurred. Please try again."
        case.internalError:
            "An internal error has occurred. Please try again."
        case .tooManyRequests:
            "Too many requests. Please try again later."
        case .userDisabled:
            "The user account has been disabled by an administrator."
        case .unknown:
            "Something get wrong, call the manager."
        }
    }
}

