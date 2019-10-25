//
//  GoldPlansViewController.swift
//  Tinder Clone
//
//  Created by Vignesh Palanivel on 24/03/18.
//  Copyright © 2018 Anonymous. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

class GoldPlansCVC: UICollectionViewCell {
    @IBOutlet var noOfMonthsLabel: UILabel!
    @IBOutlet var monthTitleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var savePercentageLabel: UILabel!
    @IBOutlet var baseView: UIView!
    
}

protocol AfterPurchaseDelegate {
    func purchaseDone()
}

enum SelectedPlan:Int {
    case twelveMonth = 0, sixMonth, oneMonth
}

class GoldPlansViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SliderCollectionViewDelegate, SFSafariViewControllerDelegate {
    func IndexforPageControl(index: Int) {
        self.pageControlView.currentPage = index;
        
        if !isGold && index < plusBGColorArray.count {
            changeGradientColor(withColor: plusBGColorArray[index])
        }
    }
    
    
    

    @IBOutlet var planView: UIView!
    
    @IBOutlet var plansCollectionView: UIView!
    @IBOutlet var sliderCollectionView: SliderCollectionView!
    @IBOutlet var pageControlView: FXPageControl!
    
    @IBOutlet var twelveMonthView: UIView!
    @IBOutlet var sixMonthView: UIView!
    @IBOutlet var oneMonthView: UIView!
    
    @IBOutlet var bestValueLabel: UILabel!
    @IBOutlet var mostPopularLabel: UILabel!
    @IBOutlet var noOfMonthsIn12ViewLabel: UILabel!
    @IBOutlet var noOfMonthsIn6ViewLabel: UILabel!
    @IBOutlet var noOfMonthsIn1ViewLabel: UILabel!
    @IBOutlet var monthTitleIn12View: UILabel!
    @IBOutlet var monthTitleIn6View: UILabel!
    @IBOutlet var monthTitleIn1View: UILabel!
    @IBOutlet var rateTitleIn12ViewLabel: UILabel!
    @IBOutlet var rateTitleIn6ViewLabel: UILabel!
    @IBOutlet var rateTitleIn1ViewLabel: UILabel!
    @IBOutlet var savePercentageIn12ViewLabel: UILabel!
    @IBOutlet var savePercentageIn6ViewLabel: UILabel!
    @IBOutlet var savePercentageIn1ViewLabel: UILabel!
    @IBOutlet weak var continueButtonOutlet: UIButton!
    @IBOutlet weak var goldPlusTitleLabel: UILabel!
    @IBOutlet weak var plansBGView: UIView!
    
    var deselectedBGColor = UIColor()
    
    
    var selectedIndexPath: IndexPath?
    
    var plansDict = [[String:Any]]()
    
    var isGold = Bool()
    var plusBGColorArray = [UIColor]()
    var gradientLayer: CAGradientLayer!
    
    var selectedProduct = String()
    
    var productList = [SKProduct]()
    
    var planSliderDictArray = [[String:Any]]()
    var planType = String()
    var selectedPlan = Int()
    
    var delegate:AfterPurchaseDelegate?
    
    func getProducts() {
        
        Subscribtion.store.requestProducts{success, products in
            if success {
                print("Products List:")
                for p in products! {
                    print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
                    self.productList.append(p)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseFailedNotification), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

//        Subscribtion.store.restorePurchases()
        getProducts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GoldPlansViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GoldPlansViewController.handlePurchaseFailedNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseFailedNotification),
                                               object: nil)
    }
    
    
    var schemeThemeColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isGold {
            selectedProduct = Subscribtion.goldSixMonthSubscribtion
        }
        else {
            selectedProduct = Subscribtion.plusSixMonthSubscribtion
        }
        
        planView.clipsToBounds = true
        planView.layer.cornerRadius = 6.0
        
