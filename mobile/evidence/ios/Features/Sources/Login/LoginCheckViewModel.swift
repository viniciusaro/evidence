//
//  LoginCheckViewModel.swift
//
//
//  Created by Cris Messias on 26/01/24.
//

import Foundation

public class LoginCheckViewModel: ObservableObject, Identifiable {
    public var id = UUID()
    @Published var mockEmail: String

    public init(mockEmail: String = "myemail@gmail.com") {
        self.mockEmail = mockEmail
    }
}
