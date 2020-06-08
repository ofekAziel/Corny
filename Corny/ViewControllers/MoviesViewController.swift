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
        
        let collectionRef = db.collection("movies")
        
        collectionRef.addSnapshotListener { (querySnapshot, err) in
            if let movies = querySnapshot?.documents {
                for movie in movies {
                    self.moviesArr.append(movie.data())
                }
                
                self.collectionView?.reloadData()
            }
            
            print(self.moviesArr)
        }
    }
    
    private func setupCollectionViewItemSize() {
        if (collectionViewFlowLayout == nil) {
            let screenSize: CGRect = UIScreen.main.bounds
            let width = ( screenSize.width / 2 ) - 10
            //let width = 190//(collectionView.frame.width - (numberOfItemPerRow - 1) * interItemSpacing) / numberOfItemPerRow
            let height = 250//width
            
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
        
        let uid = moviesArr[cellIndex]["image_uid"] as? String
        
        if uid != nil {
        let query = Firestore.firestore().collection("images").document(uid!)
            
        query.getDocument { (document, err) in
           if let document = document, document.exists {
////                if let filePath = Bundle.main.path(forResource: document.data()!["url"] as? String, ofType: "jpg"), let image = UIImage(contentsOfFile: filePath) {
////                    cell.movieImage.contentMode = .scaleAspectFit
////                    cell.movieImage.image = image
////                }
//
            let data = document.data()
            let test = data!["url"] as! String
                
//            let imageRef = self.storage.reference(forURL: test)
//            let imageRef =
            
//            let img = cell.movieImage.image
            
            
//            imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
//              // Create a UIImage, add it to the array
//                let pic = UIImage(data: data!)
//              cell.movieImage.image = pic
//            }
//
//                //var customAllowedSet =  NSCharacterSet(charactersIn:"=\"#%/<>?@\\^`{|}").inverted
//                let allowedCharacterSet = (CharacterSet(charactersIn: "^!*'();:@&=+$,/?%#[] ").inverted)
//                var escapedString = test.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                //stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
//
//                let imageURL = URL(string: escapedString!)
//
//                DispatchQueue.global().async {
//                    guard let imageData = try? Data(contentsOf: imageURL!) else { return }
//
//                       let image = UIImage(data: imageData)
//                       DispatchQueue.main.async {
//                           cell.movieImage.image = image
//                       }
//                   }
//
//                //cell.movieImage.load(url: url)
//                //print(url)
            }
       }
       }
        
        //cell.movieImage.image = nil
        
        return cell
    }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = storyboard?.instantiateViewController(identifier: "MovieDetailsViewController") as? MovieDetailsViewController
            
            //vc?.navItem.title = moviesArr[indexPath.row]["name"] as? String
            vc?.movieName = moviesArr[indexPath.row]["name"] as! String
            vc?.movieGenre = moviesArr[indexPath.row]["genre"] as! String
            vc?.movieActors = moviesArr[indexPath.row]["actors"] as! String
            vc?.movieDirector = moviesArr[indexPath.row]["director"] as! String
            vc?.desc = moviesArr[indexPath.row]["description"] as! String
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

