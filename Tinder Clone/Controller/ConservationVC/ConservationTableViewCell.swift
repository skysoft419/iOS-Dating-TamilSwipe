//
//  ConservationTableViewCell.swift
//  Igniter
//
//  Created by Rana Asad on 15/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
class ConservationTableViewCell: UITableViewCell {
    @IBOutlet weak var recivingView: GradientView!
    @IBOutlet weak var recivingLabel: CopyableLabel!
    @IBOutlet weak var senderView: GradientView!
    @IBOutlet weak var senderLabel: CopyableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   

}
