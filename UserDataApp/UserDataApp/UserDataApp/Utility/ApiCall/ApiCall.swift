//
//  ApiCall.swift
//  ApiCallWithDecodable
//
//  Created by datt on 12/06/18.
//  Copyright © 2018 datt. All rights reserved.
//

import UIKit
import UserDataAppBase

#if DEBUG
let isDebug = true
#else
let isDebug = false
#endif

public enum ApiCallResult<Value> {
    case success(Value)
    case error(Error?)
}


class ApiCall: NSObject {
    
    let constValueField = "application/json"
    let constHeaderField = "Content-Type"
    
    var observationLoaderView: NSKeyValueObservation?
    
    func post<T : Decodable ,A>(apiUrl : String, params: [String: A], model: T.Type, isLoader : Bool = true , loaderInView : UIView? = nil, isErrorToast : Bool = true , completion: @escaping (ApiCallResult<T>) -> ()) {
        requestMethod(apiUrl: apiUrl, params: params as [String : AnyObject], method: "POST", model: model , isLoader : isLoader , loaderInView : loaderInView , isErrorToast : isErrorToast , completion: completion)
    }
    
    func put<T : Decodable ,A>(apiUrl : String, params: [String: A], model: T.Type, isLoader : Bool = true, isErrorToast : Bool = true , completion: @escaping (ApiCallResult<T>) -> ()) {
        requestMethod(apiUrl:apiUrl, params: params as [String : AnyObject], method: "PUT",model: model , isLoader : isLoader , isErrorToast : isErrorToast ,  completion: completion)
    }
    
    func get<T : Decodable>(apiUrl : String, model: T.Type , isLoader : Bool = true , loaderInView : UIView? = nil , isErrorToast : Bool = true , completion: @escaping (ApiCallResult<T>) -> ()) {
        requestMethod(apiUrl: apiUrl, params: [:], method: "GET", model: model , isLoader : isLoader , loaderInView : loaderInView , isErrorToast : isErrorToast , completion: completion)
    }
    
    func requestMethod<T : Decodable>(apiUrl : String, params: [String: Any], method: NSString, model: T.Type ,isLoader : Bool = true , loaderInView : UIView? = nil, isErrorToast : Bool = true , completion: @escaping (ApiCallResult<T>) -> ()) {
        
        guard case ConnectionCheck.isConnectedToNetwork() = true else {
            UIApplication.topViewController()?.view.makeToast(AlertMessage.networkConnection)
            let userInfo: [String : Any] =
            [ NSLocalizedDescriptionKey :  NSLocalizedString("error", value: AlertMessage.networkConnection, comment: "") ,
       NSLocalizedFailureReasonErrorKey : NSLocalizedString("error", value: AlertMessage.networkConnection, comment: "")]
            mainThread { completion(.error(NSError(domain: "API Call", code: 502, userInfo: userInfo))) }
            return
        }
        var loaderView : UIView?
        if isLoader {
            if var view = loaderInView {
                self.addLoaderInView(&view, loaderView:&loaderView)
            }
        }
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = method as String
        request.setValue(constValueField, forHTTPHeaderField: constHeaderField)
        
        if !params.isEmpty {
            let jsonTodo: Data
            do {
                jsonTodo = try JSONSerialization.data(withJSONObject: params, options: [])
                if method != "GET" {
                    request.httpBody = jsonTodo
                }
            } catch {
                print("Error: cannot create JSON from todo")
                return
            }
        }
        let context = appDelegate.persistentContainer.newBackgroundContext()
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with : request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            delayWithSeconds(0.1) {
                if let loaderView = loaderView {
                    loaderView.removeFromSuperview()
                }
            }
            
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            
            let decoder = JSONDecoder()
            do {
                if isDebug , let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(convertedJsonIntoDict)
                }
                
                decoder.userInfo[CodingUserInfoKey.context!] = context
                let dictResponsee = try decoder.decode(model, from: data )
                try context.save()
                mainThread {
                    completion(.success(dictResponsee))
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
                mainThread {
                    completion(.error(error))
                }
            }
        })
        task.resume()
    }
    
    func addLoaderInView(_ view: inout UIView, loaderView : inout UIView?) {
        loaderView = UIView(frame: view.bounds)
        loaderView?.backgroundColor = getBGColor(view)
        let activityIndicator = UIActivityIndicatorView()
        if view.h < 100 || view.w < 100 {
            activityIndicator.style = .medium
        } else {
            activityIndicator.style = .large
        }
        
        activityIndicator.color = .lightGray
        activityIndicator.startAnimating()
        loaderView?.addSubview(activityIndicator)
        activityIndicator.anchorCenterSuperview()
        view.addSubview(loaderView!)
        observationLoaderView = view.observe(\UIView.frame, options: .new) {
            [weak loaderView] view, change in
            if let value =  change.newValue {
                loaderView?.frame = value
            }
        }
    }
    func getBGColor(_ view : UIView?) -> UIColor {
        guard let view = view  else {
            return .white
        }
        guard let bgColor = view.backgroundColor else {
            return getBGColor(view.superview)
        }
        return bgColor == .clear ? getBGColor(view.superview) : (bgColor.rgba.alpha == 1 ? bgColor : bgColor.withAlphaComponent(1))
    }
}

