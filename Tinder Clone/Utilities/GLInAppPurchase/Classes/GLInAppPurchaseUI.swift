//
//  GLInAppPurchaseUI.swift
//  GLInAppPurchaseUI
//
//  Created by VividMacmini7 on 18/11/16.
//  Copyright © 2016 vivid. All rights reserved.
//

import UIKit
import pop
 /**
 UI Theme types.
 - DefaultStyle
 - DarkStyle
 - LightStyle
 - LightStyleWithShadow
 - TransparentStyle
 - TransparentShadowStyle
 */
@objc public enum BackGroundStyle:Int {
    ///DefaultStyle: Default style does not add ant effect to UI, Simply adds the InAppPurchase Banner.
    case defaultStyle = 0
    ///DarkStyle: It Presents the banner over a Black background with opacity of 0.90.
    case darkStyle
    ///LightStyle: It Presents the banner over a White background with opacity of 0.90.
    case lightStyle
    ///LightStyleWithShadow: The banner will be presented with shadow and white Back ground.
    case lightStyleWithShadow
    ///TransparentStyle: Will have a transparent back ground with opacity of 0.5.
    case transparentStyle
}
var selectionindex:Int = 0
/// Default Banner Theme Color
var bannerTheme = [UIColor(netHex:0x702EBE), UIColor(netHex:0xB635F5)]
/// Default Banner Title Color
var bannerTitleColor = UIColor.white
/// Bannner Title String, This Will Be Displayed On Top As Title
var bannerTitle:String!
/// Bannner Title String, This Will Be Displayed Next To Title As SubTitle
var bannerSubTitle:String!
/// Default Button Theme Color
var buttonTheme = [UIColor(netHex:0xF90069), UIColor(netHex:0xFC6143)]
/// Default Button Title Color
var buttonTitleColor = UIColor.white
var isfromGoldSlider:Bool = Bool()

/// Image Set Which Will Be Displayed In Banner's Scroll View
var fullVersionFeatures_ImageSet = [UIImage:String]()

/// Default Purchase Button Title
var purchaseButtonName:String = "BOOST ME"
/// Default Cancel Button Title
var cancelButtonName:String = "NO, THANKS"


var bannerView:ContainerView!
/// Gives user an option to change background style, Default style is .DarkStyle
var backGroundStyle:BackGroundStyle = .darkStyle
var didSelectHandler:((_ selectedButton:String, _ isOptionSelected:Bool, _ selectedAction:GLInAppAction) -> Void)?
/// All acction's added to GLInAppPurchaseUI will be appended in this array, Helps in returning right action on did select
var actionArray = [GLInAppAction]()

let APP_DELEGATE = UIApplication.shared


/**
 A GLInAppPurchaseUI object displays an banner Title and subtitle to user along with Display Image Set,and 2 button action.
 
 Can add `GLInAppAction` different purchase options.
 
 */

@objc open class GLInAppPurchaseUI: NSObject {
    
    /**
     Creates and returns a notification bar for displaying an alert to the user.
     An initialized notificatio bar object.
     
     - Parameter title:  The title of the alert. Use this string to get the user’s attention and communicate the reason for the notification.
     
     - Parameter subTitle:   Descriptive text that provides additional details about the reason for the alert.
     
     - Parameter bannerBackGroundStyle:   The style to use when presenting the notification bar. Use this parameter to configure the banner with different style`.
     
     - Returns: A inilized GLNotificationBar object.
     */
    
    @objc public init(title:String, subTitle:String, bannerBackGroundStyle:BackGroundStyle){
        super.init()
        bannerTitle = title
        bannerSubTitle = subTitle
        backGroundStyle = bannerBackGroundStyle
    }
    
    /**
     Image content that to be displayed to user along with their description
     
     - Parameter imageSetWithDescription:  
     - Add imags as `key` and their discription as `value`.
     - The discription can be seprated by **##** , First part will be considered as **Title**, Rest as **SubTitle**
     */
    @objc open func displayContent(imageSetWithDescription images:[UIImage:String]){
        fullVersionFeatures_ImageSet = images
    }
    
