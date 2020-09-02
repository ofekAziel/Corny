//
//  EditMovieViewController.swift
//  Corny
//
//  Created by ofek aziel on 20/01/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class EditMovieViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var movieNameTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var actorsTextField: UITextField!
    @IBOutlet weak var directorTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var isAddMovie = false
    var movieImage: StorageReference!
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        createSaveButtonOnNavigationBar()
        
        if isAddMovie {
            setUpElementsForAdding()
        } else {
            setUpElementsForEditing()
        }
    }
    
    func setUpElements() {
        Utilities.styleTextField(movieNameTextField)
        Utilities.styleTextField(genreTextField)
        Utilities.styleTextField(actorsTextField)
        Utilities.styleTextField(directorTextField)
        Utilities.styleTextView(descriptionTextView)
    }
    
    func setUpElementsForAdding() {
        deleteButton.isHidden = true
    }
    
    func setUpElementsForEditing() {
        Utilities.styleFilledButton(deleteButton)
        self.navigationItem.title = "Edit Movie"
        movieImageView.sd_setImage(with: movieImage, placeholderImage: UIImage(named: "defaultMovie.jpg"))
        movieNameTextField.text = movie.name
        genreTextField.text = movie.genre
        actorsTextField.text = movie.actors
        directorTextField.text = movie.director
        descriptionTextView.text = movie.description
    }
    
    func createSaveButtonOnNavigationBar() {
        let saveMoviewButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveMovie))
        self.navigationItem.rightBarButtonItem = saveMoviewButton
    }
    
    @objc func saveMovie() {
        if validateFields() != nil {
            showAlert(alertText: "Can't save movie please fill in all fields.")
        } else {
            FirebaseStorage.uploadPhotoAndMovieToFirestore(
                view: self.view, movieImage: movieImageView.image, movie: movie, isAddMovie: isAddMovie,
                name: movieNameTextField.text!, genre: genreTextField.text!, actors: actorsTextField.text!,
                director: directorTextField.text!, description: descriptionTextView.text!, editMovieViewController: self)
        }
    }
    
    @IBAction func deleteMovie(_ sender: UIButton) {
        CommentDB.deleteMovieCommentsFromDb(movieId: movie.id, databse: DBHelper.instance.db)
        MovieDB.deleteMovieFromDb(movieId: movie.id, databse: DBHelper.instance.db)
        MovieFirebase.deleteMovie(editMovieViewController: self, view: self.view, movie: movie, movieImage: movieImage)
    }
        
    func showAlert(alertText:String) {
        let alert = UIAlertController(title: "Error", message: alertText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateFields() -> String? {
        if isTextFieldsEmpty() {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    func isTextFieldsEmpty() -> Bool {
        return movieNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            genreTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            actorsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            directorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
    
    @IBAction func imagePickerTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                self.showAlert(alertText: "Camera not available.")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        movieImageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
