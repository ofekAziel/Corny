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
    
    var movie: Movie!
    var movieImage: StorageReference!
    var currentUser: User!
    var comments: [Comment] = []
    var db: Firestore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        image.sd_setImage(with: movieImage, placeholderImage: UIImage(named: "defaultMovie.jpg"))
        name.text = movie.name
        genre.text = movie.genre
        actors.text = movie.actors
        directors.text = movie.director
        movieDesc.text = movie.description
        
        if (currentUser.isAdmin) {
            createEditButtonOnNavigationBar()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CommentCell")
        
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
        let collectionRef = db.collection(Constants.Firestore.moviesCollection).document(movie.id).collection("comments")
        
        collectionRef.addSnapshotListener { (querySnapshot, err) in
            var data: [String: Any] = [:]
            self.comments = []
            if let comments = querySnapshot?.documents {
                for comment in comments {
                    data = comment.data()
                    data.updateValue(comment.documentID, forKey: "documentId")
                    self.comments.append(Comment(json: data))
                }
                
                self.commentsArr.sort(by: { lhs, rhs in
                    return (lhs["createdAt"] as! Timestamp).dateValue() > (rhs["createdAt"] as! Timestamp).dateValue()
                })
                
                self.tableView?.reloadData()
            }
            
        }
    }
    
    
    @IBAction func commentBtnPressed(_ sender: Any) {
        let movieCommentsRef = Firestore.firestore().collection(Constants.Firestore.moviesCollection).document(movie.id).collection("comments").document()
                
        
        let movieComment = ["comment": self.commentText.text!, "createdAt": Date(), "userId": currentUser.userUid] as [String : Any]
        
        movieCommentsRef.setData(movieComment as [String : Any]) { (err) in
            if err != nil {
                self.showAlert(alertText: "Can't save comment.")
            } else {
                self.commentText.text = "Comment..."
                self.commentText.textColor = UIColor.lightGray
                self.commentText.resignFirstResponder()
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
        destinationVC.movie = movie
        destinationVC.isAddMovie = false
        destinationVC.movieImage = movieImage
    }
 }
 
 extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
            as! CommentTableViewCell
        let cellIndex = indexPath.row
        
        cell.commentText.text = comments[cellIndex].comment
        let createdAt = comments[cellIndex].createdAt
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: createdAt.dateValue())

        cell.createdAt.text = strDate
        cell.createdAt.textAlignment = .right
        
        db.collection(Constants.Firestore.usersCollection).whereField("user_uid", isEqualTo: comments[cellIndex].userId).getDocuments(){ (querySnapshot, err) in
        
            let user = querySnapshot!.documents.first?.data()
            
            if((user) != nil) {
                cell.username.text = (user?["first_name"] as! String) + " " + (user?["last_name"] as! String)
            } else {
                cell.username.text = "Unknown"
            }


        }


        return cell
    }

}