    /**
     Can customize the banner using this method
     
     - Parameter color:  This array of color is used to generate **Gradient Color**,  If array contain 1 color **Plain Color** will be added.
     
     - Parameter headerTextColor:   Header label text color
     
     */
    @objc open func setBannerTheme(_ color:[UIColor], headerTextColor:UIColor,isGoldBanner:Bool){
        bannerTheme = color
        bannerTitleColor = headerTextColor
        isfromGoldSlider = isGoldBanner 
    }
    
    /**
     Can customize the **Okay Button** using this method
     
     - Parameter color:  This array of color is used to generate **Gradient Color**, If array contain 1 color **Plain Color** will be added.
     
     - Parameter headerTextColor: Used to set button title color
     
     */
    @objc open func setButtomTheme(_ color:[UIColor], buttonTextColor:UIColor){
        buttonTheme = color
        buttonTitleColor = buttonTextColor
    }
    
    /**
     `addAction` helps in adding `GLInAppAction` to banner as options to respond banner message.
     
     - Parameter action:   add's `GLInAppAction` object as action which including the title and subtitle to display in the button, and a handler to execute when the user taps the button
     
     - Returns: No return value.
     */
    @objc open func addAction(_ action: GLInAppAction){
        actionArray.append(action)    //Action for notification didselect
    }
    
    /**
     Helps in changing the **Okay and Cancel** button titles
     
     - Parameter okayTitle:  Set as title for okay button
     
     - Parameter cancelTitle:  Set as title for Cancel button
     
     - Returns: No return value.
     */
    @objc open func addButtonWith(_ okayTitle:String,cancelTitle:String,completion:@escaping ((_ selectedTitle:String, _ isOptionSelected:Bool, _ selectedAction:GLInAppAction) -> Void)){
        purchaseButtonName = okayTitle
        cancelButtonName = cancelTitle
        didSelectHandler = completion
    }
    
    /// Presents the banner on top of all views
    @objc open func presentBanner() {
        if ((APP_DELEGATE.keyWindow?.subviews) == nil) {
            let time = DispatchTime.now() + Double(Int64(5.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                self.setUpInAppPurchaseBanner()
            })
        }else{
            setUpInAppPurchaseBanner()
        }
    }
    
    /// Removes the banner from UI
    @objc open func dismissBanner() {
        didSelectHandler = nil
        actionArray = [GLInAppAction]()
        bannerTheme = [UIColor(netHex:0x702EBE), UIColor(netHex:0xB635F5)]
        bannerTitleColor = UIColor.white
        bannerTitle = String()
        bannerSubTitle = String()
        buttonTheme = [UIColor(netHex:0xF90069), UIColor(netHex:0xFC6143)]
        buttonTitleColor = UIColor.white
        fullVersionFeatures_ImageSet = [UIImage:String]()
        purchaseButtonName = "BOOST ME"
        cancelButtonName = "NO, THANKS"
        bannerView.removeFromSuperview()
        bannerView = ContainerView()
     }
    
    fileprivate func setUpInAppPurchaseBanner(){
        bannerView = ContainerView()
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        APP_DELEGATE.keyWindow?.addSubview(bannerView)
        
//        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
//        positionAnimation?.toValue = bannerView.center.y
//        positionAnimation?.springBounciness = 10
//         var scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
//        scaleAnimation?.springBounciness = 20
//        scaleAnimation?.fromValue = NSValue(cgPoint: CGPoint(x: 1.2, y: 1.4))
//        bannerView.layer.pop_add(positionAnimation, forKey: "positionAnimation")
//        bannerView.layer.pop_add(scaleAnimation, forKey: "scaleAnimation")

       var constraints = [NSLayoutConstraint]()
       let bannerHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[bannerView]|", options: [], metrics: nil, views: ["bannerView":bannerView])
        constraints += bannerHorizontalConstraint
        let bannerVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[bannerView]|", options: [], metrics: nil, views: ["bannerView":bannerView])
        constraints += bannerVerticalConstraint
         NSLayoutConstraint.activate(constraints)
    }
}

/**
 A GLInAppAction object represents an action that can be taken when tapping a button in an `GLInAppPurchaseUI`. You use this class to configure information about a single action, including the title to display in the button, and a handler to execute when the user taps the button. After creating an notificatio action object, add it to a `GLInAppPurchaseUI` object before displaying the corresponding notification to the user.
 */
