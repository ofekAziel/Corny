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
        var cornyStoryboard: UIStoryboard!
        cornyStoryboard = UIStoryboard(name: Constants.Storyboard.cornyStroyBoard, bundle: nil)
        let cornyEditMovieViewController = cornyStoryboard.instantiateViewController(identifier: Constants.Storyboard.cornyEditMovieViewController)
        
        self.present(cornyEditMovieViewController, animated: true, completion: nil)
//        view.window?.rootViewController = cornyNavigationController
//        view.window?.makeKeyAndVisible()
    }
}
