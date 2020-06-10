//
//  MovieCollectionViewCell.swift
//  Corny
//
//  Created by Samuel on 26/02/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
