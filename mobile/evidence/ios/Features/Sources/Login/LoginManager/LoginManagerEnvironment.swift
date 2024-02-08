//
//  SwiftUIView.swift
//  
//
//  Created by Cris Messias on 08/02/24.
//

import SwiftUI

private struct LoginManagerEnvironment: EnvironmentKey {
    static let defaultValue: LoginManager = LoginManager()
}

extension EnvironmentValues {
    var loginManager: LoginManager {
        get { self[LoginManagerEnvironment.self] }
        set { self[LoginManagerEnvironment.self] = newValue }
    }
}
