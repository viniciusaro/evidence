//
//  LoginCheckViewModel.swift
//
//
//  Created by Cris Messias on 26/01/24.
//

import Foundation

final public class LoginCheckEmailViewModel: ObservableObject, Identifiable, Hashable {
    public static func == (lhs: LoginCheckEmailViewModel, rhs: LoginCheckEmailViewModel) -> Bool {
        return lhs.emailInput == rhs.emailInput
    }
    public func hash(into hasher: inout Hasher) { hasher.combine(emailInput) }
    public var id = UUID()
    @Published var emailInput: String

    public init(emailInput: String = "") {
        self.emailInput = emailInput
    }
}
