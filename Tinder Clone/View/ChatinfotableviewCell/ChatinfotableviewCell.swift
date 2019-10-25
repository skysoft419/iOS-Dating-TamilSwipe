//
//  ChatinfotableviewCell.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit

class ChatinfotableviewCell: UITableViewCell {
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var superlike_img: UIImageView!
    
    @IBOutlet weak var reply_image: UIImageView!

    @IBOutlet weak var online_view: UIView!
    @IBOutlet weak var message_Lbl: UILabel!
    @IBOutlet weak var user_name_Lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        user_image.layer.cornerRadius = user_image.frame.size.width/2
        user_image.clipsToBounds = true
        online_view.layer.cornerRadius = online_view.frame.size.width/2
        online_view.clipsToBounds = true
        online_view.layer.borderWidth = 2.0
        online_view.layer.borderColor = UIColor.white.cgColor
        online_view.layer.backgroundColor = Themes.sharedIntance.ReturnThemeColor().cgColor
        reply_image.isHidden = true
        message_Lbl.frame.origin.x = user_name_Lbl.frame.origin.x
        let user_image_frame = user_image.frame
        let online_view_frame = online_view.frame
        online_view.frame = CGRect(x: user_image_frame.origin.x + (user_image_frame.width - (online_view_frame.width / 2)), y: (user_image_frame.origin.y)  + ((user_image_frame.height / 2) - (online_view_frame.height / 2)), width: online_view_frame.width, height: online_view_frame.height)
         // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
