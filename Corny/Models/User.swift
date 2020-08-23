//
//  User.swift
//  Corny
//
//  Created by ofek aziel on 18/08/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import Foundation

class User {
    
    let id: String
    var firstName: String
    var lastName: String
    var isAdmin: Bool
    var userUid: String
    
    init(json: [String: Any]) {
        self.id = json["documentId"] as! String
        self.firstName = json["first_name"] as! String
        self.lastName = json["last_name"] as! String
        self.isAdmin = json["is_admin"] as! Bool
        self.userUid = json["user_uid"] as! String
    }
    
    init(id: String, firstName: String, lastName: String, isAdmin: Bool, userUid: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.isAdmin = isAdmin
        self.userUid = userUid
    }
}
