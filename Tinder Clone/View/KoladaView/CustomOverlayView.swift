//
//  CustomOverlayView.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import AudioToolbox
import UIView_Shake

class CustomOverlayView: YSLCardView {
    @IBOutlet weak var superLike_Btn: UIButton!
    
    @IBOutlet weak var secondHand: UIButton!
    @IBOutlet weak var firstHand: UIButton!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var collection: SliderCollectionView!
    @IBOutlet weak var reportedButton: UIButton!
    @IBOutlet weak var locImageButton: UIButton!
    @IBOutlet weak var nope_Btn: UIButton!
    @IBOutlet weak var like_Btn: UIButton!
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var info_Btn: UIButton!
    @IBOutlet weak var wrapper_View: UIView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var like_View: UIView!
    @IBOutlet weak var nope_View: UIView!
    @IBOutlet weak var superLike_View: UIView!
    var counter = 0
    var timer : Timer?
    
    private var spb:SegmentedProgressBar?
    var i:Int=0
    var images:Array<String>?
    let shadow = UIColor.black.withAlphaComponent(0.6).cgColor
    override func awakeFromNib() {
       
        Themes.sharedIntance.AddBorder(view: superLike_Btn, borderColor: superLike_Btn.titleLabel?.textColor, borderWidth: 5.0, cornerradius: 5.0)
         Themes.sharedIntance.AddBorder(view: like_Btn, borderColor: like_Btn.titleLabel?.textColor, borderWidth: 5.0, cornerradius: 5.0)
        Themes.sharedIntance.AddBorder(view: nope_Btn, borderColor: nope_Btn.titleLabel?.textColor, borderWidth: 5.0, cornerradius: 5.0)
         Themes.sharedIntance.AddBorder(view: reportedButton, borderColor: reportedButton.titleLabel?.textColor, borderWidth: 5.0, cornerradius: 5.0)
//        nope_Btn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 3)
//         like_Btn.transform = CGAffineTransform(rotationAngle: 10)
//        superLike_Btn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
       nope_Btn.alpha = 0
       like_Btn.alpha = 0
     superLike_Btn.alpha = 0
        reportedButton.alpha=0
        reportedButton.contentEdgeInsets=UIEdgeInsetsMake(15,15,15,15)
        superLike_Btn.titleLabel!.lineBreakMode = .byWordWrapping
        superLike_Btn.titleLabel!.textAlignment = .center
        reportedButton.titleLabel!.lineBreakMode = .byWordWrapping
        reportedButton.titleLabel!.textAlignment = .center
         superLike_Btn.setTitle("FAVOURITE", for: .normal)
        like_Btn.setTitle("KEEP", for: .normal)
        nope_Btn.setTitle("PASS", for: .normal)
        
        
         like_View.transform = CGAffineTransform(rotationAngle: -(10 * .pi / 150) )
         nope_View.transform = CGAffineTransform(rotationAngle: 10 * .pi / 150)
        reportedButton.transform = CGAffineTransform(rotationAngle: -(10 * .pi / 150) )
//        like_Btn.transform = CGAffineTransform(rotationAngle: 10 * .pi / 180)
         superLike_View.transform = CGAffineTransform(rotationAngle: -(10 * .pi / 150))
        like_View.frame.origin.y = nope_View.frame.origin.y + (like_View.frame.height / 1.4 )
        self.bringSubview(toFront: superLike_View)
        self.bringSubview(toFront: like_View)
        self.bringSubview(toFront: nope_View)
        self.bringSubview(toFront: reportedButton)
        self.bringSubview(toFront: wrapper_View)

        self.collection.frame=CGRect(x:0,y:0,width:self.frame.size.width,height:self.frame.size.height)
        self.collection.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderColor = UIColor.clear.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
       self.addGestureRecognizer(tap)
        
     }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if (images?.count)! > 1{
        if StaticData.isFirstSignUp==false{
            let alphaColor=#colorLiteral(red: 0.6817812324, green: 0.6817975044, blue: 0.6817887425, alpha: 1)
            firstView.backgroundColor=alphaColor.withAlphaComponent(0.9)
            secondView.backgroundColor=alphaColor.withAlphaComponent(0.9)
            self.firstView.isHidden=false
            self.secondView.isHidden=false
            self.wrapper_View.isHidden=true
            self.spb?.isHidden=true
            StaticData.isFirstSignUp=false
            ConfigManager.getInstance().setFirstTap(value: "NO")
        }else{
            self.wrapper_View.isHidden=false
            self.spb?.isHidden=false
            self.firstView.isHidden=true
            self.secondView.isHidden=true
        let loc=sender?.location(in: self)
        if loc!.x < collection.frame.size.width/2{
            if i != 0{
                i=i-1
                collection.scrollToItem(at:  IndexPath(item: i, section: 0), at: .centeredHorizontally, animated: true)
                spb!.rewind()
                let medium = UIImpactFeedbackGenerator(style: .light)
                medium.prepare()
                medium.impactOccurred()
            }else{
                let medium = UIImpactFeedbackGenerator(style: .light)
                medium.prepare()
                medium.impactOccurred()
                self.shake()
                medium.impactOccurred()
            }
        }else{
            let j=i
            if i < images!.count-1 {
            i=i+1
            collection.scrollToItem(at:  IndexPath(item: i, section: 0), at: .centeredHorizontally, animated: true)
            spb!.skip()
                let medium = UIImpactFeedbackGenerator(style: .light)
                medium.prepare()
                medium.impactOccurred()
            }else{
                let medium = UIImpactFeedbackGenerator(style: .light)
                medium.prepare()
                medium.impactOccurred()
                self.shake()
                medium.impactOccurred()
            }
        }
        }
        }else{
            let medium = UIImpactFeedbackGenerator(style: .light)
            medium.prepare()
            medium.impactOccurred()
            self.shake()
            medium.impactOccurred()
        }
    }
   
    func initialiseCollectionView()
    {
        let h=collection
        let imageArr:Array = images!
        let HeaderSliderArray:NSMutableArray = NSMutableArray()
        for i in 0..<imageArr.count
        {
            
            //            if(!imagename.contains("http"))
            //            {
            //                imagename =
            //            }
            let objRecord:SliderRecord=SliderRecord(imageName:imageArr[i], LogoimageName: "", DetailText: "I meant to swipe right",subtext:"")
            HeaderSliderArray.add(objRecord)
            
            
        }
        collection.Header_Data_Source = NSMutableArray(array: HeaderSliderArray)
        collection.Slidercat = .story
        collection.Paging_Enabled=true
        collection.isScrollEnabled=false
        collection.ReloadSlider()
        if imageArr.count > 1{
        spb = SegmentedProgressBar(numberOfSegments: imageArr.count, duration: 5)
        spb!.frame = CGRect(x: 15, y: 15, width: self.frame.width - 30, height: 4)
        self.addSubview(spb!)
        spb!.startAnimation()
        }
    }
   
}
