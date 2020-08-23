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
    var movieId: String
    
    init(json: [String: Any]) {
        self.id = json["documentId"] as! String
        self.comment = json["comment"] as! String
        self.createdAt = json["createdAt"] as! Timestamp
        self.userId = json["userId"] as! String
        self.movieId = json["movieId"] as! String
    }
    
    init(id: String, comment: String, createdAt: Date, userId: String, movieId: String) {
        self.id = id
        self.comment = comment
        self.createdAt = Timestamp(date: createdAt)
        self.userId = userId
        self.movieId = movieId
    }
}
