//
//  MoviesViewController.swift
//  Corny
//
//  Created by ofek aziel on 16/01/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    var db: Firestore!
//    var ref: DatabaseReference!

//    var ref = Database.database().reference(withPath: "movies")
    
    let movies = [("Test"),("Test2"),("Test3"),("Test4"),("Test5"),("Test6"),("Test7"),("Test8")]
//    var movies: [[String : Any]] = []
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        db = Firestore.firestore()
//        db.collection("movies").getDocuments() { (snapshot, err) in
//            if err != nil {
//                print(err)
//            } else {
//                for document in (snapshot?.documents)! {
////                    self.move = document.data()["name"]
//                    print(document.data())
////                    self.movies.append(document.data())
//
//                }
//            }
//        }
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MovieCell")

        createAddButtonOnNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewItemSize()
    }
    
    private func setupCollectionViewItemSize() {
        if (collectionViewFlowLayout == nil) {
            let width = 180//(collectionView.frame.width - (numberOfItemPerRow - 1) * interItemSpacing) / numberOfItemPerRow
            let height = 250//width
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = 10
            collectionViewFlowLayout.minimumInteritemSpacing = 5
            
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
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
    extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        
        let cellIndex = indexPath.item
        
        cell.contentView.layer.masksToBounds = false
        cell.contentView.layer.backgroundColor = UIColor.white.cgColor
        cell.contentView.layer.cornerRadius = 12
        
        cell.layer.masksToBounds = false
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.23
        
        //cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
        
        //cell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
        cell.movieName.text = movies[cellIndex]
        cell.movieGenre.text = "test"
        cell.movieImage.image = nil
        
        return cell
    }
        
        @objc func tap(_ sender: UITapGestureRecognizer) {

       let location = sender.location(in: self.collectionView)
       let indexPath = self.collectionView.indexPathForItem(at: location)

       if let index = indexPath {
          print("Got clicked on index: \(index)!")
       }
    }
 }

