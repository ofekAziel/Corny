 //
//  MovieDetailsViewController.swift
//  Corny
//
//  Created by Samuel on 01/03/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import UIKit
 import FirebaseFirestore
import FirebaseStorage

class MovieDetailsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var actors: UILabel!
    @IBOutlet weak var directors: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var commentBtn: UIButton!
    
    var movieDocumentId = ""
    var movieImage: StorageReference!
    var movieName = ""
    var movieGenre = ""
    var movieActors = ""
    var movieDirector = ""
    var desc = ""
    var currentUser: [String: Any] = [:]
    
    var db: Firestore!
    var commentsArr: [[String : Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        image.sd_setImage(with: movieImage, placeholderImage: UIImage(named: "defaultMovie.jpg"))
        name.text = movieName
        genre.text = movieGenre
        actors.text = movieActors
        directors.text = movieDirector
        movieDesc.text = desc
        if (currentUser["is_admin"] as! Bool) {
            createEditButtonOnNavigationBar()
        }
        
        // For placeholder
        commentText.text = "Comment..."
        commentText.textColor = UIColor.lightGray
        commentText.returnKeyType = .done
        commentText.delegate = self
        
        commentText.layer.cornerRadius = 5
        commentBtn.layer.cornerRadius = 5
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        commentBtn.isEnabled = false
        
        getComments()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Comment..." {
            commentText.text = ""
            commentText.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "" && textView.text != "Comment..." {
            commentBtn.isEnabled = true
        } else {
            commentBtn.isEnabled = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            commentText.text = "Comment..."
            commentText.textColor = UIColor.lightGray
        }
    }
    
    private func getComments() {
        let collectionRef = db.collection(Constants.Firestore.moviesCollection).document(movieDocumentId).collection("comments")
        
        collectionRef.addSnapshotListener { (querySnapshot, err) in
            self.commentsArr = []
            if let comments = querySnapshot?.documents {
                for comment in comments {
                    self.commentsArr.append(comment.data())
                }
                
                print(self.commentsArr)
                self.tableView?.reloadData()
            }
            
        }
    }
    
    
    @IBAction func commentBtnPressed(_ sender: Any) {
        let movieCommentsRef = Firestore.firestore().collection(Constants.Firestore.moviesCollection).document(self.movieDocumentId).collection("comments").document()
        
        print(self.movieDocumentId)
        
        let movieComment = ["comment": self.commentText.text!, "createdAt": Date(), "userId": currentUser["uid"] ]
        
        movieCommentsRef.setData(movieComment as [String : Any]) { (err) in
            if err != nil {
                self.showAlert(alertText: "Can't save comment.")
            } else {
                self.commentText.text = "Comment..."
                self.commentText.textColor = UIColor.lightGray
            }
            
        }
        
    }
    
    func showAlert(alertText:String) {
        let alert = UIAlertController(title: "Error", message: alertText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        destinationVC.documentId = movieDocumentId
        destinationVC.isAddMovie = false
        destinationVC.movieImage = movieImage
        destinationVC.movieName = movieName
        destinationVC.genre = movieGenre
        destinationVC.actors = movieActors
        destinationVC.director = movieDirector
        destinationVC.movieDescription = desc
    }
 }
 
 extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        print("test1")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("test2")
        return commentsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("test3")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
            as! CommentTableViewCell
        let cellIndex = indexPath.row
        
        cell.commentText.text = commentsArr[cellIndex]["comment"] as? String
        
        db.collection(Constants.Firestore.usersCollection).whereField("user_uid", isEqualTo: commentsArr[cellIndex]["userId"]!).getDocuments(){ (querySnapshot, err) in
            
            let user = querySnapshot!.documents.first!.data()
                
            
        }
        
        
        return cell
    }
    
}

