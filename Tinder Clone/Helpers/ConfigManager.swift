//
//  Preferences.swift
//  Igniter
//
//  Created by Rana Asad on 25/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import Foundation
public class ConfigManager{
    
    private var preferences:UserDefaults;
    private static var instance = ConfigManager();
    
    init() {
        preferences=UserDefaults.standard;
    }
    public static func getInstance()->ConfigManager{
        return instance
    }
    public func setFirst(value:String){
        preferences.set(value, forKey: ConfigKeys.ISFIRST)
        preferences.synchronize()
    }
    public func isFirst()->String{
        let isFirst=preferences.object(forKey: ConfigKeys.ISFIRST)
        return isFirst as! String
    }
    public func getFirstTap()->String?{
        let isFirst=preferences.object(forKey: ConfigKeys.FIRSTTAp)
        return isFirst as? String
    }
    public func setFirstTap(value:String){
        preferences.set(value, forKey: ConfigKeys.FIRSTTAp)
        preferences.synchronize()
    }
    public func getFirstLike()->String?{
        let isFirst=preferences.object(forKey: ConfigKeys.FIRSTTIME)
        return isFirst as? String
    }
    public func setFirstLike(value:String){
        preferences.set(value, forKey: ConfigKeys.FIRSTTIME)
        preferences.synchronize()
    }
    public func setData(value:Data){
        preferences.set(value, forKey: ConfigKeys.USERDATA)
        preferences.synchronize()
    }
    public func getData()->Data?{
        let isFirst=preferences.object(forKey: ConfigKeys.USERDATA)
        return isFirst as? Data
    }
    public func setPlans(value:Data){
        preferences.set(value, forKey: ConfigKeys.PLANSDATA)
        preferences.synchronize()
    }
    public func getPlans()->Data?{
        let isFirst=preferences.object(forKey: ConfigKeys.PLANSDATA)
        return isFirst as? Data
    }
    func imageForKey() -> UIImage? {
        var image: UIImage?
        if let imageData = preferences.object(forKey: ConfigKeys.IMAGE) {
            image = NSKeyedUnarchiver.unarchiveObject(with: imageData as! Data) as? UIImage
        }
        return image
    }
    public func setImageUpload(value:String){
        preferences.set(value, forKey: "Image")
    }
    public func getImageUpload()->String?{
        return preferences.object(forKey: "Image") as? String
    }
    public func setImage(image:UIImage){
        var imageData: Data?
        imageData = NSKeyedArchiver.archivedData(withRootObject: image) as Data?
        preferences.set(imageData, forKey: ConfigKeys.IMAGE)
    }
    private class ConfigKeys{
        static let ISFIRST="first"
        static let USERDATA="data"
        static let PLANSDATA="plans"
        static let IMAGE="image"
        static let FIRSTTAp="tap"
        static let FIRSTTIME="time"
       
    }
}

