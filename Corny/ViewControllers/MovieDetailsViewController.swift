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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        image = UIImageView()
        image.sd_setImage(with: movieImage, placeholderImage: UIImage(named: "defaultMovie.jpg"))
        name.text = movieName
        genre.text = movieGenre
        actors.text = movieActors
        directors.text = movieDirector
        movieDesc.text = desc
        
        // Do any additional setup after loading the view.
    }
    

}
