//
//  Comment.swift
//  Corny
//
//  Created by ofek aziel on 18/08/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import Foundation

class Comment {
    
    let id:String
    var comment: String
    var createdAt: Timestamp
    var userId: String
    
    init(json: [String: Any]) {
        self.id = json["documentId"] as! String
        self.comment = json["comment"] as! String
        self.createdAt = json["createdAt"] as! Timestamp
        self.userId = json["userId"] as! String
    }
}
