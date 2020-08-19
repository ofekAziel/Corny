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
import FirebaseStorage
import FirebaseUI
import FirebaseAuth

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    var db: Firestore!
    var storageRef: StorageReference!
    var storage: Storage!
    var movies: [Movie] = []
    var currentUser: User!
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        storage = Storage.storage()
        storageRef = storage.reference()
        
//        MovieDB.deleteAllMovies(database: DBHelper.instance.db) USE JUST IF YOU WANT TO CLEAR ALL ROWS
        Utilities.makeSpinner(view: self.view)
        self.getData()
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MovieCell")
        getCurrentUser()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewItemSize()
    }
    
    private func getCurrentUser() {
        let currentUserUid = Auth.auth().currentUser!.uid
        var data: [String: Any] = [:]
        
        db.collection(Constants.Firestore.usersCollection).whereField("user_uid", isEqualTo: currentUserUid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                self.showAlert(alertText: err.localizedDescription)
            } else {
                data = querySnapshot!.documents.first!.data()
                data.updateValue(querySnapshot!.documents.first!.documentID, forKey: "documentId")
                Utilities.removeSpinner()
                self.currentUser = User(json: data)
                
                if (self.currentUser.isAdmin) {
                    self.createAddButtonOnNavigationBar()
                }
            }
        }
    }
    
    func showAlert(alertText:String) {
        let alert = UIAlertController(title: "Error", message: alertText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getData() {
        var data: [String: Any] = [:]
        let collectionRef = db.collection("movies")
        
        self.movies = MovieDB.getAllMoviesFromDb(database: DBHelper.instance.db)
        
        collectionRef.addSnapshotListener { (querySnapshot, err) in
            if let movies = querySnapshot?.documents {
                for movie in movies {
                    data = movie.data()
                    data.updateValue(movie.documentID, forKey: "documentId")
                    MovieDB.addOrUpdateMovieToDb(movie: Movie(json: data), database: DBHelper.instance.db)
                }
                
                self.movies = MovieDB.getAllMoviesFromDb(database: DBHelper.instance.db)
                self.collectionView?.reloadData()
            }
        }
    }
    
    private func setupCollectionViewItemSize() {
        if (collectionViewFlowLayout == nil) {
            let screenSize: CGRect = UIScreen.main.bounds
            let width = ( screenSize.width / 2 ) - 10
            let height = 250
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: Int(width), height: height)
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
        let cellIndex = indexPath.row
        
        cell.contentView.layer.masksToBounds = false
        cell.contentView.layer.backgroundColor = UIColor.white.cgColor
        cell.contentView.layer.cornerRadius = 12
        cell.layer.masksToBounds = false
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.23
        cell.layer.cornerRadius = 12
        
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
        
        cell.movieName.text = movies[cellIndex].name
        cell.movieGenre.text = movies[cellIndex].genre
        
        // Get image url and set it to imageView
        let url = movies[cellIndex].imageUrl
        let imageRef = self.storage.reference(forURL: url)
        cell.movieImage.sd_setImage(with: imageRef, placeholderImage: UIImage(named: "defaultMovie.jpg"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "MovieDetailsViewController") as? MovieDetailsViewController
        
        vc?.movie = movies[indexPath.row]
        vc?.currentUser = currentUser
        
        // Get image url and set it to imageView
        let url = movies[indexPath.row].imageUrl
        let imageRef = self.storage.reference(forURL: url)
        vc?.movieImage = imageRef
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension String {
    private static let slugSafeCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-")
    
    public func convertedToSlug() -> String? {
        if let latin = self.applyingTransform(StringTransform("Any-Latin; Latin-ASCII; Lower;"), reverse: false) {
            let urlComponents = latin.components(separatedBy: String.slugSafeCharacters.inverted)
            let result = urlComponents.filter { $0 != "" }.joined(separator: "-")
            
            if result.count > 0 {
                return result
            }
        }
        
        return nil
    }
}

