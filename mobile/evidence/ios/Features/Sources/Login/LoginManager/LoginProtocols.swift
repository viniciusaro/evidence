//
//  SwiftUIView.swift
//  
//
//  Created by Cris Messias on 20/02/24.
//

import SwiftUI

protocol LoginManager {
    func createUser(email: String, password: String) async -> Result<Login, LoginError>
    func getAuthenticationUser() throws -> Login
    func signIn(email: String, password: String) async -> Result<Login, LoginError>
    func signOut() throws
    func resetPassword(email: String) async -> Result<Void, LoginError>
}
