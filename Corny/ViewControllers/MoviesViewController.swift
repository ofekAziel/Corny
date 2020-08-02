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

struct movie {
    var actors: String
    var description: String
    var director: String
    var genre: String
    var imageUID: String
    var name: String
}

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    var db: Firestore!
    var storageRef: StorageReference!
    var storage: Storage!
    var moviesArr: [[String : Any]] = []
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData()
        
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
    
    private func getData() {
        db = Firestore.firestore()
        storage = Storage.storage()
        storageRef = storage.reference()
        
        let collectionRef = db.collection("movies")
        
        collectionRef.addSnapshotListener { (querySnapshot, err) in
            self.moviesArr = [];
            if let movies = querySnapshot?.documents {
                for movie in movies {
                    self.moviesArr.append(movie.data())
                }
                
                self.collectionView?.reloadData()
            }
        }
    }
    
    private func setupCollectionViewItemSize() {
        if (collectionViewFlowLayout == nil) {
            let screenSize: CGRect = UIScreen.main.bounds
            let width = ( screenSize.width / 2 ) - 10
            let height = 250//width
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            
            collectionViewFlowLayout.itemSize = CGSize(width: Int(width), height: height)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = 10
            collectionViewFlowLayout.minimumInteritemSpacing = 5
            
            //collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
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
        return moviesArr.count
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
        
        //cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
        
        cell.movieName.text = moviesArr[cellIndex]["name"] as? String
        cell.movieGenre.text = moviesArr[cellIndex]["genre"] as? String
        
        // Get image url and set it to imageView
        let url = moviesArr[cellIndex]["image_url"] as! String
        let imageRef = self.storage.reference(forURL: url)
        cell.movieImage.sd_setImage(with: imageRef, placeholderImage: UIImage(named: "defaultMovie.jpg"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "MovieDetailsViewController") as? MovieDetailsViewController
        
        vc?.movieName = moviesArr[indexPath.row]["name"] as! String
        vc?.movieGenre = moviesArr[indexPath.row]["genre"] as! String
        vc?.movieActors = moviesArr[indexPath.row]["actors"] as! String
        vc?.movieDirector = moviesArr[indexPath.row]["director"] as! String
        vc?.desc = moviesArr[indexPath.row]["description"] as! String
        
        // Get image url and set it to imageView
        let url = moviesArr[indexPath.row]["image_url"] as! String
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

