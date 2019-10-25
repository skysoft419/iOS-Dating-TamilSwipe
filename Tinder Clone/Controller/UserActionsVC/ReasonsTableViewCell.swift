//
//  ReasonsTableViewCell.swift
//  Ello.ie
//
//  Created by Rana Asad on 04/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit

class ReasonsTableViewCell: UITableViewCell {
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var iconButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
