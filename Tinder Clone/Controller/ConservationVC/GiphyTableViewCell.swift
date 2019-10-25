//
//  GiphyTableViewCell.swift
//  Igniter
//
//  Created by PingLi on 7/3/19.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import GiphyUISDK

class GiphyTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
        @IBOutlet weak var receivingTimeLabel: UILabel!
    
    @IBOutlet weak var myGifContainerView: UIView!
    @IBOutlet weak var otherGifContainerView: UIView!
    @IBOutlet weak var myGifView: YYAnimatedImageView!
    @IBOutlet weak var otherGifView: YYAnimatedImageView!
    @IBOutlet weak var myGifWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var myGifHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var otherGifWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var otherGifHeightConstraint: NSLayoutConstraint!
    
    //    internal var aspectConstraint : NSLayoutConstraint? {
//        didSet {
//            if oldValue != nil {
//                myGifView.removeConstraint(oldValue!)
//            }
//            if aspectConstraint != nil {
//                myGifView.addConstraint(aspectConstraint!)
//            }
//        }
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        aspectConstraint = nil
//    }
//    
//    func setCustomImage(image : UIImage) {
//        
//        let aspect = image.size.width / image.size.height
//        
//        let constraint = NSLayoutConstraint(item: myGifView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: myGifView, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
//        constraint.priority = UILayoutPriority(rawValue: 999)
//        
//        aspectConstraint = constraint
//        
//        myGifView.image = image
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        myGifContainerView.backgroundColor = UIColor.clear
        myGifView.isUserInteractionEnabled = false
        myGifView.contentMode = .scaleAspectFit
        myGifView.layer.cornerRadius = 16
        myGifView.layer.masksToBounds = true
        myGifView.backgroundColor = UIColor.clear
        
        otherGifContainerView.backgroundColor = UIColor.clear
        otherGifView.isUserInteractionEnabled = false
        otherGifView.contentMode = .scaleAspectFit
        otherGifView.layer.cornerRadius = 16
        otherGifView.layer.masksToBounds = true
        otherGifView.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
