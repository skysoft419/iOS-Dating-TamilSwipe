//
//  ConservationSecondTableViewCell.swift
//  Igniter
//
//  Created by Rana Asad on 29/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit

class ConservationSecondTableViewCell: UITableViewCell {
    @IBOutlet weak var senderView: GradientView!
    @IBOutlet weak var senderLabel: CopyableLabel!
    @IBOutlet weak var receivingView: GradientView!
    @IBOutlet weak var receivingLabel: CopyableLabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var receivingTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
