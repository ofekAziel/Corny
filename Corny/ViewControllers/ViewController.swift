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

    var playerLooper: NSObject?
    
    var playerLayer:AVPlayerLayer!
    
    var queuePlayer: AVQueuePlayer?
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements() {
        Utilities.styleHollowButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
    }
    
    func setUpVideo() {
        let bundlePath = Bundle.main.path(forResource: "intro", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        let playerItem = AVPlayerItem(url: url as URL)
        self.queuePlayer = AVQueuePlayer(items: [playerItem])
        self.playerLooper = AVPlayerLooper(player: self.queuePlayer!, templateItem: playerItem)
        self.playerLayer = AVPlayerLayer(player: self.queuePlayer)
        ajustVideoSize()
        view.layer.insertSublayer(playerLayer!, at: 0)
        self.queuePlayer?.play()
    }
    
    func ajustVideoSize() {
        playerLayer?.frame = CGRect(x:
            -self.view.frame.size.width * 1.5, y: 0, width:
            self.view.frame.size.width * 4, height:
            self.view.frame.size.height)
    }
}

