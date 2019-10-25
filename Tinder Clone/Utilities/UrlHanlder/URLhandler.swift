
//
//  URLhandler.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.

import Foundation
import UIKit
import Alamofire
class URLhandler
{
    static let Sharedinstance = URLhandler()
    let sessionManager = SessionManager()
    private  var previousProgress:Float=0
    private var callback:GetProgress?
    var Appdel = UIApplication.shared.delegate as! AppDelegate
    func setCallBack(callback:GetProgress){
        self.callback=callback
    }
    func Getcall(Url:String,param:[String:String],completionHandler: @escaping(_ responseObject: NSDictionary?,_ error:Error?)->())
    {
        completionHandler(nil,nil)
    }
    func makeCall(url: NSString,param:[String:Any],_method:HTTPMethod,completionHandler: @escaping (_ responseObject: NSDictionary?,_ error:Error? ) -> ())
        
    {
        var Dictionay:NSDictionary?=NSDictionary()
        print("the dict is \(param) response is  url is \(url)")
         if(Appdel.isnetWorkConnected)
        {
            let Header:HTTPHeaders = [:]
            
            
            Alamofire.request(url as String, method: _method, parameters:param,headers:Header).responseJSON { (response) in
                print(response.request)
                print(response.error)
                if(response.error == nil)
                {
                    print("the dict is \(String(describing: param)) response is \(response) url is \(url)")
                    do {

                             let responseDict = try JSONSerialization.jsonObject(
                            
                            with: response.data!,
                            
                            options: JSONSerialization.ReadingOptions.mutableContainers
                             ) as? NSDictionary
                        let error:String = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "error") as AnyObject)
                        if(error == "token_expired") || (error == "user_not_found") {
                            DatabaseHandler.sharedinstance.truncateDataForTable(tableName: Constant.sharedinstance.User_details)
                            Themes.sharedIntance.ClearUSerDetails()
                            self.Appdel.MovetoRoot(status: "login")
                            return
                        }
                        
                        if (responseDict!["status_message"] as! String) == "Token Expired" {
                            
                            Themes.sharedIntance.saveaccesstoken(userid: (responseDict!["refresh_token"] as! String))
                            var newParam = param
                            newParam["token"] = Themes.sharedIntance.getaccesstoken()!
                            self.makeCall(url: url, param: newParam, _method: _method, completionHandler: completionHandler)
                            
                        }
                        
                        if (responseDict!["status_message"] as! String) == "Inactive User" {
                            DatabaseHandler.sharedinstance.truncateDataForTable(tableName: Constant.sharedinstance.User_details)
                            Themes.sharedIntance.ClearUSerDetails()
                            self.Appdel.MovetoRoot(status: "login")
                        }
                        
                        let error1:String = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "error") as AnyObject)
                        if(error1 == "token_expired")
                        {
                            Dictionay=nil
                            
                            
                            
                            


                        }
                        else
                        {
                        StaticData.UserData=response.data
                         completionHandler(responseDict as NSDictionary?, response.error)
                        }
                    }
                    catch let error as NSError {
                         print("A JSON parsing error occurred, here are the details:\n \(error)")
                        Dictionay=nil
                        completionHandler(Dictionay as NSDictionary?, error )
                     }
                 }else{
                    Dictionay = nil
                    print(response)
                    let errs=response as? URLError
                    if errs?.code == .notConnectedToInternet{
                    let err = NSError(domain: "Please check your internet connection", code: 401, userInfo: nil)
                    completionHandler(Dictionay as NSDictionary?, err )
                    }
                }
                
                
            }
            
        }
            
        else
            
        {
            Dictionay = nil
            let err = NSError(domain: "Please check your internet connection", code: 401, userInfo: nil)
             completionHandler(Dictionay as NSDictionary?, err )
            if(err.code==401){
//                ValidationHandler.sharedIntance.showErrorOnStatusBar(msg : err.domain)
            }
            
        }
        
        
    }
    
    
    func uploadImage(urlString:NSString, parameters:[String:String], imgData:NSData,completionHandler: @escaping (_ responseObject: NSDictionary?,_ error:Error? ) -> ())
    {
        // create url request to send
        var Dictionay:NSDictionary?=NSDictionary()
        print(parameters)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imgData as Data, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                            for (key, value) in parameters {
                                multipartFormData.append(value.data(using: .utf8, allowLossyConversion: false)!, withName: key)
                            }
        },
            to: urlString as String,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        Dictionay = response.result.value as? NSDictionary

                                             completionHandler(Dictionay as NSDictionary?, response.error )
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    Dictionay = nil
                                    completionHandler(Dictionay as NSDictionary?, encodingError ) as! Error
                                    break
                 }
        }
        )

        
    }

    func imageUpload(urlString:NSString, parameters:[String:String], imgData:NSData,completionHandler: @escaping (_ responseObject: NSDictionary?,_ error:Error? ) -> ())
    {
        // create url request to send
        var Dictionay:NSDictionary?=NSDictionary()
        print(parameters)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imgData as Data, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8, allowLossyConversion: false)!, withName: key)
                }
        },
            to: urlString as String,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress{ progress in
                        if (Float(progress.fractionCompleted)*100 - self.previousProgress) > 1{
                            self.callback?.setProgress(progress: Float(progress.fractionCompleted)*100)
                            self.previousProgress=Float(progress.fractionCompleted)*100
                        }
                        else if progress.fractionCompleted == 1{
                            self.callback?.setProgress(progress: 100)
                        }

                    }
                    upload.responseJSON { response in
                        debugPrint(response)
                        Dictionay = response.result.value as? NSDictionary
                        
                        completionHandler(Dictionay as NSDictionary?, response.error )
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    Dictionay = nil
                    completionHandler(Dictionay as NSDictionary?, encodingError ) as! Error
                    break
                }
        }
        )
        
        
    }
    
}
protocol GetProgress {
    func setProgress(progress:Float)
}













