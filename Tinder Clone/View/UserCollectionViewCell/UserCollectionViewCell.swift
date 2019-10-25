//
//  UserCollectionViewCell.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var user_Img: UIImageView!
    
    @IBOutlet weak var super_like_Img: UIImageView!
    @IBOutlet weak var unread_Img: UIImageView!
    @IBOutlet weak var like_Lbl: UILabel!
    override func awakeFromNib() {
        
    }
    
}
