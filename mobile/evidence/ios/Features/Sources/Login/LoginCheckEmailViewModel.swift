//
//  LoginCheckViewModel.swift
//
//
//  Created by Cris Messias on 26/01/24.
//

import Foundation

final public class LoginCheckViewModel: ObservableObject, Identifiable, Hashable {
    public static func == (lhs: LoginCheckViewModel, rhs: LoginCheckViewModel) -> Bool {
        return lhs.mockEmail == rhs.mockEmail
    }
    public func hash(into hasher: inout Hasher) { hasher.combine(mockEmail) }

    public var id = UUID()
    @Published var mockEmail: String

    public init(mockEmail: String = "myemail@gmail.com") {
        self.mockEmail = mockEmail
    }
}
