//
//  SwiftUIView.swift
//  
//
//  Created by Cris Messias on 20/02/24.
//

import SwiftUI

protocol LoginManager {
    func createUser(email: String, password: String) async -> Result<Login, LoginError>
    func getAuthenticationUser() -> Result<Login, LoginError>
    func signIn(email: String, password: String) async -> Result<Login, LoginError>
    func signOut() -> Result<Void, LoginError>
    func resetPassword(email: String) async -> Result<Void, LoginError>
}
