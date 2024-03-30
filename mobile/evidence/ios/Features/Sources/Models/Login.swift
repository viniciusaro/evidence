//
//  File.swift
//  
//
//  Created by Cris Messias on 01/02/24.
//

import Foundation

public struct Login {
    public let uid: String
    public let email: String?
    public let photoUrl: String?

    public init(uid: String, email: String?, photoUrl: String?) {
        self.uid = uid
        self.email = email
        self.photoUrl = photoUrl
    }
}
