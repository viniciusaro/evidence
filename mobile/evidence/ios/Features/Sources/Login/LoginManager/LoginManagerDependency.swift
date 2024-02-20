//
//  SwiftUIView.swift
//  
//
//  Created by Cris Messias on 08/02/24.
//

import SwiftUI
import Dependencies

//private struct LoginManagerEnvironment: EnvironmentKey {
//    static let defaultValue: LoginManager = LoginManager()
//}
//
//extension EnvironmentValues {
//    var loginManager: LoginManager {
//        get { self[LoginManagerEnvironment.self] }
//        set { self[LoginManagerEnvironment.self] = newValue }
//    }
//}

private struct LoginManagerDependency: DependencyKey {
    static var liveValue: LoginManager = LoginManager()
}

extension DependencyValues {
    var loginManager: LoginManager {
        get { self[LoginManagerDependency.self] }
        set { self[LoginManagerDependency.self] = newValue }
    }
}

