
//  AppDelegate.swift
//  Tinder Clone
//
//  Created by Vaigunda Anand M on 8/13/17.
//  Copyright © 2017 Anonymous. All rights reserved.
//

import UIKit
import CoreData
import ReachabilitySwift
import FBSDKLoginKit
import UserNotifications
import Firebase
import GoogleMaps
import GooglePlaces
import SwipeTransition
import GiphyUISDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
    var controller: SLPagingViewSwift!
    var nav: UINavigationController?
    let reachability = Reachability()!
    var isnetWorkConnected:Bool = Bool()
    var isNotificationPer:Bool = Bool()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //        for familyName in UIFont.familyNames {
        //            print("\n-- \(familyName) \n")
        //            for fontName in UIFont.fontNames(forFamilyName: familyName) {
        //                print(fontName)
        //            }
        //        }
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        // Override point for customization after application launch.
        //        self.MovetoRoot(status: "home")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        
        let notificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        }
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GMSServices.provideAPIKey(k_GoogleAPI_Key)
        GMSPlacesClient.provideAPIKey(k_GoogleAPI_Key)
        //        receiptValidation()
        
        GiphyUISDK.configure(apiKey: "br7Cz8zHsl8lMOl9kfkuxukn1U0K0VCt")
        
        return true
    }
    func notificationPermission(){
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /*
        print(deviceToken)
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        Messaging.messaging().apnsToken = deviceToken
 */
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NavigateToChat"), object: data)
    }
    
    
    
    
    // MARK: UNUserNotificationCenter Delegate // >= iOS 10
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let dict = notification.request.content.userInfo as NSDictionary
        let custom = dict["custom"] as Any
        let data = convertStringToDictionary(text: custom as! String)
        self.handlePushNotificaiton(userInfo: data! as NSDictionary)
        
        Themes.sharedIntance.saveUnreadCount(unread_count: 1)
        
        if let wd = UIApplication.shared.delegate?.window {
            var vc = wd!.rootViewController
            if(vc is UINavigationController){
                vc = (vc as! UINavigationController).visibleViewController
            }
            if(vc is ConservationViewController){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MessageReceived"), object: dict)
                completionHandler([])
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewMessageReceiveds"), object: dict)
               
                completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
                
            }
        }
        
        
    }
    func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let dict = response.notification.request.content.userInfo as NSDictionary
        let custom = dict["custom"] as Any
        let data = convertStringToDictionary(text: custom as! String)
        self.handlePushNotificaiton(userInfo: data! as NSDictionary)
        completionHandler()
        
        
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NavigateToChat"), object: data!)
        
    }
    // MARK: Converted a String to dictionary format
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    
    
    //MARK: HANDLE PUSH NOTIFICATION
    func handlePushNotificaiton(userInfo: NSDictionary)
    {
//        let action = Themes.sharedIntance.CheckNullvalue(Str: userInfo.object(forKey: "action") as AnyObject)
        loadChats()
        
    }
     func loadChats(){
       
            StaticData.allUserData!.conservationStarted.removeAll()
            StaticData.allUserData!.conservationNotStarted.removeAll()
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.match_details as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
                if responseDict != nil{
                    if((responseDict?.count)! > 0)
                    {
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                        let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                        
                        if(status_code == "1")
                        {
                            let unread_count = Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "unread_count") as AnyObject)
                            Themes.sharedIntance.saveUnreadCount(unread_count: unread_count)
                            
                            let conversation_not_started_array:NSArray =  responseDict?.object(forKey: "conversation_not_started_array") as! NSArray
                            
                            if(conversation_not_started_array.count > 0)
                            {   print(conversation_not_started_array)
                                for i in 0..<conversation_not_started_array.count
                                {
                                    let ResponseDict:NSDictionary = conversation_not_started_array[i] as! NSDictionary
                                    let objRecord:matchProfileRecord = matchProfileRecord()
                                    objRecord.isgoldLike = false
                                    
                                    objRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                                    objRecord.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                                    objRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                                    
                                    objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                                    objRecord.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                                    objRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                                    
                                    objRecord.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                                    
                                    StaticData.allUserData?.conservationNotStarted.removeAll()
                                    StaticData.allUserData?.conservationNotStarted.append(objRecord)
                                }
                            }
                            //                    self.CollectionView.reloadData()
                            
                            
                            
                            let conversation_started_array:NSArray =  responseDict?.object(forKey: "conversation_started_array") as! NSArray
                            
                            if(conversation_started_array.count > 0)
                            {
                                
                                for i in 0..<conversation_started_array.count
                                {
                                    let ResponseDict:NSDictionary = conversation_started_array[i] as! NSDictionary
                                    let objRecord:matchProfileRecord = matchProfileRecord()
                                    objRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                                    objRecord.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                                    objRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                                    
                                    objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                                    objRecord.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                                    objRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                                    objRecord.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                                    objRecord.status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "message") as AnyObject)
                                    objRecord.is_reply = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "is_reply") as AnyObject)
                                    StaticData.allUserData?.conservationStarted.removeAll()
                                    StaticData.allUserData?.conservationStarted.append(objRecord)
                                  
                                }
                                
                            }
                            
                            
                        }
                        else
                        {
                            
                        }
                        
                    }
                    else
                    {
                        
                    }
                }
            })
    }
    
    
    @objc func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            
            isnetWorkConnected = true
        } else {
            isnetWorkConnected = false
            print("Network not reachable")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isNetworkConnected"), object: isnetWorkConnected)
    }
    
    func MovetoRoot(status:String)
    {
        if(status == "home")
        {
            
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewControllerID") as! MainViewController
            let homeViewController=AppStoryboard.Extra.viewController(viewControllerClass: MainViewController.self)
            let nav = SwipeBackNavigationController(rootViewController: homeViewController)
            homeViewController.isFromFacebook = true
            nav.navigationBar.isHidden = true
            self.window?.rootViewController = nav
        }else if(status=="splash"){
            let vc=AppStoryboard.Extra.viewController(viewControllerClass: SplashViewController.self)
            //self.present(vc, animated: true, completion: nil)
            self.window?.rootViewController=vc
        }
        else
        {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let InitialMainViewController = mainStoryboard.instantiateViewController(withIdentifier: "InitialMainViewControllerID") as! InitialMainViewController
            let nav = UINavigationController(rootViewController: InitialMainViewController)
            InitialMainViewController.isHideanimation = false
            nav.navigationBar.isHidden = true
            self.window?.rootViewController = nav
            
        }
    }
    
    func gradient(percent: Double, topX: Double, bottomX: Double, initC: UIColor, goal: UIColor) -> UIColor{
        let t = (percent - bottomX) / (topX - bottomX)
        
        let cgInit = initC.cgColor.components
        let cgGoal = goal.cgColor.components
        
        
        var r = (cgInit?[0])! + CGFloat(t)
        r = r * ((cgGoal?[0])! - (cgInit?[0])!)
        let g = (cgInit?[1])! + CGFloat(t) * ((cgGoal?[1])! - (cgInit?[1])!)
        let b = (cgInit?[2])! + CGFloat(t) * ((cgGoal?[2])! - (cgInit?[2])!)
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        AppEvents.activateApp()
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "coredate_mod")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            
        }
    }
    
    //MARK:- Messaging Delegate
    
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        Themes.sharedIntance.saveDeviceID(deviceID: "\(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}
