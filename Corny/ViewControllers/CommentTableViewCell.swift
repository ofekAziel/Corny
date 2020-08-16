//
//  CommentTableViewCell.swift
//  Corny
//
//  Created by Samuel on 12/08/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var commentText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
