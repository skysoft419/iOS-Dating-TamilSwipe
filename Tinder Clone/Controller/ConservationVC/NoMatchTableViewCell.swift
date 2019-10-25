//
//  NoMatchTableViewCell.swift
//  Igniter
//
//  Created by Rana Asad on 01/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit

class NoMatchTableViewCell: UITableViewCell {

    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var noImageView: UIImageView!
    @IBOutlet weak var wavingLabel: UILabel!
    @IBOutlet weak var wavinhImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
