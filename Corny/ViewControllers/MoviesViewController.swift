//
//  HomeViewController.swift
//  Corny
//
//  Created by ofek aziel on 16/01/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createAddButtonOnNavigationBar()
    }
    
    func createAddButtonOnNavigationBar() {
        let addMoviewButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMovie))
        self.navigationItem.rightBarButtonItem = addMoviewButton
    }
    
    @objc func addMovie() {
        transitionToEditMovieScreen()
    }
    
    func transitionToEditMovieScreen() {
        performSegue(withIdentifier: "addMovie", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditMovieViewController
        destinationVC.isAddMovie = true
    }
}