open class GLInAppAction : NSObject {
    @objc open var actionTitle:String!
    @objc open var actionSubTitle:String!
    @objc open var actionPrice:String!
    
    @objc open var textResponse:String!
    var didSelectAction:((GLInAppAction) -> Void)?
    
    @objc public override init() {
        super.init()
    }
    
    
    /**
     Init a notification action and add it as action to `GLNotificationBar`.
     
     - Parameter title:   Title to be displayed in the button.
     
     - Parameter subTitle:  Subtitle will be displayed right below the title with lightgray text color.
     
     - Parameter handler:   A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
     
     - Returns: No return value.
     */
    
    @objc public init(title:String!, subTitle:String!, price:String!, handler: ((GLInAppAction) -> Void)?){
        actionTitle = title
        actionSubTitle = subTitle
        actionPrice = price
        didSelectAction = handler
    }
}



class ContainerView:UIView{
//MARK: Outlet:
    
    @IBOutlet weak var PricewrapperView: UIView!
    @IBOutlet weak var tagBtn: SpringButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var titlContainer: UIView!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    @IBOutlet weak var priceScrollView: UIScrollView!
    @IBOutlet weak var priceHeightConstraint: NSLayoutConstraint!
    
    var previousViewTag = -1
    var xPosition:CGFloat = 0.0
    
