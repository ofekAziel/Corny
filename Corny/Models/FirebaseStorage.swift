//
//  FirebaseStorage.swift
//  Corny
//
//  Created by ofek aziel on 18/08/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseStorage {
    
    static func uploadPhotoAndMovieToFirestore(view: UIView, movieImage: UIImage?, movie: Movie?, isAddMovie: Bool, name: String, genre: String, actors: String, director: String, description: String, editMovieViewController: UIViewController) {
        Utilities.makeSpinner(view: view)
        guard let image = movieImage, let data = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let imageName = UUID().uuidString
        let imageRef = Storage.storage().reference().child(Constants.Storgae.imagesFolder).child(imageName)
        
        imageRef.putData(data, metadata: nil) { (metadata, err) in
            if err != nil {
                return
            }
            
            imageRef.downloadURL { (url, err) in
                if err != nil {
                    return
                }
                
                guard let url = url else {
                    return
                }
                
                MovieFirebase.saveMovieToDatabase(movie: movie, isAddMovie: isAddMovie, name: name, genre: genre, actors: actors, director: director, description: description, imageUrl: url.absoluteString, editMovieViewController: editMovieViewController)
            }
        }
    }
    
    static func deleteMoviePhoto(movieImage: StorageReference) {
        movieImage.delete { error in
            if error != nil {
            }
        }
    }
}
