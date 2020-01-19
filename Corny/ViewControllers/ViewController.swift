//
//  ViewController.swift
//  Corny
//
//  Created by ofek aziel on 15/01/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    var videoPlayer: AVPlayer?
    
    var videoPlayerLayer: AVPlayerLayer?
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
    }
    
    func setUpVideo() {
        let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        let item = AVPlayerItem(url: url)
        videoPlayer = AVPlayer(playerItem: item)
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        videoPlayerLayer?.frame = CGRect(x:
            -self.view.frame.size.width * 1.5, y: 0, width:
            self.view.frame.size.width * 4, height:
            self.view.frame.size.height)
          
          view.layer.insertSublayer(videoPlayerLayer!, at: 0)
          videoPlayer?.playImmediately(atRate: 0.3)
    }
}

