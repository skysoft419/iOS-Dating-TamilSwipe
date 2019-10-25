//
//  ImageCollectionViewCell.swift
//  Ello.ie
//
//  Created by Rana Asad on 02/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import UICircularProgressRing
class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var progressbar: UICircularProgressRing!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var circleView: UIView!
    var editButtonTapAction : (()->())?
    var editImagetapAction : (()->())?
    func setUpViews(){
        
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editImageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func editButtonTapped() {
        editButtonTapAction?()
    }
    @objc func editImageViewTapped(){
        editImagetapAction?()
    }
}
