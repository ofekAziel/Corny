 //
//  MovieDetailsViewController.swift
//  Corny
//
//  Created by Samuel on 01/03/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import UIKit
import FirebaseStorage

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var actors: UILabel!
    @IBOutlet weak var directors: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    
    var movieImage: StorageReference!
    var movieName = ""
    var movieGenre = ""
    var movieActors = ""
    var movieDirector = ""
    var desc = ""
    var user: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.sd_setImage(with: movieImage, placeholderImage: UIImage(named: "defaultMovie.jpg"))
        name.text = movieName
        genre.text = movieGenre
        actors.text = movieActors
        directors.text = movieDirector
        movieDesc.text = desc
        if (user["is_admin"] as! Bool) {
            createEditButtonOnNavigationBar()
        }
    }
    
    func createEditButtonOnNavigationBar() {
        let editMoviewButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(transitionToEditMovieScreen))
        self.navigationItem.rightBarButtonItem = editMoviewButton
    }
    
    @objc func transitionToEditMovieScreen() {
        performSegue(withIdentifier: "editMovie", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditMovieViewController
        destinationVC.isAddMovie = false
        destinationVC.movieImage = movieImage
        destinationVC.movieName = movieName
        destinationVC.genre = movieGenre
        destinationVC.actors = movieActors
        destinationVC.director = movieDirector
        destinationVC.movieDescription = desc
    }
}
