//
//  Comment.swift
//  Corny
//
//  Created by ofek aziel on 18/08/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import Foundation
import FirebaseFirestore

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
    
    init(id: String, comment: String, createdAt: String, userId: String) {
        self.id = id
        self.comment = comment
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.createdAt = Timestamp.init(date: dateFormatter.date(from: createdAt)!)
        self.userId = userId
    }
}
