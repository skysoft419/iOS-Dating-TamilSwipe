//
//  ChatTableViewCell.swift
//  Igniter
//
//  Created by Rana Asad on 16/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import SwipeCellKit
class ChatTableViewCell:SwipeTableViewCell  {

    @IBOutlet weak var unreadButton: UIButton!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var superLikeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
