//
//  SwiftUIView.swift
//  
//
//  Created by Cris Messias on 08/02/24.
//

import SwiftUI
import Dependencies

private struct LoginManagerEnvironmentDependency: DependencyKey {
    static var liveValue: LoginManager = FirebaseLoginManager()
    static var previewValue: LoginManager = AuthenticatedLoginManager()
    static var testValue: LoginManager = AuthenticatedLoginManager()
}

extension DependencyValues {
    var loginManager: LoginManager {
        get { self[LoginManagerEnvironmentDependency.self] }
        set { self[LoginManagerEnvironmentDependency.self] = newValue }
    }
}