        deselectedBGColor = UIColor(red: 241.0/255.0, green: 242.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        
        plusBGColorArray = [UIColor(red: 57.0/255.0, green: 225.0/255.0, blue: 146.0/255.0, alpha: 1.0), UIColor(red: 148.0/255.0, green: 77.0/255.0, blue: 212.0/255.0, alpha: 1.0),UIColor(red: 231.0/255.0, green: 27.0/255.0, blue: 155.0/255.0, alpha: 1.0), UIColor(red: 27.0/255.0, green: 73.0/255.0, blue: 170.0/255.0, alpha: 1.0), UIColor(red: 255.0/255.0, green: 108.0/255.0, blue: 65.0/255.0, alpha: 1.0), UIColor(red: 25.0/255.0, green: 151.0/255.0, blue: 255.0/255.0, alpha: 1.0), UIColor(red: 225.0/255.0, green: 177.0/255.0, blue: 5.0/255.0, alpha: 1.0), UIColor(red: 148.0/255.0, green: 158.0/255.0, blue: 173.0/255.0, alpha: 1.0)]
        
        var dic = [String:String]()
        
        dic["Month"] = "12"
        dic["Amount"] = "274.92"
        dic["SavePercentage"] = "53"
        
        plansDict.append(dic)
        
        dic["Month"] = "6"
        dic["Amount"] = "366.50"
        dic["SavePercentage"] = "53"
        
        plansDict.append(dic)
        
        dic["Month"] = "1"
        dic["Amount"] = "589.00"
        dic["SavePercentage"] = "25"
        
        plansDict.append(dic)
        
        var imageArr = [String]()
        var titleArr = [String]()
        var subtitleArr = [String]()
        
        if isGold {
            
            planType = "gold"
            goldPlusTitleLabel.text = "Get \(k_Application_Name) Gold"
            goldPlusTitleLabel.textColor = Constant.k_GoldColorCode
            
            plansBGView.backgroundColor = UIColor.clear
            
            imageArr = ["Igniter_plus6_heart","plusHeart","plusThund","plusKey","Igniter_plus6","plusSwitch","plusStar","plusRev","Igniter_plus8"]
            
            
            titleArr = ["See who likes you","Unlimited likes","1 free boost every 1 month","Choose who sees you","Swipe around the world!","Control your age and distance","5 free Super Likes every day","Unlimited rewinds", "Turnoff Adverts"]
            subtitleArr = ["Match with them instantly","Swipe right as much as you want","Skip the queue to get more matches","Only be shown to people you have liked","Passport to anywhere!","Limit what others see about you","You're three times more likely to get a match","Go back and swipe again","Have fun swiping"]
            
            schemeThemeColor = Constant.k_GoldColorCode
            
            createGradientLayer(forView: bestValueLabel, withColor:schemeThemeColor)
            createGradientLayer(forView: mostPopularLabel, withColor:schemeThemeColor)
            
            bestValueLabel.superview?.clipsToBounds = true
            bestValueLabel.superview?.layer.cornerRadius = bestValueLabel.frame.size.height / 2
            bestValueLabel.superview?.isHidden = true
            bestValueLabel.isHidden = true
            
            mostPopularLabel.superview?.clipsToBounds = true
            mostPopularLabel.superview?.layer.cornerRadius = mostPopularLabel.frame.size.height / 2
            mostPopularLabel.superview?.isHidden = true
            mostPopularLabel.isHidden = true
            
        }
        else {
            
            planType = "plus"
            goldPlusTitleLabel.text = "Get \(k_Application_Name) Plus"
            goldPlusTitleLabel.textColor = UIColor.white
            
            plansBGView.backgroundColor = UIColor(red: 255.0/255.0, green: 108.0/255.0, blue: 65.0/255.0, alpha: 1.0)
            
            imageArr = ["plusHeart","plusThund","plusKey","Igniter_plus6","plusSwitch","plusStar","plusRev","Igniter_plus8"]
            
            
            titleArr = ["Unlimited likes","1 free boost every 1 month","Choose who sees you","Swipe around the world!","Control your age and distance","5 free Super Likes every day","Unlimited rewinds", "Turnoff Adverts"]
            subtitleArr = ["Swipe right as much as you want","Skip the queue to get more matches!","Only be shown to people you have liked","Passport to anywhere!","Limit what others see about you","You're three times more likely to get a match!","Go back and swipe again!","Have fun swiping"]
            
            schemeThemeColor = UIColor(red: 33.0/255.0, green: 120.0/255.0, blue: 233.0/255.0, alpha: 1.0)
            createGradientLayer(forView: plansBGView, withColor:UIColor(red: 57.0/255.0, green: 225.0/255.0, blue: 146.0/255.0, alpha: 1.0))
            
            bestValueLabel.clipsToBounds = true
            bestValueLabel.layer.cornerRadius = bestValueLabel.frame.size.height / 2
            bestValueLabel.isHidden = true
            bestValueLabel.isHidden = true
            bestValueLabel.backgroundColor = schemeThemeColor
            plansCollectionView.bringSubview(toFront: bestValueLabel)
            
            mostPopularLabel.clipsToBounds = true
            mostPopularLabel.layer.cornerRadius = mostPopularLabel.frame.size.height / 2
            mostPopularLabel.isHidden = true
            mostPopularLabel.isHidden = true
            mostPopularLabel.backgroundColor = schemeThemeColor
            plansCollectionView.bringSubview(toFront: mostPopularLabel)
        }
        
        
        
        createGradientLayer(forView: continueButtonOutlet, withColor:schemeThemeColor)
        
        continueButtonOutlet.superview?.clipsToBounds = true
        continueButtonOutlet.superview?.layer.cornerRadius = continueButtonOutlet.frame.size.height / 2
        
        
        let tap12:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.didSelect12Month(_:)))
        twelveMonthView.addGestureRecognizer(tap12)
        
        let tap6:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.didSelect6Month(_:)))
        sixMonthView.addGestureRecognizer(tap6)
        
        let tap1:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.didSelect1Month(_:)))
        oneMonthView.addGestureRecognizer(tap1)
        
        twelveMonthView.backgroundColor = deselectedBGColor
        sixMonthView.backgroundColor = deselectedBGColor
        oneMonthView.backgroundColor = deselectedBGColor
        
        twelveMonthView.frame.size.height = twelveMonthView.frame.size.width
        sixMonthView.frame.size.height = sixMonthView.frame.size.width
        oneMonthView.frame.size.height = oneMonthView.frame.size.width
        
        didSelect6Month(_: "")
        
        
        
        wsToGetPlan(planType: planType)
    }
    
    
    func createGradientLayer(forView: UIView, withColor:UIColor) {

        
        let gradienView = UIView(frame: CGRect(x: forView.frame.origin.x, y: forView.frame.origin.y, width: forView.frame.size.width, height: forView.frame.size.height))
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradienView.bounds
        gradientLayer.colors = [withColor.cgColor, UIColor.white.cgColor]
        
//        gradientLayer.colors = [UIColor(red: 124.0/255.0, green: 72.0/255.0, blue: 95.0/255.0, alpha: 1.0).cgColor, UIColor(red: 207.0/255.0, green: 89.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 2.5)
        gradientLayer.endPoint = CGPoint(x: 3.0, y: 1.0)
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
        
//        gradientLayer.colors = [UIColor(red: 124.0/255.0, green: 72.0/255.0, blue: 95.0/255.0, alpha: 1.0).cgColor, UIColor(red: 207.0/255.0, green: 89.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 2.5)
        gradientLayer.endPoint = CGPoint(x: 3.0, y: 1.0)
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.0, y: 2.0)
        plansBGView.superview?.layer.addSublayer(gradientLayer)
        
        for view in plansBGView.superview!.subviews {
            plansBGView.superview!.bringSubview(toFront: view)
        }
    }
    
    @objc func didSelect12Month(_ sender: Any) {
        
        if isGold {
            selectedProduct = Subscribtion.goldTwelveMonthSubscribtion
        }
        else {
            selectedProduct = Subscribtion.plusTwelveMonthSubscribtion
        }
        
        twelveMonthView.clipsToBounds = false
        twelveMonthView.layer.borderWidth = 3
        twelveMonthView.layer.borderColor = schemeThemeColor.cgColor
        twelveMonthView.layer.cornerRadius = 2
        twelveMonthView.backgroundColor = UIColor.white
        
        noOfMonthsIn12ViewLabel.textColor = schemeThemeColor
        monthTitleIn12View.textColor = schemeThemeColor
        rateTitleIn12ViewLabel.textColor = schemeThemeColor
        savePercentageIn12ViewLabel.textColor = schemeThemeColor
        self.bestValueLabel.superview?.isHidden = false
        
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.bestValueLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            self.bestValueLabel.transform = CGAffineTransform.identity
                            self.bestValueLabel.isHidden = false
                        }
        })

        
        selectedPlan = SelectedPlan.twelveMonth.rawValue
        
        deSelect6Month()
        deSelect1Month()

    }
    
     @objc func didSelect6Month(_ sender: Any) {
        
        
        if isGold {
            selectedProduct = Subscribtion.goldSixMonthSubscribtion
        }
        else {
            selectedProduct = Subscribtion.plusSixMonthSubscribtion
        }
        
        sixMonthView.clipsToBounds = true
        sixMonthView.layer.borderWidth = 3
        sixMonthView.layer.borderColor = schemeThemeColor.cgColor
        sixMonthView.layer.cornerRadius = 2
        sixMonthView.backgroundColor = UIColor.white
        
        noOfMonthsIn6ViewLabel.textColor = schemeThemeColor
        monthTitleIn6View.textColor = schemeThemeColor
        rateTitleIn6ViewLabel.textColor = schemeThemeColor
        savePercentageIn6ViewLabel.textColor = schemeThemeColor
        
        mostPopularLabel.superview?.isHidden = false
        
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.mostPopularLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            self.mostPopularLabel.transform = CGAffineTransform.identity
                            self.mostPopularLabel.isHidden = false
                        }
        })
        
        selectedPlan = SelectedPlan.sixMonth.rawValue
        
        deSelect12Month()
        deSelect1Month()
    }
    
    @objc func didSelect1Month(_ sender: Any) {
        
        if isGold {
            selectedProduct = Subscribtion.goldOneMonthSubscribtion
//            selectedProduct = Subscribtion.goldOneMonthAutoRenewSubscribtion
        }
        else {
            selectedProduct = Subscribtion.plusOneMonthSubscribtion
        }
        
        oneMonthView.clipsToBounds = true
        oneMonthView.layer.borderWidth = 3
        oneMonthView.layer.borderColor = schemeThemeColor.cgColor
        oneMonthView.layer.cornerRadius = 2
        oneMonthView.backgroundColor = UIColor.white
        
        noOfMonthsIn1ViewLabel.textColor = schemeThemeColor
        monthTitleIn1View.textColor = schemeThemeColor
        rateTitleIn1ViewLabel.textColor = schemeThemeColor
        savePercentageIn1ViewLabel.textColor = schemeThemeColor
        
        selectedPlan = SelectedPlan.oneMonth.rawValue
        
        deSelect12Month()
        deSelect6Month()
    }
    
    func deSelect12Month() {
        
        twelveMonthView.clipsToBounds = false
        twelveMonthView.layer.borderWidth = 0
        twelveMonthView.layer.borderColor = UIColor.clear.cgColor
        twelveMonthView.layer.cornerRadius = 0
        twelveMonthView.backgroundColor = deselectedBGColor
        
        noOfMonthsIn12ViewLabel.textColor = UIColor.black
        monthTitleIn12View.textColor = UIColor.black
        rateTitleIn12ViewLabel.textColor = UIColor.black
        savePercentageIn12ViewLabel.textColor = UIColor.black
        
        bestValueLabel.isHidden = true
        if isGold {
            self.bestValueLabel.superview?.isHidden = true
        }
        
        
    }
    
    func deSelect6Month() {
        
        sixMonthView.clipsToBounds = true
        sixMonthView.layer.borderWidth = 0
        sixMonthView.layer.borderColor = UIColor.clear.cgColor
        sixMonthView.layer.cornerRadius = 0
        sixMonthView.backgroundColor = deselectedBGColor
        
        noOfMonthsIn6ViewLabel.textColor = UIColor.black
        monthTitleIn6View.textColor = UIColor.black
        rateTitleIn6ViewLabel.textColor = UIColor.black
        savePercentageIn6ViewLabel.textColor = UIColor.black
        
        mostPopularLabel.isHidden = true
        if isGold {
            mostPopularLabel.superview?.isHidden = true
        }
        
        
    }
    
    func deSelect1Month() {
        
        oneMonthView.clipsToBounds = true
        oneMonthView.layer.borderWidth = 0
        oneMonthView.layer.borderColor = UIColor.clear.cgColor
        oneMonthView.layer.cornerRadius = 0
        oneMonthView.backgroundColor = deselectedBGColor
        
        noOfMonthsIn1ViewLabel.textColor = UIColor.black
        monthTitleIn1View.textColor = UIColor.black
        rateTitleIn1ViewLabel.textColor = UIColor.black
        savePercentageIn1ViewLabel.textColor = UIColor.black
    }
    
    @objc func slideShowImages(_ sender:AnyObject?){
        if(self.pageControlView.currentPage >= self.planSliderDictArray.count - 1)
        {
            let indexPath:IndexPath = IndexPath(item: 0, section: 0)
            sliderCollectionView.scrollToItem(at:indexPath , at: .left, animated: true)
        }
        else
        {
            let indexPath:IndexPath = IndexPath(item: self.pageControlView.currentPage+1, section: 0)
            sliderCollectionView.scrollToItem(at:indexPath , at: .left, animated: true)
        }
        
//        if !isGold && self.pageControlView.currentPage < plusBGColorArray.count {
//
////            createGradientLayer(forView: plansBGView, withColor: plusBGColorArray[self.pageControlView.currentPage])
//
//            changeGradientColor(withColor: plusBGColorArray[self.pageControlView.currentPage])
//        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Button Actions
    
    @IBAction func continueButtonAction(_ sender: Any) {
        for product in productList {
            let prodID = product.productIdentifier
            print(prodID)
            if(prodID == selectedProduct) {
                Themes.sharedIntance.ShowProgress(view: self.view)
                Subscribtion.store.buyProduct(product, isFromGoldPlus:true)
            }
        }
    }
    
    
    @IBAction func noThanksButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func buyProduct(product:SKProduct) {
        print("buy " + product.productIdentifier)
        let pay = SKPayment(product: product)
//        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
    
    @IBAction func termsButtonAction(_ sender: Any) {
        
        let url = URL(string: k_TermsAndConditionsURL)!
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
        controller.delegate = self
        
    }
    
    @IBAction func privacyButtonAction(_ sender: Any) {
        
        let url = URL(string: k_PrivacyPolicyURL)!
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
        controller.delegate = self
    }
    
    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goldPlansCVC", for: indexPath as IndexPath) as! GoldPlansCVC
        
        var borderColor: CGColor! = UIColor.clear.cgColor
        var borderWidth: CGFloat = 0
        
        cell.noOfMonthsLabel.text = "\(String(describing: plansDict[indexPath.row]["Month"]!))"
        cell.amountLabel.text = "\(String(describing: plansDict[indexPath.row]["Amount"]!))/mth"
        cell.savePercentageLabel.text = "Save \(String(describing: plansDict[indexPath.row]["SavePercentage"]!))%"
        
        
        if selectedIndexPath == indexPath {
            borderColor = Constant.k_GoldColorCode.cgColor
            borderWidth = 3 //or whatever you please
            cell.noOfMonthsLabel.textColor = schemeThemeColor
            cell.amountLabel.textColor = schemeThemeColor
            cell.savePercentageLabel.textColor = schemeThemeColor
            cell.monthTitleLabel.textColor = schemeThemeColor
            cell.backgroundColor = UIColor.white
        }else{
            borderColor = UIColor.clear.cgColor
            borderWidth = 0
            
            cell.noOfMonthsLabel.textColor = UIColor.black
            cell.amountLabel.textColor = UIColor.black
            cell.savePercentageLabel.textColor = UIColor.black
            cell.monthTitleLabel.textColor = UIColor.black
            cell.backgroundColor = UIColor(red: 241.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        }
        
        cell.clipsToBounds = true
       //cell.clipsToBounds = false
        cell.layer.borderWidth = borderWidth
        cell.layer.borderColor = borderColor
        cell.layer.cornerRadius = 2
        return cell
        
    }
    
    
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width / 3 - 10 , height: collectionView.frame.size.height)
    }
    