    var selctedOption:GLInAppAction!
//MARK: Init:
    ///Init banner view from nib
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setUpUIComponents()
    }
    
    ///Init banner view from nib
    required init?(coder aDecoder: NSCoder) { // for using CustomView from IB
        super.init(coder: aDecoder)
    }
    
    ///Init banner view from nib
    fileprivate func commonInit() {
        Bundle(for: ContainerView.self)
            .loadNibNamed("GLInAppPurchaseUI", owner:self, options:nil)
        guard let content = mainView else { return }
        content.frame = self.bounds
//        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(content)
        
         NotificationCenter.default.addObserver(self, selector: #selector(orientationChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    ///Setup all the UI Components
    func setUpUIComponents() {
        setUpBackGround()
        setUpButtonUI()
        setUpOtherUI()
        
        //DemoImage
        var x:CGFloat = 0.0
        var index = 0
        var width = imageScrollView.frame.size.width
        for image in fullVersionFeatures_ImageSet {
            let height = imageScrollView.frame.size.height
            
            let imageView = UIImageView(frame: CGRect(x: x,y: 0,width: width,height: height))
            imageView.contentMode = UIViewContentMode.scaleAspectFill
          
            let imagesmallView = UIImageView(frame: CGRect(x: imageView.center.x-40,y: 60,width: 80,height: 80))
            imagesmallView.contentMode = UIViewContentMode.scaleAspectFill
            imagesmallView.image = image.0
            
            if(!isfromGoldSlider)
            {
                imageView.image = #imageLiteral(resourceName: "back_gradient")
            }
            
            Themes.sharedIntance.AddBorder(view: tagBtn, borderColor: nil, borderWidth: nil, cornerradius: 10)
             Themes.sharedIntance.addshadowtoView(view: imagesmallView,radius:22.0,ShadowColor:bannerTitleColor)
            Themes.sharedIntance.AddBorder(view: imagesmallView, borderColor: nil, borderWidth: nil, cornerradius: imagesmallView.frame.size.width/2)

           
            imageScrollView.addSubview(imageView)
            imageScrollView.addSubview(imagesmallView)
            if image.1.count != 0 {
                let tempContainer = image.1.components(separatedBy: "##")
                
                let attributeDescription = NSMutableAttributedString(string: String("\(tempContainer[0])\n\(tempContainer[1])"))
                attributeDescription.addAttributes([NSAttributedStringKey.font:UIFont.imageDescriptionBig(),NSAttributedStringKey.foregroundColor:UIColor.black], range: NSRange(location: 0, length: tempContainer[0].count))
                attributeDescription.addAttributes([NSAttributedStringKey.font:UIFont.imageDescriptionSmall(),NSAttributedStringKey.foregroundColor:UIColor.lightGray], range: NSRange(location: tempContainer[0].count, length: tempContainer[1].count + 1))
                
                let description = UILabel(frame: CGRect(x: x,y: imagesmallView.frame.size.height+50,width: width,height: 70))
                description.attributedText = attributeDescription
                description.textAlignment = NSTextAlignment.center
                description.numberOfLines = 2
                imageScrollView.addSubview(description)
            }
            
            index = index + 1
            x = CGFloat(index) * width
        }
        
        Timer.scheduledTimer(timeInterval: 2.0, target:self, selector: #selector(slideShowImages(_:)), userInfo: nil, repeats: true)
        tagBtn.isHidden = true

        imagePageControl.numberOfPages = fullVersionFeatures_ImageSet.count
        imagePageControl.isHidden = fullVersionFeatures_ImageSet.count < 2 ? true : false
        imagePageControl.currentPageIndicatorTintColor = bannerTitleColor
//        imagePageControl.tintColor = [bannerTheme]
        imageScrollView.delegate = self
        imageScrollView.contentSize = CGSize(width: x, height: imageScrollView.frame.size.height)
        
        //OfferList
        x = 5.0
        index = 0
        let count = actionArray.count > 3 ? CGFloat(3) : CGFloat(actionArray.count)
        width = (priceScrollView.frame.size.width - 20) / count
        let height = priceScrollView.frame.size.height
        for offer in actionArray {
            let view = UIView(frame: CGRect(x: x,y: 0,width: width,height: height))
             view.layer.borderWidth = 0.5
            view.layer.borderColor = UIColor.gray.cgColor
            view.clipsToBounds = true
            view.tag = index
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
            view.addGestureRecognizer(tapGesture)
            
            
            var attributeOffers = NSMutableAttributedString(string: String("\(offer.actionTitle!)\n\(offer.actionSubTitle!)"))
            attributeOffers.addAttributes([NSAttributedStringKey.font:UIFont.priceListBoldFont(),NSAttributedStringKey.foregroundColor:UIColor.darkGray], range: NSRange(location: 0, length: offer.actionTitle.count))
            attributeOffers.addAttributes([NSAttributedStringKey.font:UIFont.priceListThinFont(),NSAttributedStringKey.foregroundColor:UIColor.gray], range: NSRange(location: offer.actionTitle!.count, length: offer.actionSubTitle!.count + 1))
            if(!isfromGoldSlider)
            {
                  attributeOffers = NSMutableAttributedString(string: String("\(offer.actionTitle!)\n\(offer.actionSubTitle!)"))
                attributeOffers.addAttributes([NSAttributedStringKey.font:UIFont.priceListBoldFont(),NSAttributedStringKey.foregroundColor:UIColor.white], range: NSRange(location: 0, length: offer.actionTitle.count))
                attributeOffers.addAttributes([NSAttributedStringKey.font:UIFont.priceListThinFont(),NSAttributedStringKey.foregroundColor:UIColor.white], range: NSRange(location: offer.actionTitle!.count, length: offer.actionSubTitle!.count + 1))
            }
            
            let label = UILabel(frame: CGRect(x: 3,y: 3,width: width - 6,height: height-6))
            label.attributedText = attributeOffers
            label.textAlignment = NSTextAlignment.center
            label.numberOfLines = 0
            label.backgroundColor = UIColor.white
             label.clipsToBounds = true
            view.addSubview(label)
 
            let priceLabel  = UILabel(frame: CGRect(x: 2,y: height-30,width: width - 4,height: 20))
            priceLabel.tag = 10
            priceLabel.backgroundColor = UIColor.clear
            priceLabel.font = UIFont.priceListBoldFontSmall()
            priceLabel.textColor = UIColor.darkGray
            priceLabel.text = offer.actionPrice!
            priceLabel.textAlignment = NSTextAlignment.center
            priceLabel.numberOfLines = 0
            view.addSubview(priceLabel)
            priceScrollView.addSubview(view)
            index = index + 1
            x = width + x + 5
            view.backgroundColor = UIColor.clear
        }
      
        priceScrollView.showsHorizontalScrollIndicator = false
        priceScrollView.isScrollEnabled = true
        priceScrollView.contentSize = CGSize(width: x, height: height)
        
        imageHeightConstraint.constant = fullVersionFeatures_ImageSet.count == 0 ? 0 : imageHeightConstraint.constant
        priceHeightConstraint.constant = actionArray.count == 0 ? 0 : priceHeightConstraint.constant
        self.updateConstraintsIfNeeded()
        
    }
    
    ///Set's the back ground style for banner
    func setUpBackGround() {
        switch backGroundStyle {
        case .darkStyle:
            viewContainer.layer.cornerRadius = 12.0
            viewContainer.clipsToBounds = true
            mainView.backgroundColor = UIColor.black.withAlphaComponent(0.90)
            
            break
        case .lightStyle:
            viewContainer.layer.cornerRadius = 12.0
            viewContainer.clipsToBounds = true
            viewContainer.layer.borderWidth = 1.0
            viewContainer.layer.borderColor = UIColor.lightGray.cgColor
            mainView.backgroundColor = UIColor.white.withAlphaComponent(0.90)
            
            break
        case .lightStyleWithShadow:
            viewContainer.layer.shadowColor = UIColor.black.cgColor
            viewContainer.layer.shadowOpacity = 1
            viewContainer.layer.shadowOffset = CGSize.zero
            viewContainer.layer.shadowRadius = 10
            viewContainer.layer.shadowPath = UIBezierPath(rect: viewContainer.bounds).cgPath
            mainView.backgroundColor = UIColor.white
            
            break
        case .transparentStyle:
            viewContainer.layer.cornerRadius = 12.0
            viewContainer.clipsToBounds = true
            mainView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            break
        
        default:
            viewContainer.layer.cornerRadius = 12.0
            viewContainer.clipsToBounds = true
            viewContainer.layer.borderWidth = 1.0
            viewContainer.layer.borderColor = UIColor.lightGray.cgColor
            mainView.backgroundColor = UIColor.clear
            break
        }
    }
    
    ///Sets up user UI
    func setUpOtherUI() {
        let attributeString = NSMutableAttributedString(string: String("\(bannerTitle!)\n\(bannerSubTitle!)"))
        attributeString.addAttributes([NSAttributedStringKey.font:UIFont.titleFont()], range: NSRange(location: 0, length: bannerTitle.count))
        headerLabel.attributedText = attributeString
        headerLabel.textColor = bannerTitleColor
        titlContainer.applyGradient([UIColor.clear], locations: [0,0.1], startPoint:nil, endPoint:nil)
    }
    
    ///Sets up button UI
    func setUpButtonUI(){
//        purchaseButton.layer.cornerRadius = 14.0
        purchaseButton.clipsToBounds = true
        purchaseButton.setTitle(purchaseButtonName, for: UIControlState())
        purchaseButton.setTitleColor(buttonTitleColor, for: UIControlState())
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        purchaseButton.imageView?.addMotionEffect(group)

//        purchaseButton.applyGradient(buttonTheme, locations: nil, startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        
        cancelButton.setTitle(cancelButtonName, for: UIControlState())
    }
    
    ///Button action that used to detect tap on banner options
    @IBAction func slideShowImages(_ sender:AnyObject?){
        let x = imageScrollView.frame.size.width * xPosition
        imageScrollView.scrollRectToVisible(CGRect(x: x, y: 0, width: imageScrollView.frame.size.width, height: imageScrollView.frame.size.height), animated: true)
        imagePageControl.currentPage = Int(xPosition)
        xPosition =  x > imageScrollView.contentSize.width ? 0 : xPosition + 1
    }
    
    
    @objc func tapGesture(_ sender:UITapGestureRecognizer) {
        
        let action:GLInAppAction = actionArray[(sender.view?.tag)!]
        guard let didselectHandler = action.didSelectAction else{
            return
        }
        didselectHandler(action)
        selctedOption = action
        if previousViewTag != sender.view?.tag {
            sender.view?.applyGradient(buttonTheme, locations: nil, startPoint: nil, endPoint: nil)
            
            priceScrollView.scrollRectToVisible(CGRect(x: (sender.view?.frame.origin.x)! - ((sender.view?.frame.size.width)! + 10), y: 0, width: priceScrollView.frame.size.width, height: priceScrollView.frame.size.height), animated: true)
            for subViewLabel in sender.view!.subviews {
                if subViewLabel.tag == 10 {
                    let label = subViewLabel as! UILabel
                    label.textColor = bannerTitleColor
                 }
            }
            tagBtn.setTitleColor(UIColor.white, for: .normal)
            tagBtn.frame = CGRect(x:(sender.view?.frame.origin.x)!+4 , y: PricewrapperView.frame.origin.y+30, width: (sender.view?.frame.size.width)!-8, height: tagBtn.frame.size.height)
            tagBtn.backgroundColor = bannerTitleColor
            if(sender.view?.tag == 0)
            {
                tagBtn.isHidden = false
                tagBtn.setTitle("BEST VALUE", for: .normal)
                tagBtn.animation = "zoomIn"
                tagBtn.animateFrom = false
                tagBtn.curve = "easeInOut"
                tagBtn.duration = 0.5
                tagBtn.repeatCount = 1
                tagBtn.animate()
                
            }
            else if(sender.view?.tag == 1)
            {
                tagBtn.isHidden = false
                tagBtn.setTitle("MOST POPULAR", for: .normal)
                tagBtn.animation = "zoomIn"
                tagBtn.animateFrom = false
                tagBtn.curve = "easeInOut"
                tagBtn.duration = 0.5
                tagBtn.repeatCount = 1
                tagBtn.animate()


            }
            else
            {
                tagBtn.isHidden = true

            }
            for pView in priceScrollView.subviews{
                if pView.tag == previousViewTag {
                    pView.applyGradient([UIColor.white], locations: nil, startPoint: nil, endPoint: nil)
                    for subViewLabel in pView.subviews {
                        if subViewLabel.tag == 10 {
                            let label = subViewLabel as! UILabel
                            label.textColor = UIColor.darkGray
                        }
                    }
                }
                
            }
            previousViewTag = sender.view!.tag
        }
    }
    
    @objc func orientationChange(_ sender:Notification){
        self.layoutIfNeeded()
    }
    
    //MARK: ACTION:
    @IBAction func okayButton(_ sender:UIButton) {
        let check = selctedOption != nil ? true : false
        didSelectHandler!(purchaseButtonName , check, check ? selctedOption : GLInAppAction())
    }
    
    @IBAction func cancelButton(_ sender:UIButton) {
        let check = selctedOption != nil ? true : false
        didSelectHandler!(cancelButtonName , check, check ? selctedOption : GLInAppAction())
    }
}

//MARK: Extension:
extension ContainerView:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        imagePageControl.currentPage = Int(pageNumber)
        xPosition = pageNumber
    }
}
extension UIView {
    func applyGradient(_ colours: [UIColor],locations:[NSNumber]?, startPoint:CGPoint?, endPoint:CGPoint?) -> Void {

        if (self.layer.sublayers != nil){  //Remove old layer.
            for subLayer in self.layer.sublayers! {
                if subLayer is CAGradientLayer{
                    subLayer.removeFromSuperlayer()
                }
            }
        }
        if colours.count == 1 {
            self.backgroundColor = colours[0]
            return
        }
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.removeFromSuperlayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        if ((startPoint) != nil) {
            gradient.startPoint = startPoint!
            gradient.endPoint = endPoint!
        }
        
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIFont {
    class func titleFont() -> UIFont {
        return UIFont(name: "GeezaPro-Bold", size: 17)!
    }
    
    class func priceListBoldFont() -> UIFont {
        return UIFont(name: "KohinoorDevanagari-Semibold", size: 23)!
    }
    
    class func priceListThinFont() -> UIFont {
        return UIFont(name: "KohinoorDevanagari-Regular", size: 14)!
    }
    
    class func priceListBoldFontSmall() -> UIFont {
        return UIFont(name: "KohinoorDevanagari-Semibold", size: 16)!
    }
    
    class func imageDescriptionBig() -> UIFont {
        return UIFont(name: "KohinoorDevanagari-Regular", size: 18)!
    }
    
    class func imageDescriptionSmall() -> UIFont {
        return UIFont(name: "KohinoorDevanagari-Regular", size: 16)!
    }
}
