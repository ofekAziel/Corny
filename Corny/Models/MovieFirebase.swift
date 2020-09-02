//
//  MovieFirebase.swift
//  Corny
//
//  Created by ofek aziel on 18/08/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class MovieFirebase {
    
    static func saveMovieToDatabase(movie: Movie?, isAddMovie: Bool, name: String, genre: String, actors: String, director: String, description: String, imageUrl: String, editMovieViewController: UIViewController) {
        let moviesRef: DocumentReference
        
        if isAddMovie {
            moviesRef = Firestore.firestore().collection(Constants.Firestore.moviesCollection).document()
        }
        else {
            moviesRef = Firestore.firestore().collection(Constants.Firestore.moviesCollection).document(movie!.id)
        }
        
        let movieData = ["name":name, "genre":genre, "actors":actors, "director":director, "description":description, "image_url":imageUrl]
        
        moviesRef.setData(movieData) { (err) in
            if err != nil {
            } else {
                Utilities.removeSpinner()
               
                let dataDict:[String: String] = ["movieId": moviesRef.documentID]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: dataDict)
                editMovieViewController.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    static func deleteMovie(editMovieViewController: UIViewController, view: UIView, movie: Movie, movieImage: StorageReference) {
        Utilities.makeSpinner(view: view)
        FirebaseStorage.deleteMoviePhoto(movieImage: movieImage)
        deleteMovieComments(movie: movie)
        Firestore.firestore().collection(Constants.Firestore.moviesCollection).document(movie.id).delete() { err in
            if err != nil {
            } else {
                Utilities.removeSpinner()
                editMovieViewController.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    static func deleteMovieComments(movie: Movie) {
        let commentCollectionRef: CollectionReference = Firestore.firestore().collection(Constants.Firestore.moviesCollection).document(movie.id).collection(Constants.Firestore.commentsCollection)
        
        commentCollectionRef.getDocuments() { (querySnapshot, err)
            in if let comments = querySnapshot?.documents {
                for comment in comments {
                    commentCollectionRef.document(comment.documentID).delete()
                }
            }
        }
    }
}
