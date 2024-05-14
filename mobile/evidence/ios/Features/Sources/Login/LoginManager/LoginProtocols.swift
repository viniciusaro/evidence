//
//  SwiftUIView.swift
//  
//
//  Created by Cris Messias on 20/02/24.
//

import SwiftUI

protocol LoginManager {
    func creatUser(email: String, password: String) async throws -> Login
    func getAuthenticationUser() throws -> Login
    func signIn(email: String, password: String) async throws -> Login
    func signOut() throws
    func resetPassword(email: String) async throws
}