//    var selectedIndexPath: NSIndexPath{
//        didSet{
//            collectionView.reloadData()
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
//        let totalCellWidth = collectionView.frame.size.width / 3 - 10
//        let totalSpacingWidth = CGFloat(3)
//
//        let leftInset = (collectionView.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, 5, 0, 5)
    }
    
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        
        guard let paymentTransaction = notification.object as? SKPaymentTransaction else { return }
        
//        for (index, product) in productList.enumerated() {
//            guard product.productIdentifier == productID else { continue }
//            print("DONE \(product.productIdentifier)")
//
//        }
        
//        var receiptURL = Bundle.main.appStoreReceiptURL
        
        var originalTransactionID = String()
        if let id = paymentTransaction.original?.transactionIdentifier {
            originalTransactionID = id
        }
        else {
            originalTransactionID = paymentTransaction.transactionIdentifier!
        }
        
        print("DONE \(paymentTransaction.transactionIdentifier!) FOR \(paymentTransaction.payment.productIdentifier)")
        
        let param:[String:String] = ["payment_type":"appstore", "transaction_id":paymentTransaction.transactionIdentifier!, "plan_id":"\(String(describing: plansDict[selectedPlan]["plan_id"]!))", "plan_type": planType, "package_name":"com.brains.ello", "product_id":paymentTransaction.payment.productIdentifier, "purchase_token":originalTransactionID, "token":Themes.sharedIntance.getaccesstoken()!]
        
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.after_payment as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
            if ResponseDict != nil{
            if((ResponseDict?.count)! > 0)
            {
                let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                if(status_code == "1")
                {
                    
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.purchaseDone()
                    
                    
//                    let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewControllerID") as! MainViewController
//                    self.navigationController?.pushViewController(mainVC, animated: true)
                    
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
            }
        })
        
    }
    
    @objc func handlePurchaseFailedNotification(_ notification: Notification) {
        
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
    
    func wsToGetPlan(planType: String) {
        
            
            
        if planType == "gold"{
            
                    self.planSliderDictArray = StaticData.allUserData!.goldImageDict
                    
                    self.plansDict = StaticData.allUserData!.goldPlansDetails
        }else{
            self.planSliderDictArray = StaticData.allUserData!.plusImageDict
            
            self.plansDict = StaticData.allUserData!.plusPlansDetails
        }
                    
                    self.setPlansValue()
                    
                    let HeaderSliderArray:NSMutableArray = NSMutableArray()
                    for planSliderDict in self.planSliderDictArray {
                        
                        let objRecord:SliderRecord=SliderRecord(imageName: planSliderDict["image"] as! String, LogoimageName: "", DetailText: planSliderDict["title"] as! String, subtext:planSliderDict["description"] as! String)
                        HeaderSliderArray.add(objRecord)
                        
                    }
                    self.sliderCollectionView.Delegate = self
                    self.sliderCollectionView.List_data_source = NSMutableArray(array: HeaderSliderArray)
                    self.sliderCollectionView.Slidercat = .planSlider
                    self.sliderCollectionView.isGold = self.isGold
                    self.sliderCollectionView.Paging_Enabled=true
                    self.sliderCollectionView.ReloadSlider()
                    self.pageControlView.numberOfPages = self.planSliderDictArray.count
                    self.pageControlView.defersCurrentPageDisplay = true;
                    self.pageControlView.selectedDotColor = self.schemeThemeColor
                    self.pageControlView.dotColor = UIColor.lightGray
                    self.pageControlView.currentPage = 0;
                    self.pageControlView.selectedDotSize = 8.0;
                    self.pageControlView.dotSpacing = 15.0
                    self.pageControlView.dotSize = 5.0
                    // Do any additional setup after loading the view.
                    
                    Timer.scheduledTimer(timeInterval: 2.5, target:self, selector: #selector(self.slideShowImages(_:)), userInfo: nil, repeats: true)
                    
        
           
    }
    
    func setPlansValue() {
        
        noOfMonthsIn12ViewLabel.text = String(describing: plansDict[0]["month"]!)
        rateTitleIn12ViewLabel.text = "\(String(describing: Themes.sharedIntance.getSymbol(forCurrencyCode: plansDict[0]["currency_code"] as! String)!)) \(String(describing: plansDict[0]["price"]!))/mth"
        let total = (plansDict[0]["price"]! as! Int) * (plansDict[0]["month"]! as! Int)
        savePercentageIn12ViewLabel.text = "(\(String(describing: Themes.sharedIntance.getSymbol(forCurrencyCode: plansDict[0]["currency_code"] as! String)!)) \(String(describing: total)))"
        
        noOfMonthsIn6ViewLabel.text = String(describing: plansDict[1]["month"]!)
        rateTitleIn6ViewLabel.text = "\(String(describing: Themes.sharedIntance.getSymbol(forCurrencyCode: plansDict[1]["currency_code"] as! String)!)) \(String(describing: plansDict[1]["price"]!))/mth"
        let total1 = (plansDict[1]["price"]! as! Int) * (plansDict[1]["month"]! as! Int)
        savePercentageIn6ViewLabel.text = "(\(String(describing: Themes.sharedIntance.getSymbol(forCurrencyCode: plansDict[0]["currency_code"] as! String)!)) \(String(describing: total1)))"
        
        noOfMonthsIn1ViewLabel.text = String(describing: plansDict[2]["month"]!)
        rateTitleIn1ViewLabel.text = "\(String(describing: Themes.sharedIntance.getSymbol(forCurrencyCode: plansDict[2]["currency_code"] as! String)!)) \(String(describing: plansDict[2]["price"]!))/mth"
        let total2 = (plansDict[2]["price"]! as! Int) * (plansDict[2]["month"]! as! Int)
        savePercentageIn1ViewLabel.text = "(\(String(describing: Themes.sharedIntance.getSymbol(forCurrencyCode: plansDict[0]["currency_code"] as! String)!)) \(String(describing: total2)))"
    }
    
    // MARK: - SFSafariViewController Delegate
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

