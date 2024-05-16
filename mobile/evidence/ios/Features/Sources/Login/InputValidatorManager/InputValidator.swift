//
//  File.swift
//  
//
//  Created by Cris Messias on 16/05/24.
//

import Foundation


final public class InputValidator {
    func isValidEmail(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = #"^.{8,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
