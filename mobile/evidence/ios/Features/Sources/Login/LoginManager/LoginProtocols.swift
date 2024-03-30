//
//  SwiftUIView.swift
//  
//
//  Created by Cris Messias on 20/02/24.
//

import SwiftUI
import Models

protocol LoginManager {
    func creatUser(email: String, password: String) async throws -> Login
    func getAuthenticationUser() throws -> Login
    func signOut() throws
}
