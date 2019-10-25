//
//  ConservationViewController.swift
//  Igniter
//
//  Created by Rana Asad on 15/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import AFMActionSheet
import PopupDialog
import GiphyUISDK
import GiphyCoreSDK
extension UITextView{
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
}
extension UIBarButtonItem {
    
    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        return menuBarItem
    }
}

extension UIView {
    enum Corner:Int {
        case bottomRight = 0,
        topRight,
        bottomLeft,
        topLeft
    }
    
    private func parseCorner(corner: Corner) -> CACornerMask.Element {
        let corners: [CACornerMask.Element] = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        return corners[corner.rawValue]
    }
    
    private func createMask(corners: [Corner]) -> UInt {
        return corners.reduce(0, { (a, b) -> UInt in
            return a + parseCorner(corner: b).rawValue
        })
    }
    
    func roundCorners(corners: [Corner], amount: CGFloat = 5) {
        layer.cornerRadius = amount
        let maskedCorners: CACornerMask = CACornerMask(rawValue: createMask(corners: corners))
        layer.maskedCorners = maskedCorners
    }
}
extension Date {
    
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = format
        
        return formatter.string(from: yourDate!)
    }
}
extension UILabel{
    
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}
extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
}

extension UIColor {
    func toColor(_ color: UIColor, percentage: CGFloat) -> UIColor {
        let percentage = max(min(percentage, 100), 0)
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return self }
            guard color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return self }
            
            return UIColor(red: CGFloat(r1 + (r2 - r1) * percentage),
                           green: CGFloat(g1 + (g2 - g1) * percentage),
                           blue: CGFloat(b1 + (b2 - b1) * percentage),
                           alpha: CGFloat(a1 + (a2 - a1) * percentage))
        }
    }
}

class ConservationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextViewDelegate,UIScrollViewDelegate,CallBack{
    func clicked() {
        self.reportUser()
    }
    /*
     ******
     Must define bottom bar height here so that Table view insets must arrange according to that
     ******
     */
    private var bottomBarHeight:CGFloat=60
    let gifWidth : CGFloat = 300
    let emojiWidth : CGFloat = 60
    var initialTextViewHeight : CGFloat!
    var initialViewHeight : CGFloat!
    var textViewMargin : CGFloat!
    
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var placeholderlabel: UILabel!
    @IBOutlet weak var tabelview: UITableView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    private var frame:CGRect?
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var textingLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var textviewHeight: NSLayoutConstraint!
    @IBOutlet weak var tappedImageVIew: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    private var hightArray:Array<CGFloat>=[]
    @IBOutlet weak var textview: UITextView!
    private var isFirst:Bool=true
    private var messagesList:Array<Messages>=[]
    private var keyboardHeight:CGFloat?
    private var myCustomCells:[ConservationTableViewCell] = []
    private var topColors:Array<UIColor>=[#colorLiteral(red: 1, green: 0.8784313202, blue: 0.6980392337, alpha: 1),#colorLiteral(red: 1, green: 0.8000000119, blue: 0.5019607544, alpha: 1),#colorLiteral(red: 1, green: 0.7176471353, blue: 0.3019607365, alpha: 1),#colorLiteral(red: 1, green: 0.6549019814, blue: 0.1490195394, alpha: 1),#colorLiteral(red: 0.984313786, green: 0.5490196347, blue: 0, alpha: 1),#colorLiteral(red: 0.9607843757, green: 0.4862744808, blue: 0, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.4235293865, blue: 0, alpha: 1)]
    private var bottomColors:Array<UIColor>=[#colorLiteral(red: 0.9999999404, green: 0.8039215207, blue: 0.8235294223, alpha: 1),#colorLiteral(red: 0.9372548461, green: 0.6039215922, blue: 0.6039215922, alpha: 1),#colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1),#colorLiteral(red: 0.8980392814, green: 0.2235293388, blue: 0.2078430951, alpha: 1),#colorLiteral(red: 0.8274510503, green: 0.1843136251, blue: 0.1843136847, alpha: 1),#colorLiteral(red: 0.7764706016, green: 0.1568626761, blue: 0.1568627059, alpha: 1)]
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    private var gl = CAGradientLayer()
    var userRecord:matchProfileRecord = matchProfileRecord()
    @IBOutlet weak var textviewView: UIView!
    private var isHide=true
    private var newHeight:CGFloat?
    var match:Bool=false
    var index:Int = -1
    @objc func appCameToForeground() {
        //bottom.constant=0
        //self.view.endEditing(true)
    }
    @objc func foreGround(){
        let bottomcon=bottom.constant
        print(bottomcon)
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        //   bottom.constant=0
        // self.view.endEditing(true)
    }
    public func setObject(){
        DispatchQueue.main.async {
            //            if UIDevice.modelName == "iPhone X" || UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "Simulator iPhone XR" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "Simulator iPhone XS" || UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "Simulator iPhone XS Max"{
            ////                self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0, 55+self.bottomBarHeight, 0.0)
            //                self.tabelview.contentInset = UIEdgeInsetsMake(50.0, 0.0, 0.0, 0.0)
            //            }else{
            ////                self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 55+self.bottomBarHeight, 0.0)
            //                self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            //            }
            
            self.frame=self.toolbarView.frame
            self.userImageView.layer.cornerRadius=15
            self.userImageView.clipsToBounds=true
            
            self.userImageView.sd_setImage(with: URL(string:self.userRecord.user_image_url), placeholderImage: #imageLiteral(resourceName: "displayavatar"))
            self.userNameLabel.text=self.userRecord.user_name
            self.userImageView.isUserInteractionEnabled=true
            
            self.userNameLabel.isUserInteractionEnabled=true
            self.getMessages()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        StaticData.isFromChat=true
        let record=userRecord
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        //       if UIDevice.modelName == "iPhone X" || UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "Simulator iPhone XR" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "Simulator iPhone XS" || UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "Simulator iPhone XS Max"{
        ////            self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0, 55+bottomBarHeight, 0.0)
        //            self.tabelview.contentInset = UIEdgeInsetsMake(50.0, 0.0, 0.0, 0.0)
        //        }else{
        ////            self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 55+bottomBarHeight, 0.0)
        //            self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        //        }
        self.frame=self.toolbarView.frame
        self.userImageView.layer.cornerRadius=self.userImageView.frame.size.height/2
        self.userImageView.clipsToBounds=true
        self.userImageView.layer.masksToBounds=true
        //self.userImageView.layer.borderWidth=1.0
        self.userImageView.contentMode = .scaleAspectFill
        let url=self.userRecord.user_image_url
        self.userImageView.sd_setImage(with: URL(string:self.userRecord.user_image_url), placeholderImage: #imageLiteral(resourceName: "gold_like"),completed: { (image, error, cache, url) in
            let size=image?.size
            if error != nil {
                self.userImageView.image = #imageLiteral(resourceName: "gold_like")
            }
        })
        self.userNameLabel.text=self.userRecord.user_name
        self.userImageView.isUserInteractionEnabled=true
        
        self.userNameLabel.isUserInteractionEnabled=true
        //view.addGestureRecognizer(tap)
        let viewGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDetailProfile))
        viewGesture.numberOfTapsRequired=1
        userImageView.addGestureRecognizer(viewGesture)
        userNameLabel.addGestureRecognizer(viewGesture)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        notificationCenter.addObserver(self, selector: #selector(foreGround), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        gl.startPoint = CGPoint(x: 0.0, y: 0.5)
        gl.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.tabelview.dataSource=self
        self.tabelview.delegate=self
        textview.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textview.layer.cornerRadius=textview.bounds.height/2;
        textview.layer.borderColor=#colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        textview.layer.borderWidth=0.5
        tabelview.rowHeight=UITableViewAutomaticDimension
        sendButton.tintColor = #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1)
        textview.textColor=#colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1)
        initThings()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeColorScheme), name: Notification.Name("ColorSchemeChanged"), object: nil)
        
        initialViewHeight = viewHeight.constant
        initialTextViewHeight = textviewHeight.constant
        print(textviewHeight)
        textViewMargin = initialViewHeight - initialTextViewHeight
        textview.sizeToFit()
        
        //        self.tabelview.estimatedRowHeight = 50
        //        self.tabelview.rowHeight = UITableViewAutomaticDimension
        
        //self.tableViewScrollToBottom()
        // Do any additional setup after loading the view.
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = Themes.sharedIntance.getChatGradientTopColor()
        
        if StaticData.hashmap[userRecord.user_id] != nil{
            let value=StaticData.hashmap[userRecord.user_id]
            if (value?.count)! > 0{
                placeholderlabel.isHidden=true
                textview.text=value!
                sendButton.tintColor = Themes.sharedIntance.getChatGradientBottomColor()
                let height=textview.frame.height
                let oldHeight = textview.frame.size.height
                let maxHeight: CGFloat = 150.0 //beyond this value the textView will scroll
                var newHeight = min(textview.sizeThatFits(CGSize(width: textview.frame.width, height: CGFloat.greatestFiniteMagnitude)).height, maxHeight)
                newHeight = max(newHeight, initialTextViewHeight)
                textview.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                newHeight = ceil(newHeight)
                if newHeight > 140{
                    self.textview.isScrollEnabled=true
                }else{
                    self.textview.isScrollEnabled=false
                }
                if newHeight != oldHeight {
                    UIView.animate(withDuration: 0.2, animations: {
                        //                    if UIDevice.modelName == "iPhone X" || UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "Simulator iPhone XR" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "Simulator iPhone XS" || UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "Simulator iPhone XS Max"{
                        ////                        self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0, newHeight+self.bottomBarHeight+25, 0.0)
                        //                            self.tabelview.contentInset = UIEdgeInsetsMake(50.0, 0.0, 0, 0.0)
                        //                        }else{
                        ////                        self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, newHeight+self.bottomBarHeight+25, 0.0)
                        //                            self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)
                        //                        }
                        
                        self.newHeight=newHeight+20
                        self.textviewHeight.constant=newHeight
                        self.viewHeight.constant = self.textviewHeight.constant + self.textViewMargin
                        self.view.invalidateIntrinsicContentSize()
                        self.view.layoutIfNeeded()
                    
                        self.moveToBottom()
                    }, completion: { (finished: Bool) in

                    })
                }
            }
        }
    }
    
