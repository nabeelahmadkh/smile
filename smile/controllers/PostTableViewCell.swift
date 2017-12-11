//
//  PostTableViewCell.swift
//
//
//  Created by Nabeel Ahmad Khan on 11/18/17.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellDescription: UITextView!
    @IBOutlet weak var likeButton: UIImageView!
    var buttonLiked = false
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("awake from nib called ")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
