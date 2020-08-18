//
//  Movie.swift
//  Corny
//
//  Created by ofek aziel on 18/08/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import Foundation

class Movie {
    
    let id:String
    var actors: String
    var description: String
    var director: String
    var genre: String
    var imageUrl: String
    var name: String
    
    init(json: [String: Any]) {
        self.id = json["documentId"] as! String
        self.name = json["name"] as! String
        self.genre = json["genre"] as! String
        self.actors = json["actors"] as! String
        self.director = json["director"] as! String
        self.description = json["description"] as! String
        self.imageUrl = json["image_url"] as! String
    }
    
    init(id: String, name: String, genre: String, actors: String, director: String, description: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.genre = genre
        self.actors = actors
        self.director = director
        self.description = description
        self.imageUrl = imageUrl
    }
}