    @IBAction func detailsClixked(_ sender: UIButton) {
        onDetailProfile()
        print("asad")
    }
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            isHide=false
            bottom.constant=0
            keyboardHeight = keyboardSize.height
            print(keyboardHeight)
            if #available(iOS 11.0, *) {
                bottom.constant -= self.keyboardHeight! - self.view.safeAreaInsets.bottom
            } else {
                bottom.constant -= self.keyboardHeight!
            }
            
            self.view.layoutIfNeeded()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                UIView.animate(withDuration: notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval, animations: {
                    //                    if #available(iOS 11.0, *) {
                    //                        if self.newHeight != nil{
                    //                            if UIDevice.modelName == "iPhone X" || UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "Simulator iPhone XR" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "Simulator iPhone XS" || UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "Simulator iPhone XS Max"{
                    ////                                self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0, self.keyboardHeight!+self.bottomBarHeight+self.newHeight!-self.view.safeAreaInsets.bottom, 0.0)
                    //                                self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0, 0, 0.0)
                    //                            }else{
                    ////                                self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0, self.keyboardHeight!+self.bottomBarHeight+self.newHeight!-self.view.safeAreaInsets.bottom, 0.0)
                    //                                self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0, 0, 0.0)
                    //                            }
                    //
                    //                        }else{
                    //                            if UIDevice.modelName == "iPhone X" || UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "Simulator iPhone XR" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "Simulator iPhone XS" || UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "Simulator iPhone XS Max"{
                    ////                                self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0, self.keyboardHeight!+self.bottomBarHeight+55-self.view.safeAreaInsets.bottom, 0.0)
                    //                                self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0, 0.0, 0.0)
                    //                            }else{
                    ////                                self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.keyboardHeight!+self.bottomBarHeight+55-self.view.safeAreaInsets.bottom, 0.0)
                    //                                self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
                    //                            }
                    //                        }
                    //
                    //                    }else{
                    //                        if self.newHeight != nil{
                    ////                            self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.keyboardHeight!+self.bottomBarHeight+self.newHeight!, 0.0)
                    //                            self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)
                    //
                    //                        }else{
                    ////                            self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.keyboardHeight!+self.bottomBarHeight+55, 0.0)
                    //                            self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
                    //                        }
                    //                    }
                    
                    self.moveToBottom()
                })
            }
    
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            isHide=true
            keyboardHeight = keyboardSize.height
            bottom.constant=0
            if #available(iOS 11.0, *) {
                bottom.constant=0
            }else{
                bottom.constant=0
            }
            
            //            UIView.animate(withDuration: notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval, animations: {
            //                if self.newHeight != nil{
            //                    if #available(iOS 11.0, *) {
            //                        if UIDevice.modelName == "iPhone X" || UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "Simulator iPhone XR" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "Simulator iPhone XS" || UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "Simulator iPhone XS Max"{
            ////                            self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0, self.newHeight!+self.view.safeAreaInsets.bottom, 0.0)
            //                            self.tabelview.contentInset = UIEdgeInsetsMake(50.0, 0.0, 0, 0.0)
            //
            //                        }else{
            ////                            self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.newHeight!+self.bottomBarHeight+self.view.safeAreaInsets.bottom, 0.0)
            //                            self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)
            //                        }
            //
            //                    }else{
            ////                        self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.newHeight!+self.bottomBarHeight, 0.0)
            //                        self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)
            //                    }
            //                    //self.newHeight=nil
            //                }else{
            //                    if #available(iOS 11.0, *) {
            //                         if UIDevice.modelName == "iPhone X" || UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "Simulator iPhone XR" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "Simulator iPhone XS" || UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "Simulator iPhone XS Max"{
            ////                            self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0, 55+self.view.safeAreaInsets.bottom+self.bottomBarHeight, 0.0)
            //                            self.tabelview.contentInset = UIEdgeInsetsMake(50.0, 0.0, 0.0, 0.0)
            //                        }else{
            ////                            self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 55+self.view.safeAreaInsets.bottom+self.bottomBarHeight, 0.0)
            //                            self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            //                        }
            //
            //                    }else{
            ////                        self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 55+self.bottomBarHeight, 0.0)
            //                        self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            //                    }
            //                }
            //                //self.moveToBottom()
            //                //self.bottom.constant -= self.keyboardHeight!
            //
            //            })
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if !textview.text.isEmpty{
            StaticData.text=textview.text!
            StaticData.hashmap[userRecord.user_id]=textview.text!
        }
        textview.text=""
        self.viewHeight.constant = initialViewHeight
        self.newHeight=nil
        self.textviewHeight.constant = initialTextViewHeight
        ////        self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0,55+bottomBarHeight, 0.0)
        //        self.tabelview.contentInset = UIEdgeInsetsMake(50.0, 0.0, 0.0, 0.0)
        
    }
    
    func setUpMenuButton(){
        
        let menuBtn = UIButton(type: .system)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named:"report_falg"), for: .normal)
        menuBtn.tintColor=#colorLiteral(red: 0.7411764264, green: 0.7411764264, blue: 0.7411764264, alpha: 1)
        menuBtn.target(forAction: #selector(ConservationViewController.reportUser), withSender: self)
        menuBtn.addTarget(self, action: #selector(reportUser), for: UIControlEvents.touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        
        // let right=UIBarButtonItem(image: UIImage(named: "report_falg"),
        //       style: .plain,
        //    target: self,
        //   action: #selector(reportUser))
        //right.tintColor=#colorLiteral(red: 0.7411764264, green: 0.7411764264, blue: 0.7411764264, alpha: 1)
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    @objc func reportUser(){
        self.navigationController?.isNavigationBarHidden = false
        let vc=AppStoryboard.Extra.viewController(viewControllerClass: ReportTableViewController.self)
        vc.user_id=self.userRecord.user_id
        vc.user_image=self.userRecord.user_image_url
        vc.fromConversation=true
        self.view.endEditing(true)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func addTitleView(){
        
        let view=UIView(frame:CGRect(x:0,y:0,width:UIScreen.main.bounds.width-80,height:50))
        let navController=navigationController!
        let bannerWidth=navController.navigationBar.frame.size.width
        let bannerHeight=navController.navigationBar.frame.size.height
        //
        let bannerX=bannerWidth/2-(40/2)
        let bannerY=bannerHeight/2-(40/2)
        //
        let imageview=UIImageView(frame:CGRect(x:0,y:1,width:30,height:30))
        imageview.frame.origin.x=view.bounds.midX-imageview.bounds.midX
        let label=UILabel(frame:CGRect(x:0,y:23,width:view.bounds.width,height:30))
        label.textAlignment = .center
        label.frame.origin.x=view.bounds.midX-label.bounds.midX
        label.textColor=#colorLiteral(red: 0.5294117647, green: 0.5294117647, blue: 0.5294117647, alpha: 1)
        label.font=UIFont(name: "Helvetica Neue", size: 13)
        label.text=userRecord.user_name
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds=true
        imageview.layer.masksToBounds=true
        imageview.layer.cornerRadius=imageview.frame.size.width/2
        imageview.sd_setImage(with: URL(string:userRecord.user_image_url), placeholderImage: #imageLiteral(resourceName: "displayavatar"))
        view.addSubview(imageview)
        view.addSubview(label)
        let viewGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDetailProfile))
        view.addGestureRecognizer(viewGesture)
        self.navigationItem.titleView=view
    }
    
    @objc func onDetailProfile(){
        self.moveToDetail()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.length == 0{
            placeholderlabel.isHidden=false
            sendButton.tintColor = #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1)
        }else if textView.text.length == 1{
            placeholderlabel.isHidden=true
            sendButton.tintColor = Themes.sharedIntance.getChatGradientBottomColor()
        }
        if textView.text.length == 1{
            //typingMessage()
        }else{
            
        }
        let height=textView.frame.height
        let oldHeight = textView.frame.size.height
        let maxHeight: CGFloat = 150.0 //beyond this value the textView will scroll
        var newHeight = min(textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height, maxHeight)
        newHeight = max(newHeight, initialTextViewHeight)
        newHeight = ceil(newHeight)
        if newHeight > 140{
            self.textview.isScrollEnabled=true
        }else{
            self.textview.isScrollEnabled=false
        }
        if newHeight != oldHeight && newHeight < 140 {
            UIView.animate(withDuration: 0.2, animations: {
                self.textviewHeight.constant = newHeight
                self.viewHeight.constant = self.textviewHeight.constant + self.textViewMargin
                self.newHeight=newHeight+20
                //                if #available(iOS 11.0, *) {
                //                     if UIDevice.modelName == "iPhone X" || UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "Simulator iPhone XR" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "Simulator iPhone XS" || UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "Simulator iPhone XS Max"{
                ////                        self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0, self.keyboardHeight!+newHeight+self.bottomBarHeight+20-self.view.safeAreaInsets.bottom, 0.0)
                ////                        self.tabelview.contentInset = UIEdgeInsetsMake(50.0, 0.0, 0.0, 0.0)
                //                    }else{
                ////                        self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.keyboardHeight!+newHeight+self.bottomBarHeight+20-self.view.safeAreaInsets.bottom, 0.0)
                ////                        self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
                //                    }
                //                }else{
                ////                    self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.keyboardHeight!+newHeight+self.bottomBarHeight+20, 0.0)
                ////                    self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
                //                }
                
                self.view.invalidateIntrinsicContentSize()
                self.view.layoutIfNeeded()
                
                self.moveToBottom()
                
            }, completion: { (finished: Bool) in
                
            })
        }
        
        
    }
    //This method is for scrolling the table view to bottom
    func scrollToBottom()  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let point = CGPoint(x: 0 , y: self.tabelview.contentSize.height + self.tabelview.contentInset.bottom  - self.tabelview.frame.height)
            if point.y >= 0{
                self.tabelview.setContentOffset(point, animated: true)
            }
        }
        
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("return")
        return true
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textview.text.isEmpty{
            //textView.textContainerInset = UIEdgeInsetsMake(-0.1,0,0,0)
            self.view.invalidateIntrinsicContentSize()
            textview.text=""
            textview.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            placeholderlabel.isHidden=true
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textview.text.isEmpty{
            placeholderlabel.isHidden=false
        }else{
            placeholderlabel.isHidden=true
            textview.text=""
            textview.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func getGifImageCell(indexPath:IndexPath, date:Date?, isMine:Bool, isSameTime:Bool)->GiphyTableViewCell{
        if let cell = self.tabelview.dequeueReusableCell(withIdentifier: "GiphyTableViewCell", for: indexPath) as? GiphyTableViewCell{
            
            let message = messagesList[indexPath.row]
            let url = message.gifUrl!
            
            if(isMine){
                if(!isSameTime){
                    cell.timeLabel.isHidden=false
                    if let dt = date{
                        cell.timeLabel.text=dt.toString(withFormat: "HH:mm")
                    }
                    cell.timeLabel.sizeToFit()
                    
                }else{
                    cell.timeLabel.isHidden = true
                }
                
                cell.receivingTimeLabel.isHidden = true
                cell.otherGifView.isHidden = true
                
                cell.myGifView.isHidden = false
                if(message.isEmoji == "yes"){
                    cell.myGifWidthConstraint.constant = emojiWidth
                    cell.myGifHeightConstraint.constant = emojiWidth
                }else{
                    cell.myGifWidthConstraint.constant = gifWidth
                    cell.myGifHeightConstraint.constant = gifWidth * message.gifRatio
                }
                
                cell.myGifView.image = YYImage(named: "growing_ring")
                cell.myGifView.tag = indexPath.row
                GPHCache.shared.downloadAsset(url) { (img, error) in
                    if let image = img {
                        print(image.size)
                        if(cell.myGifView.tag == indexPath.row){
                            cell.myGifView.image = image
                        }
                    }
                }
                
                
            }else{
                if(!isSameTime){
                    cell.receivingTimeLabel.isHidden=false
                    if let dt = date {
                        cell.receivingTimeLabel.text=dt.toString(withFormat: "HH:mm")
                    }
                    cell.receivingTimeLabel.sizeToFit()
                }else{
                    cell.receivingTimeLabel.isHidden = true
                }
                
                cell.timeLabel.isHidden = true
                cell.myGifView.isHidden = true
                
                cell.otherGifView.isHidden = false
                if(message.isEmoji == "yes"){
                    cell.otherGifWidthConstraint.constant = emojiWidth
                    cell.otherGifHeightConstraint.constant = emojiWidth
                }else{
                    cell.otherGifWidthConstraint.constant = gifWidth
                    cell.otherGifHeightConstraint.constant = gifWidth * message.gifRatio
                }
                
                cell.otherGifView.image =  YYImage(named: "growing_ring")
                cell.otherGifView.tag = indexPath.row
                GPHCache.shared.downloadAsset(url) { (img, error) in
                    if let image = img {
                        print(image.size)
                        if(cell.otherGifView.tag == indexPath.row){
                            cell.otherGifView.image = image
                        }
                    }
                }
            }
            return cell
            
        }else{
            return GiphyTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messagesList.count > 0{
            let dates = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let currentDate=formatter.string(from: dates)
            let message=self.messagesList[indexPath.row]
            
            if message.text != "Typing..."{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                let date = dateFormatter.date(from: message.date!)
                /*
                 This is the for the sender user. Rana Asad name is set for sender user so that we can know this is sender.
                 */
                let row=indexPath.row
                if message.senderDisplayName == "Rana Asad"{
                    if indexPath.row != 0{
                        let message0=self.messagesList[indexPath.row-1]
                        //Inner date is the date of previous message and date is the date of current message
                        let innerDate=dateFormatter.date(from: message0.date!)
                        //If the previous message time is equal to the time of message which is after it then no need to show time on the current message.
                        if message0.senderDisplayName == "Rana Asad"{
                            if innerDate?.toString(withFormat: "HH:mm") == date?.toString(withFormat: "HH:mm"){
                                if let url:String = message.gifUrl, !url.isEmpty{
                                    return getGifImageCell(indexPath: indexPath, date: date, isMine: true, isSameTime: true)
                                    
                                }else{
                                    let cell = tableView.dequeueReusableCell(withIdentifier: "ConservationTableViewCell", for: indexPath) as! ConservationTableViewCell
                                    cell.recivingView.isHidden=true
                                    cell.senderView.isHidden=false
                                    
                                    cell.senderLabel.text=message.text!
                                    cell.senderLabel.sizeToFit()
                                    cell.recivingLabel.sizeToFit()
                                    
                                    return cell
                                }
                            }else{
                                //If the previous message time is not equal to the time of message which is after it then  need to show time on the current message.
                                
                                
                                if let url:String = message.gifUrl, !url.isEmpty{
                                    return getGifImageCell(indexPath: indexPath, date: date, isMine: true, isSameTime: false)
                                    
                                }else{
                                    let cell = tableView.dequeueReusableCell(withIdentifier: "ConservationSecondTableViewCell", for: indexPath) as! ConservationSecondTableViewCell
                                    cell.receivingView.isHidden=true
                                    cell.senderView.isHidden=false
                                    cell.receivingTimeLabel.isHidden=true
                                    cell.timeLabel.isHidden=false
                                    cell.senderLabel.text=message.text!
                                    cell.timeLabel.text=date?.toString(withFormat: "HH:mm")
                                    cell.senderLabel.sizeToFit()
                                    cell.receivingLabel.sizeToFit()
                                    cell.timeLabel.sizeToFit()
                                    
                                    //You can see the label e.g Today or 24-01-2019 etc this thing s handled here we want show that label when current message date is equal to previous message date then it is understood no need to show Label on the current bubble.
                                    if innerDate?.toString(withFormat: "yyyy-MM-dd") == date?.toString(withFormat: "yyyy-MM-dd"){
                                        cell.todayLabel.isHidden=true
                                        
                                        
                                    }else{
                                        if currentDate == date?.toString(withFormat: "yyyy-MM-dd"){
                                            cell.todayLabel.isHidden=false
                                            cell.todayLabel.text="Today"
                                            
                                        }else{
                                            cell.todayLabel.isHidden=false
                                            cell.todayLabel.text=date?.toString(withFormat: "MM-dd-yyyy")
                                            
                                        }
                                    }
                                    return cell
                                }
                            }
                            
                        }else{
                            
                            if let url:String = message.gifUrl, !url.isEmpty{
                                return getGifImageCell(indexPath: indexPath, date: date, isMine: true, isSameTime: false)
                                
                            }else{
                                let cell = tableView.dequeueReusableCell(withIdentifier: "ConservationSecondTableViewCell", for: indexPath) as! ConservationSecondTableViewCell
                                cell.receivingView.isHidden=true
                                cell.senderView.isHidden=false
                                cell.receivingTimeLabel.isHidden=true
                                cell.timeLabel.isHidden=false
                                cell.senderLabel.text=message.text!
                                cell.timeLabel.text=date?.toString(withFormat: "HH:mm")
                                cell.timeLabel.sizeToFit()
                                cell.senderLabel.sizeToFit()
                                cell.receivingLabel.sizeToFit()
                                
                                if innerDate?.toString(withFormat: "yyyy-MM-dd") == date?.toString(withFormat: "yyyy-MM-dd"){
                                    cell.todayLabel.isHidden=true
                                    
                                    
                                    
                                }else{
                                    if currentDate == date?.toString(withFormat: "yyyy-MM-dd"){
                                        cell.todayLabel.isHidden=false
                                        cell.todayLabel.text="Today"
                                        
                                    }else{
                                        cell.todayLabel.isHidden=false
                                        cell.todayLabel.text=date?.toString(withFormat: "MM-dd-yyyy")
                                        
                                    }
                                }
                                return cell
                                
                            }
                        }
                    }else{
                        //This is for when first message of sender will show and all if else conditions are same like the above one.
                        if let url:String = message.gifUrl, !url.isEmpty{
                            return getGifImageCell(indexPath: indexPath, date: date, isMine: true, isSameTime: false)
                            
                        }else{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "ConservationSecondTableViewCell", for: indexPath) as! ConservationSecondTableViewCell
                            cell.receivingView.isHidden=true
                            cell.senderView.isHidden=false
                            cell.senderLabel.text=message.text!
                            cell.receivingTimeLabel.isHidden=true
                            cell.timeLabel.isHidden=false
                            cell.timeLabel.text=date?.toString(withFormat: "HH:mm")
                            cell.timeLabel.sizeToFit()
                            cell.senderLabel.sizeToFit()
                            cell.receivingLabel.sizeToFit()
                            
                            
                            if currentDate == date?.toString(withFormat: "yyyy-MM-dd"){
                                cell.todayLabel.isHidden=false
                                cell.todayLabel.text="Today"
                                
                            }else{
                                cell.todayLabel.isHidden=false
                                cell.todayLabel.text=date?.toString(withFormat: "MM-dd-yyyy")
                            }
                            
                            return cell
                        }
                    }
                }else{
                    //Forget about the typing thing.All it's working is same like the sender one.But it is for reciever message bubbles.
                    if message.text != "Typing..."{
                        if indexPath.row != 0{
                            let message0=self.messagesList[indexPath.row-1]
                            let innerDate=dateFormatter.date(from: message0.date!)
                            if message0.senderDisplayName == "Other"{
                                if innerDate?.toString(withFormat: "HH:mm") == date?.toString(withFormat: "HH:mm"){
                                    if let url:String = message.gifUrl, !url.isEmpty{
                                        return getGifImageCell(indexPath: indexPath, date: date, isMine: false, isSameTime: true)
                                        
                                    }else{
                                        let cell = tableView.dequeueReusableCell(withIdentifier: "ConservationTableViewCell", for: indexPath) as! ConservationTableViewCell
                                        cell.recivingView.isHidden=false
                                        cell.senderView.isHidden=true
                                        cell.recivingLabel.text=message.text!
                                        cell.senderLabel.sizeToFit()
                                        cell.recivingLabel.sizeToFit()
                                        
                                        return cell
                                    }
                                }else{
                                    
                                    if let url:String = message.gifUrl, !url.isEmpty{
                                        return getGifImageCell(indexPath: indexPath, date: date, isMine: false, isSameTime: false)
                                        
                                    }else{
                                        let cell = tableView.dequeueReusableCell(withIdentifier: "ConservationSecondTableViewCell", for: indexPath) as! ConservationSecondTableViewCell
                                        cell.receivingView.isHidden=false
                                        cell.senderView.isHidden=true
                                        cell.receivingLabel.text=message.text!
                                        cell.receivingTimeLabel.isHidden=false
                                        cell.timeLabel.isHidden=true
                                        cell.receivingTimeLabel.text=date?.toString(withFormat: "HH:mm")
                                        cell.receivingTimeLabel.sizeToFit()
                                        cell.senderLabel.sizeToFit()
                                        cell.receivingLabel.sizeToFit()
                                        
                                        if innerDate?.toString(withFormat: "yyyy-MM-dd") == date?.toString(withFormat: "yyyy-MM-dd"){
                                            cell.todayLabel.isHidden=true
                                            
                                            
                                        }else{
                                            if currentDate == date?.toString(withFormat: "yyyy-MM-dd"){
                                                cell.todayLabel.isHidden=false
                                                cell.todayLabel.text="Today"
                                                
                                            }else{
                                                cell.todayLabel.isHidden=false
                                                cell.todayLabel.text=date?.toString(withFormat: "MM-dd-yyyy")
                                                
                                            }
                                        }
                                        return cell
                                    }
                                }
                            }else{
                                
                                if let url:String = message.gifUrl, !url.isEmpty{
                                    return getGifImageCell(indexPath: indexPath, date: date, isMine: false, isSameTime: false)
                                    
                                }else{
                                    let cell = tableView.dequeueReusableCell(withIdentifier: "ConservationSecondTableViewCell", for: indexPath) as! ConservationSecondTableViewCell
                                    cell.receivingView.isHidden=false
                                    cell.senderView.isHidden=true
                                    cell.receivingLabel.text=message.text!
                                    cell.receivingTimeLabel.isHidden=false
                                    cell.timeLabel.isHidden=true
                                    cell.receivingTimeLabel.text=date?.toString(withFormat: "HH:mm")
                                    cell.receivingTimeLabel.sizeToFit()
                                    cell.senderLabel.sizeToFit()
                                    cell.receivingLabel.sizeToFit()
                                    
                                    if innerDate?.toString(withFormat: "yyyy-MM-dd") == date?.toString(withFormat: "yyyy-MM-dd"){
                                        cell.todayLabel.isHidden=true
                                        
                                        
                                    }else{
                                        if currentDate == date?.toString(withFormat: "yyyy-MM-dd"){
                                            cell.todayLabel.isHidden=false
                                            cell.todayLabel.text="Today"
                                            
                                        }else{
                                            cell.todayLabel.isHidden=false
                                            cell.todayLabel.text=date?.toString(withFormat: "MM-dd-yyyy")
                                            
                                        }
                                    }
                                    return cell
                                    
                                }
                            }
                        }else{
                            if let url:String = message.gifUrl, !url.isEmpty{
                                return getGifImageCell(indexPath: indexPath, date: date, isMine: false, isSameTime: false)
                                
                            }else{
                                let cell = tableView.dequeueReusableCell(withIdentifier: "ConservationSecondTableViewCell", for: indexPath) as! ConservationSecondTableViewCell
                                cell.receivingView.isHidden=false
                                cell.senderView.isHidden=true
                                cell.receivingTimeLabel.isHidden=false
                                cell.timeLabel.isHidden=true
                                cell.receivingLabel.text=message.text!
                                cell.receivingTimeLabel.text=date?.toString(withFormat: "HH:mm")
                                cell.receivingTimeLabel.sizeToFit()
                                cell.senderLabel.sizeToFit()
                                cell.receivingLabel.sizeToFit()
                                
                                
                                if currentDate == date?.toString(withFormat: "yyyy-MM-dd"){
                                    cell.todayLabel.isHidden=false
                                    cell.todayLabel.text="Today"
                                }else{
                                    cell.todayLabel.isHidden=false
                                    cell.todayLabel.text=date?.toString(withFormat: "MM-dd-yyyy")
                                    
                                }
                                
                                return cell
                            }
                        }
                        //cell.recivingTime.text=date?.toString(withFormat: "yyyy-MM-dd")
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ConservationTableViewCell", for: indexPath) as! ConservationTableViewCell
                        let msg=message.text!
                        cell.senderLabel.text=""
                        cell.senderView.isHidden=true
                        cell.recivingView.isHidden=false
                        cell.recivingLabel.text=message.text!
                        cell.senderLabel.sizeToFit()
                        cell.recivingLabel.sizeToFit()
                        return cell
                        // cell.recivingTime.isHidden=true
                    }
                    
                }
                
                //myCustomCells.append(cell)
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ConservationTableViewCell", for: indexPath) as! ConservationTableViewCell
                cell.senderView.isHidden=true
                cell.recivingLabel.isHidden=false
                cell.recivingLabel.text="Typing..."
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConservationTableViewCell", for: indexPath) as! ConservationTableViewCell
            cell.senderView.isHidden=true
            cell.recivingLabel.isHidden=true
            cell.layoutIfNeeded()
            return cell
        }
        
        
    }
    /*Here we are doing the the shape of cell.
     Let me explain you the whole point.
     If the current message is sender{
     1)If the index is 0 then add three edges corner radius LEFT-TOP | LEFT-BOTTOM | RIGHT-BOTTOM
     2)If the index is not 0. Then check the date of current message and previous message if it is same then add corner radius of following LEFT-TOP | LEFT-BOTTOM | RIGHT-BOTTOM | RIGHT-TOP
     3)If the date of current message and previous message is not same the add corner radius of following LEFT-TOP | LEFT-BOTTOM | RIGHT-BOTTOM
     4) If the previous message is not by sender(we can identify it by name Rana Asad).Then add corner radius of following. LEFT-TOP | LEFT-BOTTOM | RIGHT-BOTTOM | RIGHT-TOP
     }
     Same case for reciever view
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let message=self.messagesList[indexPath.row]
            if message.text != "Typing..."{
                let row=indexPath.row
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                let date = dateFormatter.date(from: message.date!)
                if message.senderDisplayName == "Rana Asad"{
                    //cell.senderView.layer.sublayers?.first?.rem
                    if indexPath.row != 0{
                        
                        let message0=self.messagesList[row-1]
                        let innerDate=dateFormatter.date(from: message0.date!)
                        if message0.senderDisplayName=="Rana Asad"{
                            if innerDate?.toString(withFormat: "HH:mm")==date?.toString(withFormat: "HH:mm"){
                                
                                if let cells=cell as? ConservationTableViewCell{
                                    cells.senderView.layer.cornerRadius=10
                                    cells.senderView.layer.maskedCorners=[.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
                                }
                            }else{
                                if let cells=cell as? ConservationSecondTableViewCell{
                                    cells.senderView.layer.cornerRadius=10
                                    cells.senderView.layer.maskedCorners=[.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMaxYCorner]
                                }
                            }
                        }else{
                            if let cells=cell as? ConservationSecondTableViewCell{
                                cells.senderView.layer.cornerRadius=10
                                cells.senderView.layer.maskedCorners=[.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMaxYCorner]
                            }
                        }
                    }else{
                        if let cells=cell as? ConservationSecondTableViewCell{
                            cells.senderView.layer.cornerRadius=10
                            cells.senderView.layer.maskedCorners=[.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMaxYCorner]
                        }
                        
                    }
                    // cell.senderView.layer.insertSublayer(bubbleGradient, at: 0)
                    //cell.senderTime.text=date?.toString(withFormat: "yyyy-MM-dd")
                }else{
                    
                    if indexPath.row != 0{
                        let message0=self.messagesList[row-1]
                        let innerDate=dateFormatter.date(from: message0.date!)
                        if message0.senderDisplayName=="Other"{
                            if innerDate?.toString(withFormat: "HH:mm")==date?.toString(withFormat: "HH:mm"){
                                if let cells=cell as? ConservationTableViewCell{
                                    cells.recivingView.layer.cornerRadius=10
                                    cells.recivingView.layer.maskedCorners=[.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
                                }
                            }else{
                                if let cells=cell as? ConservationSecondTableViewCell{
                                    cells.receivingView.layer.cornerRadius=10
                                    cells.receivingView.layer.maskedCorners=[.layerMaxXMinYCorner,.layerMinXMinYCorner,.layerMaxXMaxYCorner]
                                }
                            }
                        }else{
                            if let cells=cell as? ConservationSecondTableViewCell{
                                cells.receivingView.layer.cornerRadius=10
                                cells.receivingView.layer.maskedCorners=[.layerMaxXMinYCorner,.layerMinXMinYCorner,.layerMaxXMaxYCorner]
                            }
                        }
                    }else{
                        if let cells=cell as? ConservationSecondTableViewCell{
                            cells.receivingView.layer.cornerRadius=10
                            cells.receivingView.layer.maskedCorners=[.layerMaxXMinYCorner,.layerMinXMinYCorner,.layerMaxXMaxYCorner]
                        }
                    }
                }
                
            }else{
                if let cells=cell as? ConservationTableViewCell{
                    cells.recivingView.layer.cornerRadius=10
                    
                    cells.recivingView.layer.maskedCorners=[.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
                }
            }
        }
        //myCustomCells.append(cell)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(indexPath.row)
        textingLabel.isHidden=true
        textingLabel.text=messagesList[indexPath.row].text!
        var maximumLabelSize: CGSize = CGSize(width: 276, height: 9999)
        var expectedLabelSize: CGSize = textingLabel.sizeThatFits(maximumLabelSize)
        print(expectedLabelSize)
        print(messagesList[indexPath.row].text!)
        let message=self.messagesList[indexPath.row]
        
        if let url:String = message.gifUrl, !url.isEmpty{
            if(message.isEmoji == "yes"){
                return emojiWidth + 32
            }else{
                return gifWidth * message.gifRatio + 32
            }
        }
        
        if message.text != "Typing..."{
            let row=indexPath.row
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let date = dateFormatter.date(from: message.date!)
            if message.senderDisplayName == "Rana Asad"{
                //cell.senderView.layer.sublayers?.first?.rem
                if indexPath.row != 0{
                    
                    let message0=self.messagesList[row-1]
                    let innerDate=dateFormatter.date(from: message0.date!)
                    if message0.senderDisplayName=="Rana Asad"{
                        if innerDate?.toString(withFormat: "HH:mm")==date?.toString(withFormat: "HH:mm"){
                            return expectedLabelSize.height+20
                        }else{
                            return expectedLabelSize.height+42
                        }
                    }else{
                        return expectedLabelSize.height+42
                    }
                }else{
                    return expectedLabelSize.height+42
                    
                }
                // cell.senderView.layer.insertSublayer(bubbleGradient, at: 0)
                //cell.senderTime.text=date?.toString(withFormat: "yyyy-MM-dd")
            }else{
                
                if indexPath.row != 0{
                    let message0=self.messagesList[row-1]
                    let innerDate=dateFormatter.date(from: message0.date!)
                    if message0.senderDisplayName=="Other"{
                        if innerDate?.toString(withFormat: "HH:mm")==date?.toString(withFormat: "HH:mm"){
                            return expectedLabelSize.height+20
                        }else{
                            return expectedLabelSize.height+42
                        }
                    }else{
                        return expectedLabelSize.height+42
                    }
                }else{
                    return expectedLabelSize.height+42
                }
            }
        }else{
            return expectedLabelSize.height+20
        }
        
        
    }
    
    @objc func changeColorScheme() {
        if textview.text.trimmingCharacters(in: .whitespacesAndNewlines).length > 0{
            sendButton.tintColor = Themes.sharedIntance.getChatGradientBottomColor()
        }
        
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = Themes.sharedIntance.getChatGradientTopColor()
        
        let image1 = UIImage(named: "report_falg")?.withRenderingMode(.alwaysTemplate)
        reportButton.setImage(image1, for: .normal)
        reportButton.tintColor = Themes.sharedIntance.getChatGradientTopColor()
        
        let tableHeight = self.tabelview.frame.height
        if let rows = self.tabelview?.indexPathsForVisibleRows {
            for indexPathForVisibleRow in rows {
                if let visibleCell : ConservationTableViewCell = self.tabelview.cellForRow(at: indexPathForVisibleRow) as? ConservationTableViewCell{
                    let startYPos = visibleCell.frame.origin.y - self.tabelview.contentOffset.y
                    let endYPos = visibleCell.frame.origin.y + visibleCell.frame.size.height - self.tabelview.contentOffset.y
                    visibleCell.senderView.topColor = Themes.sharedIntance.getChatGradientTopColor().toColor(Themes.sharedIntance.getChatGradientBottomColor(), percentage: startYPos/tableHeight)
                    visibleCell.senderView.bottomColor = Themes.sharedIntance.getChatGradientTopColor().toColor(Themes.sharedIntance.getChatGradientBottomColor(), percentage: endYPos/tableHeight)
                    visibleCell.senderView.setGradient()
                    
                } else if let visibleCell : ConservationSecondTableViewCell = self.tabelview.cellForRow(at: indexPathForVisibleRow) as? ConservationSecondTableViewCell{
                    let startYPos = visibleCell.frame.origin.y - self.tabelview.contentOffset.y
                    let endYPos = visibleCell.frame.origin.y + visibleCell.frame.size.height - self.tabelview.contentOffset.y
                    visibleCell.senderView.topColor = Themes.sharedIntance.getChatGradientTopColor().toColor(Themes.sharedIntance.getChatGradientBottomColor(), percentage: startYPos/tableHeight)
                    visibleCell.senderView.bottomColor = Themes.sharedIntance.getChatGradientTopColor().toColor(Themes.sharedIntance.getChatGradientBottomColor(), percentage: endYPos/tableHeight)
                    visibleCell.senderView.setGradient()
                }
            }
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeColorScheme()
    }
    
    func moveToDetail()
    {
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"user_id":userRecord.user_id]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.other_profile_view as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
            if responseDict != nil{
                if((responseDict?.count)! > 0)
                {
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                    
                    if(status_code == "1")
                    {
                        let objRecord:otherUserRecord = otherUserRecord()
                        objRecord.college = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "college") as AnyObject)
                        objRecord.age = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "age") as AnyObject)
                        objRecord.images =  responseDict?.object(forKey: "images") as! [String]
                        objRecord.job_title = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "job_title") as AnyObject)
                        objRecord.kilometer = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "kilometer") as AnyObject)
                        objRecord.name = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "name") as AnyObject)
                        objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "user_id") as AnyObject)
                        objRecord.work = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "work") as AnyObject)
                        objRecord.distanceType = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "distance_type") as AnyObject)
                        let profVC = AppStoryboard.Main.viewController(viewControllerClass: User_DetailViewController.self) as! User_DetailViewController
                        profVC.callback=self
                        profVC.objRecord = objRecord
                        profVC.isfromuserDetail = true
                        if self.textview.text != nil{
                            StaticData.text=self.textview.text!
                        }
                        self.textview.text=""
                        self.viewHeight.constant=49
                        self.newHeight=nil
                        self.textviewHeight.constant=29
                        //                    self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0,55+self.bottomBarHeight, 0.0)
                        self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)
                        self.view.endEditing(true)
                        //                    profVC.delegate = self
                        self.navigationController?.present(profVC, animated: true, completion: nil)
                    }
                    else
                    {
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                    }
                }
                else
                {
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                }
            }else{
                let err=error as? NSError
                if err?.code == 401{
                    let alert = UIAlertController(title: "", message: "Please check you internet connection and try again!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler:{action in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        
    }
    
    @IBAction func onColorButtonClicked(_ sender: UIButton) {
        let overlayAppearance = PopupDialogOverlayView.appearance()
        
        overlayAppearance.color           = .black
        overlayAppearance.blurEnabled     = false
        overlayAppearance.opacity         = 0.7
        overlayAppearance.layer.cornerRadius = 20
        
        // Create a custom view controller
        let colorPanelVC = ColorSchemeViewController(nibName: "ColorSchemeViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: colorPanelVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceUp,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        
        // Present dialog
        present(popup, animated: true, completion: nil)
        
    }
    
    @IBAction func onGiphyButtonClicked(_ sender: UIButton) {
        let giphy = GiphyViewController()
//        giphy.mediaTypeConfig = [.gifs, .stickers, .text, .emoji]
        giphy.mediaTypeConfig = [.gifs]
        giphy.layout = .carousel
        giphy.showConfirmationScreen = true
        giphy.delegate = self
        giphy.shouldLocalizeSearch = true
        giphy.modalPresentationStyle = .overCurrentContext
        present(giphy, animated: true, completion: nil)
    }
    
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        let text=textview.text
        sendButton.tintColor = #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1)
        textview.text=""
        placeholderlabel.isHidden=false
        self.viewHeight.constant = self.initialViewHeight
        //            self.newHeight = 49
        self.textviewHeight.constant = self.initialTextViewHeight
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2, animations: {
            //            if self.isHide == false{
            //                 if UIDevice.modelName == "iPhone X" || UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "Simulator iPhone XR" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "Simulator iPhone XS" || UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "Simulator iPhone XS Max"{
            ////                    self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0,self.keyboardHeight!+self.bottomBarHeight+49, 0.0)
            //                    self.tabelview.contentInset = UIEdgeInsetsMake(50.0, 0.0, 0.0, 0.0)
            //                }else{
            ////                    self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0,self.keyboardHeight!+self.bottomBarHeight+49, 0.0)
            //                    self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            //                }
            //            }else{
            //                 if UIDevice.modelName == "iPhone X" || UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "Simulator iPhone XR" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "Simulator iPhone XS" || UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "Simulator iPhone XS Max"{
            ////                    self.tabelview.contentInset = UIEdgeInsetsMake(50, 0.0,49+self.bottomBarHeight, 0.0)
            //                    self.tabelview.contentInset = UIEdgeInsetsMake(50.0, 0.0, 0.0, 0.0)
            //                }else{
            ////                    self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0,49+self.bottomBarHeight, 0.0)
            //                    self.tabelview.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            //                }
            //            }
            
        
        
        }, completion: { (finished: Bool) in
            self.moveToBottom()
        })
    
        if !(text!.isEmpty){
            sendMessage(text: text!, gifId: "", gifUrl: "", gifRatio: 0, isEmoji: "no")
        }
    }
    // ObjC methods
    @objc func messageReceived(msgDict: Notification) {
        
        let msgDict = convertToDictionary(text: ((msgDict.object! as! [String:Any])["custom"] as! String))!
        print(msgDict)
        let dict=msgDict["chat_status"] as? [String:Any]
        if dict != nil{
            if String(describing:(msgDict["chat_status"] as! [String:Any])["sender_id"] as! Int)  == userRecord.user_id{
                var receivedDateString:String?
                if ((msgDict["chat_status"] as! [String:Any])["message"] as! String) != "Typing..."{
                    receivedDateString = ((msgDict["chat_status"] as! [String:Any])["received_date_time"] as! [String:Any])["date"] as! String
                    let receivedFormattor = DateFormatter()
                    receivedFormattor.dateFormat = "yyyy-MM-dd"
                    let receivedDate = receivedFormattor.date(from: receivedDateString!)
                }
                
                
                let messages=Messages()
                messages.senderId="707-8956784-57"
                messages.senderDisplayName="Other"
                
                if receivedDateString != nil{
                    messages.date=receivedDateString!
                }
                let trimmedString = ((msgDict["chat_status"] as! [String:Any])["message"] as! String).trimmingCharacters(in: .whitespaces)
                messages.text=trimmedString
                let previousMessage=messagesList.last
                if previousMessage?.text == "Typing..."{
                    self.messagesList.removeLast()
                    let lastSectionIndex = self.tabelview.numberOfSections - 1
                    
                    // Then grab the number of rows in the last section
                    let lastRowIndex = self.tabelview.numberOfRows(inSection: lastSectionIndex) - 1
                    
                    // Now just construct the index path
                    let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
                    self.tabelview.beginUpdates()
                    self.tabelview.deleteRows(at: [pathToLastRow], with: .automatic)
                    self.tabelview.endUpdates()
                    
                }
                self.messagesList.append(messages)
                self.updateTableView()
            }
        }
        
    }
    private func moveToBottom(){
        if messagesList.count > 0{
            let indexpath=IndexPath(row:messagesList.count-1,section:0)
            self.tabelview.scrollToRow(at: indexpath, at: .bottom, animated: true)
        }
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // User Defined methods
    func getMessages()
    {
        //        self.chatModel.dataSource = [Any]()
        //        self.chatTableView.isHidden = true
        //        self.IFView.isHidden = true
        //        self.nomsg_view.isHidden = true
        self.messagesList.removeAll()
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"match_id":userRecord.users_like_id]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.message_conversation as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
            if responseDict != nil{
                
                if((responseDict?.count)! > 0)
                {
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                    if(status_code == "1")
                    {
                        print(responseDict)
                        if (responseDict!["messages"]! as? [[String:Any]]) == nil {
                            
                            
                            return
                        }
                        
                        
                        let messageArray = responseDict!["messages"]! as! [[String:Any]]
                        print(messageArray)
                        if messageArray.count > 0 {
                            
                            for message in messageArray {
                                
                                let dateDict = message["received_date_time"] as! [String:Any]
                                let receivedDateString = dateDict["date"] as! String
                                let receivedFormattor = DateFormatter()
                                receivedFormattor.dateFormat = "yyyy-MM-dd"
                                let receivedDate = receivedFormattor.date(from: receivedDateString)
                                if "\(String(describing: message["sender_id"]!))" == Themes.sharedIntance.getuserID()! {
                                    let messages=Messages()
                                    messages.senderId=Themes.sharedIntance.getuserID()
                                    messages.senderDisplayName="Rana Asad"
                                    messages.date=receivedDateString
                                    let text=message["message"] as! String
                                    let trimmedString = text.trimmingCharacters(in: .whitespaces)
                                    messages.text=trimmedString
                                    if let url = message["gif_image_url"]{
                                        messages.gifUrl = url as? String
                                    }
                                    messages.gifRatio = message["gif_ratio"] as! CGFloat
                                    messages.isEmoji = message["is_emoji"] as? String
                                    
                                    if messages.text != "Typing..."{
                                        self.messagesList.append(messages)
                                    }
                                    
                                    
                                    
                                }
                                else {
                                    let messages=Messages()
                                    messages.senderId="707-8956784-57"
                                    messages.senderDisplayName="Other"
                                    messages.date=receivedDateString
                                    let text=message["message"] as! String
                                    let trimmedString = text.trimmingCharacters(in: .whitespaces)
                                    messages.text=trimmedString
                                    if let url = message["gif_image_url"]{
                                        messages.gifUrl = url as? String
                                    }
                                    messages.gifRatio = message["gif_ratio"] as! CGFloat
                                    messages.isEmoji = message["is_emoji"] as? String
                                    if messages.text != "Typing..."{
                                        self.messagesList.append(messages)
                                    }
                                    
                                }
                                
                            }
                            DispatchQueue.main.async {
                                self.tabelview.reloadData()
                                self.changeColorScheme()
                                UIView.setAnimationsEnabled(false)
                                self.tabelview.beginUpdates()
                                self.tabelview.endUpdates()
                                UIView.setAnimationsEnabled(true)
                                if self.messagesList.count > 0{
                                    let indexpath=IndexPath(row:self.messagesList.count-1,section:0)
                                    self.tabelview.scrollToRow(at: indexpath, at: .bottom, animated: false)
                                }
                                
                            }
                            
                        }
                        else
                        {
                            
                            return
                            
                        }
                    }
                    else
                    {
                        //                    self.nomsg_view.isHidden = false
                        //                    self.chatTableView.isHidden = true
                        //Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                        
                    }
                }
                else
                {
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                }
            }else{
                let err=error as? NSError
                if err?.code == 401{
                    let alert = UIAlertController(title: "", message: "Please check you internet and try again!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler:{action in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        
    }
    private func updateTableView(){
        self.tabelview.beginUpdates()
        self.tabelview.insertRows(at: [IndexPath.init(row: self.messagesList.count-1, section: 0)], with: .automatic)
        self.tabelview.endUpdates()
        if self.isHide == false{
            self.scrollToBottom()
        }else{
            self.moveToBottom()
        }
        
        self.changeColorScheme()
    }
    
    private func typingMessage(){
        let date=Date()
        let receivedFormattor = DateFormatter()
        receivedFormattor.dateFormat = "yyyy-MM-dd"
        let dateString=date.toString(withFormat: "yyyy-MM-dd HH:mm:ss.SSSSSS")
        let messages=Messages()
        messages.senderId=Themes.sharedIntance.getuserID()
        messages.senderDisplayName="Rana Asad"
        messages.text="Typing..."
        messages.date=dateString
        let text="Typing..."
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"sender_id":Themes.sharedIntance.getuserID()!,"message":text,"match_id":userRecord.users_like_id]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.send_message as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
            if((ResponseDict?.count)! > 0)
            {
                let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                if(status_code == "1")
                {
                }
                else
                {
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                    
                }
            }
            else
            {
                Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
            }
        })
    }
    private func sendMessage(text:String, gifId: String, gifUrl:String, gifRatio:CGFloat, isEmoji:String){
        StaticData.hashmap[userRecord.user_id]=""
        let date=Date()
        let receivedFormattor = DateFormatter()
        receivedFormattor.dateFormat = "yyyy-MM-dd"
        let dateString=date.toString(withFormat: "yyyy-MM-dd HH:mm:ss.SSSSSS")
        let messages=Messages()
        messages.senderId=Themes.sharedIntance.getuserID()
        messages.senderDisplayName="Rana Asad"
        messages.text=text
        messages.gifUrl = gifUrl
        messages.date=dateString
        messages.gifRatio = gifRatio
        messages.isEmoji = isEmoji
        self.messagesList.append(messages)
        if(gifUrl.isEmpty){
            updateTableView()
        }
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"sender_id":Themes.sharedIntance.getuserID()!,"message":text, "gif_id":gifId, "gif_image_url":gifUrl, "gif_ratio":"\(gifRatio)", "is_emoji":isEmoji, "match_id":userRecord.users_like_id]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.send_message as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
            if((ResponseDict?.count)! > 0)
            {
                let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                if(status_code == "1")
                {
                    if(!gifUrl.isEmpty){
                        self.updateTableView()
                    }
                }
                else
                {
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                    
                }
            }
            else
            {
                Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
            }
        })
    }
    func initThings(){
        tabelview.separatorColor=UIColor.clear
        textview.isScrollEnabled=false
        textview.translatesAutoresizingMaskIntoConstraints=false
        textview.sizeToFit()
        textview.textColor = UIColor.lightGray
        //        textview.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        textview.delegate=self
        textview.textContainer.lineBreakMode = .byWordWrapping
        textview.textContainerInset = UIEdgeInsetsMake(6, 4, 4, 40)
        
        //let padding = textview.textContainer.lineFragmentPadding
        self.tabelview.setContentOffset(CGPoint.zero, animated: true)
        //textview.centerVertically()
        NotificationCenter.default.addObserver(self, selector: #selector(self.messageReceived(msgDict:)), name:Notification.Name("MessageReceived"), object: nil)
        getMessages()
    }
    
    @IBAction func reportClicked(_ sender: UIButton) {
        self.reportUser()
    }
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ConservationViewController: GiphyDelegate {
    func didSelectMedia(_ media: GPHMedia) {
        // your user tapped a GIF!
        dismiss(animated: true, completion: { [weak self] in
            let gifURL = media.url(rendition: .fixedWidth, fileType: .gif)
            let isEmoji = media.isEmoji ? "yes" : "no"
            let mediaId = media.id
            if let url = gifURL{
                let ratio = media.aspectRatio == 0 ? 0 : 1/media.aspectRatio
                self?.sendMessage(text: "gif", gifId: mediaId, gifUrl: url, gifRatio: ratio, isEmoji: isEmoji)
            }
        })
        //        GPHCache.shared.clear(.memoryOnly)
    }
    func didDismiss(controller: GiphyViewController?) {
        // your user dismissed the controller without selecting a GIF.
        //        GPHCache.shared.clear(.memoryOnly)
    }
}

