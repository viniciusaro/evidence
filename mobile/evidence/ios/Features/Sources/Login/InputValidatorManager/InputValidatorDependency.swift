//
//  File.swift
//  
//
//  Created by Cris Messias on 16/05/24.
//

import Foundation
import Dependencies

private struct InputValidatorEnvironmentDependency: DependencyKey {
    static var liveValue: InputValidator = InputValidator()
    static var testValue: InputValidator = InputValidator()
}

extension DependencyValues {
    var inputValidator: InputValidator {
        get { self[InputValidatorEnvironmentDependency.self] }
        set { self[InputValidatorEnvironmentDependency.self] = newValue }
    }
}
