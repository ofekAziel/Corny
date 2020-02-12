//
//  MoviesViewController.swift
//  Corny
//
//  Created by ofek aziel on 16/01/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    let movies = [("Test"),("Test2"),("Test3"),("Test4")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        //let cellIndex = indexPath.item
        
        
        return cell
    }
}
