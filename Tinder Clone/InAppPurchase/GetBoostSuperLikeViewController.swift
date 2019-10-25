//
//  GetBoostSuperLikeViewController.swift
//  Tinder Clone
//
//  Created by trioangle on 25/05/18.
//  Copyright © 2018 Anonymous. All rights reserved.
//

import UIKit
import StoreKit

enum SelectedBoost:Int {
    case tenBoost = 0, fiveBoost, oneBoost
}

protocol ShowPlusFromBoostDelegate {
    func showPlusView()
}

class GetBoostSuperLikeViewController: UIViewController {
    
    @IBOutlet var planView: UIView!
    
    @IBOutlet var plansCollectionView: UIView!
    @IBOutlet var sliderCollectionView: SliderCollectionView!
    @IBOutlet var pageControlView: FXPageControl!
    
    @IBOutlet weak var firstPlanView: UIView!
    @IBOutlet weak var secondPlanView: UIView!
    @IBOutlet weak var thirdPlanView: UIView!
    
    @IBOutlet var firstPlanHeaderLabel: UILabel!
    @IBOutlet weak var secondPlanHeaderLabel: UILabel!
    @IBOutlet weak var thirdPlanHeaderLabel: UILabel!
    @IBOutlet weak var firstPlanCountLabel: UILabel!
    @IBOutlet weak var secondPlanCountLabel: UILabel!
    @IBOutlet weak var thirdPlanCountLabel: UILabel!
    
    @IBOutlet weak var firstBoostTitleLabel: UILabel!
    @IBOutlet weak var secondBoostTitleLabel: UILabel!
    @IBOutlet weak var thirdBoostTitleLabel: UILabel!
    @IBOutlet weak var rateTitleInFirstViewLabel: UILabel!
    @IBOutlet weak var rateTitleInSecondViewLabel: UILabel!
    @IBOutlet weak var rateTitleInThirdViewLabel: UILabel!
    @IBOutlet weak var boostMeButtonOutlet: UIButton!
    @IBOutlet weak var goldPlusTitleLabel: UILabel!
    @IBOutlet weak var plansBGView: UIView!
    @IBOutlet weak var getTinderPlusView: UIView!
    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var planSubTitleLabel: UILabel!
    @IBOutlet weak var tinderPlusSubTitleLabel: UILabel!
    @IBOutlet weak var orLineView: UIView!
    @IBOutlet weak var getIgniterPlusLabel: UILabel!
    
    @IBOutlet weak var totalAmountIn10ViewLabel: UILabel!
    @IBOutlet weak var totalAmountIn5ViewLabel: UILabel!
    @IBOutlet weak var totalAmountIn1ViewLabel: UILabel!
    
    
    
    var deselectedBGColor = UIColor()
    
    
    var selectedIndexPath: IndexPath?
    
    var plansDict = [[String:Any]]()
    
    var isBoost = Bool()
    var isPurchased = Bool()
    var plusBGColorArray = [UIColor]()
    var gradientLayer: CAGradientLayer!
    var selectedView:UIView?
    
    var productList = [SKProduct]()
    var selectedProduct = String()
    
    
    
    var schemeThemeColor = UIColor()
    
    var planType = String()
    
    var selectedPlan = Int()
    
    var plusDelegate:ShowPlusFromBoostDelegate?
    
    
    
