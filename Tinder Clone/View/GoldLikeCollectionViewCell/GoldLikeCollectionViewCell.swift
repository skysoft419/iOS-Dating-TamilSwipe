//
//  GoldLikeCollectionViewCell.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
class GoldLikeCollectionViewCell: UICollectionViewCell {
    var container:YSLDraggableCardContainer = YSLDraggableCardContainer()

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var user_image: UIImageView!
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
         SetLayout()

    }
    
    func SetLayout()
    {
        
         container.frame = CGRect(x:self.cardView.frame.origin.x, y: self.cardView.frame.origin.y, width: self.cardView.frame.size.width, height: self.cardView.frame.size.height);
        container.backgroundColor = UIColor.clear
        container.dataSource = self;
        container.delegate = self;
        container.canDraggableDirection = YSLDraggableDirection.left.union( YSLDraggableDirection.right).union( YSLDraggableDirection.up)
        self.cardView.addSubview(container)
    }
    
    func ReloadContainer()
    {
        
         self.container.reload()
    }

}

extension GoldLikeCollectionViewCell:YSLDraggableCardContainerDelegate,YSLDraggableCardContainerDataSource
{
    //Mark :- YSL Datasource
    
    func cardContainerViewNextView(with index: Int) -> UIView {
        let view = UINib(nibName: "CustomOverlayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomOverlayView
        

        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width * 0.482, height: UIScreen.main.bounds.size.height * 0.49)
        view.info_Btn.tag = index
//        view.info_Btn.addTarget(self, action: #selector(MovetoDetail(sender:)), for: .touchUpInside)
//        let userRecord:UserRecord = Datasource[index] as! UserRecord
//        view.name.text = "\(userRecord.name), \(userRecord.age)"
        view.user_image.sd_setImage(with: URL(string:""), placeholderImage: #imageLiteral(resourceName: "friendly+face"))
        return view
    }
    
    func SwipeAction(Status: String) {
       
    }
    
    func cardContainerViewNumberOfView(in index: Int) -> Int {
        return 1
    }
   
    
    func cardContainerView(_ cardContainerView: YSLDraggableCardContainer, didEndDraggingAt index: Int, draggableView: UIView, draggableDirection: YSLDraggableDirection) {
        
        if draggableDirection == YSLDraggableDirection.left
        {
            cardContainerView.movePosition(with: draggableDirection, draggableView: draggableView, isAutomatic: false)
        }
        if draggableDirection == YSLDraggableDirection.right {
            cardContainerView.movePosition(with: draggableDirection, draggableView: draggableView, isAutomatic: false)
            
        }
        if draggableDirection == YSLDraggableDirection.up {
            cardContainerView.movePosition(with: draggableDirection, draggableView: draggableView, isAutomatic: false)
            
        }
    }
    
  
 
    func cardContainderView(_ cardContainderView: YSLDraggableCardContainer, updatePositionWithDraggableView draggableView: UIView, draggableDirection: YSLDraggableDirection, widthRatio: CGFloat, heightRatio: CGFloat) {
        let view_: CustomOverlayView? = draggableView as? CustomOverlayView
        if draggableDirection.rawValue == 0 {
            view_?.nope_Btn.alpha = 0
            view_?.like_Btn.alpha = 0
            view_?.superLike_Btn.alpha = 0
        }
        if draggableDirection == YSLDraggableDirection.left {
            view_?.nope_Btn.alpha = widthRatio > 0.8 ? 0.8 : widthRatio
            view_?.like_Btn.alpha = 0
            view_?.superLike_Btn.alpha = 0
        }
        if draggableDirection == YSLDraggableDirection.right {
            view_?.like_Btn.alpha = widthRatio > 0.8 ? 0.8 : widthRatio
            view_?.nope_Btn.alpha = 0
            view_?.superLike_Btn.alpha = 0
            
        }
        if draggableDirection == YSLDraggableDirection.up {
            view_?.superLike_Btn.alpha = heightRatio > 0.8 ? 0.8 : heightRatio
            view_?.nope_Btn.alpha = 0
            view_?.like_Btn.alpha = 0
            
        }
    }
    @IBAction func DidclickSwipeUp(_ sender: Any) {
    }
    
    func cardContainerViewDidCompleteAll(_ container: YSLDraggableCardContainer) {
       
        
        
    }
    func cardContainerView(_ cardContainerView: YSLDraggableCardContainer, didSelectAt index: Int, draggableView: UIView) {
    }
}