    func getProducts() {
        
        Subscribtion.store.requestProducts{success, products in
            if success {
                Themes.sharedIntance.RemoveProgress(view: self.view)
                print("Products List:")
                for p in products! {
                    print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
                    self.productList.append(p)
                }
            }
            else {
                Themes.sharedIntance.RemoveProgress(view: self.view)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: IAPHelper.IAPHelperBoostPurchaseNotification), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: IAPHelper.IAPHelperBoostPurchaseFailedNotification), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //        Subscribtion.store.restorePurchases()
//        getProducts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GetBoostSuperLikeViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperBoostPurchaseNotification),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GetBoostSuperLikeViewController.handlePurchaseFailedNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperBoostPurchaseFailedNotification),
                                               object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getIgniterPlusLabel.text = "GET \(k_Application_Name.uppercased()) PLUS"
        
//        getProducts()
        
        planView.clipsToBounds = true
        planView.layer.cornerRadius = 6.0
        
        deselectedBGColor = UIColor(red: 241.0/255.0, green: 242.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        
        plusBGColorArray = [UIColor(red: 57.0/255.0, green: 225.0/255.0, blue: 146.0/255.0, alpha: 1.0), UIColor(red: 148.0/255.0, green: 77.0/255.0, blue: 212.0/255.0, alpha: 1.0),UIColor(red: 231.0/255.0, green: 27.0/255.0, blue: 155.0/255.0, alpha: 1.0), UIColor(red: 27.0/255.0, green: 73.0/255.0, blue: 170.0/255.0, alpha: 1.0), UIColor(red: 255.0/255.0, green: 108.0/255.0, blue: 65.0/255.0, alpha: 1.0), UIColor(red: 25.0/255.0, green: 151.0/255.0, blue: 255.0/255.0, alpha: 1.0), UIColor(red: 225.0/255.0, green: 177.0/255.0, blue: 5.0/255.0, alpha: 1.0), UIColor(red: 148.0/255.0, green: 158.0/255.0, blue: 173.0/255.0, alpha: 1.0)]
        
       
        
        
        if isBoost {
            
            selectedProduct = Subscribtion.twoBoostSubscribtion
            planType = "boost"
            createGradientLayer(forView: plansBGView, withColor:UIColor(red: 137.0/255.0, green: 75.0/255.0, blue: 207.0/255.0, alpha: 1.0))
            symbolImageView.image = UIImage(named: "plusThund")
            planTitleLabel.text = "Skip the queue"
            planSubTitleLabel.text = "Be the top profile in your area for 30 minutes to get more matches"
            firstPlanCountLabel.text = "10"
            secondPlanCountLabel.text = "5"
            thirdPlanCountLabel.text = "1"
            
            firstBoostTitleLabel.text = "Boosts"
            secondBoostTitleLabel.text = "Boosts"
            thirdBoostTitleLabel.text = "Boosts"
            
            rateTitleInFirstViewLabel.text = "\(Constant.k_CurrencyCode) 194.90 each"
            rateTitleInSecondViewLabel.text = "\(Constant.k_CurrencyCode) 239.80 each"
            rateTitleInThirdViewLabel.text = "\(Constant.k_CurrencyCode) 299.00 each"
            
            boostMeButtonOutlet.setTitle("BOOST ME", for: .normal)
            tinderPlusSubTitleLabel.text = "(1 free Boost every 1 month)"
            
        }
        else {
            
            selectedProduct = Subscribtion.twoSuperLikeSubscribtion
            planType = "super_like"
            createGradientLayer(forView: plansBGView, withColor:UIColor(red: 24.0/255.0, green: 142.0/255.0, blue: 223.0/255.0, alpha: 1.0))
            symbolImageView.image = UIImage(named: "plusStar")
            planTitleLabel.text = "Stand out with super like"
            planSubTitleLabel.text = "You're 3 times more likely to get a match!"
            firstPlanCountLabel.text = "5"
            secondPlanCountLabel.text = "25"
            thirdPlanCountLabel.text = "60"
            
            firstBoostTitleLabel.text = "Super Likes"
            secondBoostTitleLabel.text = "Super Likes"
            thirdBoostTitleLabel.text = "Super Likes"
            
            rateTitleInFirstViewLabel.text = "\(Constant.k_CurrencyCode) 79.80 each"
            rateTitleInSecondViewLabel.text = "\(Constant.k_CurrencyCode) 63.96 each"
            rateTitleInThirdViewLabel.text = "\(Constant.k_CurrencyCode) 51.65 each"
            
            boostMeButtonOutlet.setTitle("GET SUPER LIKES", for: .normal)
            tinderPlusSubTitleLabel.text = "(5 free Super Likes every day)"
        }
        
        if isPurchased {
            orLineView.isHidden = true
            getTinderPlusView.isHidden = true
            boostMeButtonOutlet.frame.origin.y = orLineView.frame.origin.y
        }
        
        schemeThemeColor = UIColor(red: 33.0/255.0, green: 120.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        
    
        createGradientLayer(forView: boostMeButtonOutlet, withColor:schemeThemeColor)
        
        boostMeButtonOutlet.superview?.clipsToBounds = true
        boostMeButtonOutlet.superview?.layer.cornerRadius = boostMeButtonOutlet.frame.size.height / 2
        
        getTinderPlusView.clipsToBounds = true
        getTinderPlusView.layer.cornerRadius = getTinderPlusView.frame.size.height / 2
        getTinderPlusView.layer.borderWidth = 2.0
        getTinderPlusView.layer.borderColor = schemeThemeColor.cgColor
        
        firstPlanHeaderLabel.isHidden = true
        plansCollectionView.bringSubview(toFront: firstPlanHeaderLabel)

        
        secondPlanHeaderLabel.isHidden = true
        plansCollectionView.bringSubview(toFront: secondPlanHeaderLabel)
        
        thirdPlanHeaderLabel.isHidden = true
        plansCollectionView.bringSubview(toFront: thirdPlanHeaderLabel)
        
        
        let tap12:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.didSelect12Month(_:)))
        firstPlanView.addGestureRecognizer(tap12)
        
        let tap6:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.didSelect6Month(_:)))
        secondPlanView.addGestureRecognizer(tap6)
        
        let tap1:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.didSelect1Month(_:)))
        thirdPlanView.addGestureRecognizer(tap1)
        
        let tapPlus:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.getPlusTapped))
        getTinderPlusView.addGestureRecognizer(tapPlus)
        
        firstPlanView.backgroundColor = deselectedBGColor
        secondPlanView.backgroundColor = deselectedBGColor
        thirdPlanView.backgroundColor = deselectedBGColor
        
        didSelect6Month(_: "")
        
        wsToGetPlan(planType: planType)
        
        
        
        firstPlanView.frame.size.height = firstPlanView.frame.size.width
        secondPlanView.frame.size.height = secondPlanView.frame.size.width
        thirdPlanView.frame.size.height = thirdPlanView.frame.size.width
    }
    
    
    func createGradientLayer(forView: UIView, withColor:UIColor) {
        
        
        let gradienView = UIView(frame: CGRect(x: forView.frame.origin.x, y: forView.frame.origin.y, width: forView.frame.size.width, height: forView.frame.size.height))
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradienView.bounds
        gradientLayer.colors = [withColor.cgColor, UIColor.white.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 2.0)
        gradienView.layer.addSublayer(gradientLayer)
        forView.frame = gradienView.bounds
        forView.backgroundColor = UIColor.clear
        gradienView.addSubview(forView)
        gradienView.bringSubview(toFront: forView)
        plansCollectionView.addSubview(gradienView)
        plansCollectionView.bringSubview(toFront: gradienView)
    }
    
    func changeGradientColor(withColor:UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = (plansBGView.superview?.bounds)!
        
        gradientLayer.colors = [withColor.cgColor, UIColor.white.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 2.0)
        plansBGView.superview?.layer.addSublayer(gradientLayer)
        
        for view in plansBGView.superview!.subviews {
            plansBGView.superview!.bringSubview(toFront: view)
        }
    }
    
    func setSelectedProduct(selectedLabel: UILabel) {
       
//        if selectedLabel.text == "1" {
//            if isBoost {
//                selectedProduct = Subscribtion.oneBoostSubscribtion
//            }
//            else {
//                selectedProduct = Subscribtion.twoBoostSubscribtion
//            }
//
//        }
//        else if selectedLabel.text == "2" {
//            if isBoost {
//                selectedProduct = Subscribtion.twoBoostSubscribtion
//            }
//            else {
//                selectedProduct = Subscribtion.twoSuperLikeSubscribtion
//            }
//        }
//        else if selectedLabel.text == "3" {
//            if isBoost {
//                selectedProduct = Subscribtion.threeBoostSubscribtion
//            }
//            else {
//                selectedProduct = Subscribtion.threeSuperLikeSubscribtion
//            }
//        }
        
        if isBoost {
            if selectedLabel.text == "1" {
                selectedProduct = Subscribtion.oneBoostSubscribtion
            }
            else if selectedLabel.text == "5" {
                selectedProduct = Subscribtion.twoBoostSubscribtion
            }
            else if selectedLabel.text == "10" {
                selectedProduct = Subscribtion.threeBoostSubscribtion
            }
        }
        else {
            if selectedLabel.text == "5" {
                selectedProduct = Subscribtion.oneSuperLikeSubscribtion
            }
            else if selectedLabel.text == "25" {
                selectedProduct = Subscribtion.twoSuperLikeSubscribtion
            }
            else if selectedLabel.text == "60" {
                selectedProduct = Subscribtion.threeSuperLikeSubscribtion
            }
        }
    }
    
    @objc func didSelect12Month(_ sender: Any) {
        
        selectedPlan = SelectedBoost.tenBoost.rawValue
        setSelectedProduct(selectedLabel: firstPlanCountLabel)
        firstPlanView.clipsToBounds = false
        firstPlanView.layer.borderWidth = 3
        firstPlanView.layer.borderColor = schemeThemeColor.cgColor
        firstPlanView.layer.cornerRadius = 2
        firstPlanView.backgroundColor = UIColor.white
        
        firstPlanCountLabel.textColor = schemeThemeColor
        firstBoostTitleLabel.textColor = schemeThemeColor
        rateTitleInFirstViewLabel.textColor = schemeThemeColor
        
        totalAmountIn10ViewLabel.textColor = schemeThemeColor
        
        
        
        self.firstPlanHeaderLabel.superview?.isHidden = false
        
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.firstPlanHeaderLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            self.firstPlanHeaderLabel.transform = CGAffineTransform.identity
                            self.firstPlanHeaderLabel.isHidden = false
                        }
        })
        
        if selectedView != nil {
            dropInAnimation(forView: selectedView!)
        }
        dropOutAnimation(forView: firstPlanView)
        selectedView = firstPlanView
        
        
        
        deSelect6Month()
        deSelect1Month()
        
    }
    
    @objc func didSelect6Month(_ sender: Any) {
        
        selectedPlan = SelectedBoost.fiveBoost.rawValue
        setSelectedProduct(selectedLabel: secondPlanCountLabel)
        secondPlanView.clipsToBounds = true
        secondPlanView.layer.borderWidth = 3
        secondPlanView.layer.borderColor = schemeThemeColor.cgColor
        secondPlanView.layer.cornerRadius = 2
        secondPlanView.backgroundColor = UIColor.white
        
        secondPlanCountLabel.textColor = schemeThemeColor
        secondBoostTitleLabel.textColor = schemeThemeColor
        rateTitleInSecondViewLabel.textColor = schemeThemeColor
        totalAmountIn5ViewLabel.textColor = schemeThemeColor
        
        
        secondPlanHeaderLabel.superview?.isHidden = false
        
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.secondPlanHeaderLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            self.secondPlanHeaderLabel.transform = CGAffineTransform.identity
                            self.secondPlanHeaderLabel.isHidden = false
                        }
        })
        if selectedView != nil {
            dropInAnimation(forView: selectedView!)
        }
        dropOutAnimation(forView: secondPlanView)
        selectedView = secondPlanView
        deSelect12Month()
        deSelect1Month()
    }
    
    @objc func didSelect1Month(_ sender: Any) {
        
        selectedPlan = SelectedBoost.oneBoost.rawValue
        setSelectedProduct(selectedLabel: thirdPlanCountLabel)
        thirdPlanView.clipsToBounds = true
        thirdPlanView.layer.borderWidth = 3
        thirdPlanView.layer.borderColor = schemeThemeColor.cgColor
        thirdPlanView.layer.cornerRadius = 2
        thirdPlanView.backgroundColor = UIColor.white
        
        thirdPlanCountLabel.textColor = schemeThemeColor
        thirdBoostTitleLabel.textColor = schemeThemeColor
        rateTitleInThirdViewLabel.textColor = schemeThemeColor
        totalAmountIn1ViewLabel.textColor = schemeThemeColor
        
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.thirdPlanHeaderLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            self.thirdPlanHeaderLabel.transform = CGAffineTransform.identity
                            self.thirdPlanHeaderLabel.isHidden = false
                        }
        })
        
        if selectedView != nil {
            dropInAnimation(forView: selectedView!)
        }
        dropOutAnimation(forView: thirdPlanView)
        selectedView = thirdPlanView
        
        deSelect12Month()
        deSelect6Month()
    }
    
    @objc func getPlusTapped() {
       
        self.dismiss(animated: false, completion: nil)
        plusDelegate?.showPlusView()
        
    }
    
    func deSelect12Month() {
        
        firstPlanView.clipsToBounds = false
        firstPlanView.layer.borderWidth = 0
        firstPlanView.layer.borderColor = UIColor.clear.cgColor
        firstPlanView.layer.cornerRadius = 0
        firstPlanView.backgroundColor = deselectedBGColor
        
        firstPlanCountLabel.textColor = UIColor.black
        firstBoostTitleLabel.textColor = UIColor.black
        rateTitleInFirstViewLabel.textColor = UIColor.black
        totalAmountIn10ViewLabel.textColor = UIColor.black
        
        
        firstPlanHeaderLabel.isHidden = true
//        self.firstPlanHeaderLabel.superview?.isHidden = true
        
    }
    
    func deSelect6Month() {
        
        secondPlanView.clipsToBounds = true
        secondPlanView.layer.borderWidth = 0
        secondPlanView.layer.borderColor = UIColor.clear.cgColor
        secondPlanView.layer.cornerRadius = 0
        secondPlanView.backgroundColor = deselectedBGColor
        
        secondPlanCountLabel.textColor = UIColor.black
        secondBoostTitleLabel.textColor = UIColor.black
        rateTitleInSecondViewLabel.textColor = UIColor.black
        totalAmountIn5ViewLabel.textColor = UIColor.black
        
        
        secondPlanHeaderLabel.isHidden = true
//        secondPlanHeaderLabel.superview?.isHidden = true
        
    }
    
    func deSelect1Month() {
        
        thirdPlanView.clipsToBounds = true
        thirdPlanView.layer.borderWidth = 0
        thirdPlanView.layer.borderColor = UIColor.clear.cgColor
        thirdPlanView.layer.cornerRadius = 0
        thirdPlanView.backgroundColor = deselectedBGColor
        
        thirdPlanCountLabel.textColor = UIColor.black
        thirdBoostTitleLabel.textColor = UIColor.black
        rateTitleInThirdViewLabel.textColor = UIColor.black
        totalAmountIn1ViewLabel.textColor = UIColor.black
        
        thirdPlanHeaderLabel.isHidden = true
        
    }
    
    func dropOutAnimation(forView: UIView) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
            forView.frame = CGRect(x: forView.frame.origin.x, y: forView.frame.origin.y, width: forView.frame.size.width, height: forView.frame.size.height)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
                forView.frame = CGRect(x: forView.frame.origin.x, y: forView.frame.origin.y + 5, width: forView.frame.size.width, height: forView.frame.size.height)
            }, completion: {(_ finished: Bool) -> Void in
            })
        })
    }
    
    func dropInAnimation(forView: UIView) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
            forView.frame = CGRect(x: forView.frame.origin.x, y: forView.frame.origin.y, width: forView.frame.size.width, height: forView.frame.size.height)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
                forView.frame = CGRect(x: forView.frame.origin.x, y: forView.frame.origin.y - 5, width: forView.frame.size.width, height: forView.frame.size.height)
            }, completion: {(_ finished: Bool) -> Void in
            })
        })
    }
    
    @objc func slideShowImages(_ sender:AnyObject?){
        if(self.pageControlView.currentPage > 5)
        {
            let indexPath:IndexPath = IndexPath(item: 0, section: 0)
            sliderCollectionView.scrollToItem(at:indexPath , at: .left, animated: true)
        }
        else
        {
            let indexPath:IndexPath = IndexPath(item: self.pageControlView.currentPage+1, section: 0)
            sliderCollectionView.scrollToItem(at:indexPath , at: .left, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func boostMeButtonAction(_ sender: Any) {
        
        if productList.count == 0 {
            Themes.sharedIntance.ShowProgress(view: self.view)
            Subscribtion.store.requestProducts{success, products in
                if success {
                    Themes.sharedIntance.RemoveProgress(view: self.view)
                    print("Products List:")
                    for p in products! {
                        print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
                        self.productList.append(p)
                    }
                    for product in self.productList {
                        let prodID = product.productIdentifier
                        if(prodID == self.selectedProduct) {
                            Themes.sharedIntance.ShowProgress(view: self.view)
                            Subscribtion.store.buyProduct(product, isFromGoldPlus:false)
                        }
                    }
                    
                }
                else {
                    Themes.sharedIntance.RemoveProgress(view: self.view)
                }
            }
        }
        else {
            for product in productList {
                let prodID = product.productIdentifier
                if(prodID == selectedProduct) {
                    Themes.sharedIntance.ShowProgress(view: self.view)
                    Subscribtion.store.buyProduct(product, isFromGoldPlus:false)
                }
            }
        }
        
        
    }
    
    @IBAction func noThanksButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func wsToGetPlan(planType: String) {
        
        if planType == "super_like"{
        
//                    self.planSliderDictArray = responseDict["plan_images"] as! [[String:Any]]
//
                    self.plansDict = StaticData.allUserData!.superPlansDetails
                    
                    self.setPlansValue(plansDictArray:StaticData.allUserData!.superPlansDetails, planImageDict:StaticData.allUserData!.superImageDict)
        }else{
            self.plansDict = StaticData.allUserData!.boostPlansDetail
            
            self.setPlansValue(plansDictArray:StaticData.allUserData!.boostPlansDetail, planImageDict:StaticData.allUserData!.boostImageDict)
        }
                    
                    
        
    }
    
    func setPlansValue(plansDictArray:[[String:Any]], planImageDict:[[String:Any]]) {
        if (UIDevice.modelName == "iPhone X") || (UIDevice.modelName == "Simulator iPhone X"){
            symbolImageView.frame.size.width=120
            symbolImageView.frame.size.height=120
            symbolImageView.frame.origin.x=symbolImageView.frame.origin.x-20
        }
//        firstPlanHeaderLabel.text =
//        secondPlanHeaderLabel.text =
//        thirdPlanHeaderLabel.text =

        firstPlanCountLabel.text = String(describing: plansDictArray[0]["month"]!)
        secondPlanCountLabel.text = String(describing: plansDictArray[1]["month"]!)
        thirdPlanCountLabel.text = String(describing: plansDictArray[2]["month"]!)

//        firstBoostTitleLabel.text =
//        secondBoostTitleLabel.text =
//        thirdBoostTitleLabel.text =

        rateTitleInFirstViewLabel.text = "\(String(describing: Themes.sharedIntance.getSymbol(forCurrencyCode: plansDictArray[0]["currency_code"] as! String)!)) \(String(describing: plansDictArray[0]["price"]!)) each"
        rateTitleInSecondViewLabel.text = "\(String(describing: Themes.sharedIntance.getSymbol(forCurrencyCode: plansDictArray[1]["currency_code"] as! String)!)) \(String(describing: plansDictArray[1]["price"]!)) each"
        rateTitleInThirdViewLabel.text = "\(String(describing: Themes.sharedIntance.getSymbol(forCurrencyCode: plansDictArray[2]["currency_code"] as! String)!)) \(String(describing: plansDictArray[2]["price"]!)) each"
        
        symbolImageView.sd_setImage(with: URL(string:planImageDict[0]["image"] as! String), placeholderImage: nil)
        planTitleLabel.text = planImageDict[0]["title"]! as? String
        planSubTitleLabel.text = planImageDict[0]["description"]! as? String
        
        totalAmountIn10ViewLabel.text = "(\(String(describing: Themes.sharedIntance.getSymbol(forCurrencyCode: plansDictArray[0]["currency_code"] as! String)!)) \(String(describing: (plansDictArray[0]["price"]! as! Int) * (plansDictArray[0]["month"]! as! Int))))"
        totalAmountIn5ViewLabel.text = "(\(String(describing: Themes.sharedIntance.getSymbol(forCurrencyCode: plansDictArray[1]["currency_code"] as! String)!)) \(String(describing: (plansDictArray[1]["price"]! as! Int) * (plansDictArray[1]["month"]! as! Int))))"
        totalAmountIn1ViewLabel.text = "(\(String(describing: Themes.sharedIntance.getSymbol(forCurrencyCode: plansDictArray[2]["currency_code"] as! String)!)) \(String(describing: (plansDictArray[2]["price"]! as! Int) * (plansDictArray[2]["month"]! as! Int))))"
        
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        
        Themes.sharedIntance.RemoveProgress(view: self.view)
        guard let paymentTransaction = notification.object as? SKPaymentTransaction else { return }
        
        print("DONE \(paymentTransaction.transactionIdentifier!) FOR \(paymentTransaction.payment.productIdentifier)")
        
        var originalTransactionID = String()
        if let id = paymentTransaction.original?.transactionIdentifier {
            originalTransactionID = id
        }
        else {
            originalTransactionID = paymentTransaction.transactionIdentifier!
        }
        
        let param:[String:String] = ["payment_type":"appstore", "transaction_id":paymentTransaction.transactionIdentifier!, "plan_id":"\(String(describing: plansDict[selectedPlan]["plan_id"]!))", "plan_type": planType, "package_name":"com.trioangle.igniter", "product_id":paymentTransaction.payment.productIdentifier, "purchase_token":originalTransactionID, "token":Themes.sharedIntance.getaccesstoken()!]
        
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.after_payment as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
            Themes.sharedIntance.RemoveProgress(view: self.view)
            if((responseDict?.count)! > 0)
            {
                let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                if(status_code == "1")
                {
                    
                    self.dismiss(animated: true, completion: nil)
                    SharedVariables.sharedInstance.superLikesCount = responseDict?.object(forKey: "remaining_slikes_count") as! Int
                    SharedVariables.sharedInstance.boostCount = responseDict?.object(forKey: "remaining_boost_count") as! Int
                    
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
    
    @objc func handlePurchaseFailedNotification(_ notification: Notification) {
        
        Themes.sharedIntance.RemoveProgress(view: self.view)
        guard let paymentTransaction = notification.object as? SKPaymentTransaction else { return }
        
        if let transactionError = paymentTransaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(String(describing: paymentTransaction.error!.localizedDescription))")
                
                let alert = UIAlertController(title: "Transaction Error", message: "\(String(describing: paymentTransaction.error!.localizedDescription))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    
}


