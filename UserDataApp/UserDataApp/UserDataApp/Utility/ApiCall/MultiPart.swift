//
//  MultiPart.swift
//  MultiPartSwift
//
//  Created by datt on 13/02/18.
//  Copyright © 2018 Datt. All rights reserved.
//

import UIKit
import MobileCoreServices
import UserDataAppBase

public class MultiPart: NSObject {
    
    public static let fieldName = "fieldName"
    public static let pathURLs = "pathURL"
    var observationLoaderView: NSKeyValueObservation?
    var session: URLSession?
    public func callPostWebService(_ url_String: String, parameetrs: [String: Any]?, filePathArr arrFilePath: [[String:Any]]?, completion: @escaping ([String: Any]?, Error?)->()) {
        
        let boundary = generateBoundaryString()
        
        // configure the request
        let request = NSMutableURLRequest(url: URL(string: url_String)!)
        request.httpMethod = "POST"
        
        // set content type
        let contentType = "multipart/form-data; boundary=\(boundary)"
        //        request.setValue("asdkjfklaj;fl;afnsvjafds", forHTTPHeaderField: "Authorization")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create body
        let httpBody: Data? = createBody(withBoundary: boundary, parameters: parameetrs, paths: arrFilePath)
        session = URLSession.shared
        
        let task = session?.uploadTask(with: request as URLRequest, from: httpBody, completionHandler: {(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void in
            if error != nil {
                print("error = \(error ?? 0 as! Error)")
                DispatchQueue.main.async(execute: {() -> Void in
                    completion( nil , error)
                })
                return
            }
            let user = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            DispatchQueue.main.async(execute: {() -> Void in
                if let user = user {
                    completion(user, nil)
                } else {
                    completion( nil , error)
                }
            })
        })
        task?.resume()
    }
    public func callPostWSWithModel<T : Decodable>(_ url_String: String, parameters: [String: Any], filePathArr arrFilePath: [[String:Any]]?, model : T.Type, isLoader : Bool = true , loaderInView : UIView? = nil, completion: @escaping (ApiCallResult<T>)->()) {
        
        var loaderView : UIView?
        if isLoader {
            if var view = loaderInView {
                self.addLoaderInView(&view, loaderView:&loaderView)
            }
        }
        
        let boundary = generateBoundaryString()
        
        // configure the request
        let request = NSMutableURLRequest(url: URL(string: url_String)!)
        request.httpMethod = "POST"
        
        // set content type
        let contentType = "multipart/form-data; boundary=\(boundary)"
        //        request.setValue("asdkjfklaj;fl;afnsvjafds", forHTTPHeaderField: "Authorization")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let params = parameters
        // create body
        let httpBody: Data? = createBody(withBoundary: boundary, parameters: params, paths: arrFilePath)
        session = URLSession.shared
        
        let task = session?.uploadTask(with: request as URLRequest, from: httpBody, completionHandler: {(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void in
            
            delayWithSeconds(0.1) {
                if let loaderView = loaderView {
                    mainThread { loaderView.removeFromSuperview() }
                }
            }
            
            if error != nil {
                print("error = \(String(describing: error))")
                DispatchQueue.main.async(execute: {() -> Void in
                    completion(.error(error))
                })
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        print(convertedJsonIntoDict)
                    }
                    
                    let dictResponsee = try decoder.decode(model, from: data )
                    mainThread {
                        completion(.success(dictResponsee))
                    }
                    
                } catch {
                    debugPrint(error.localizedDescription)
                    mainThread {
                        completion(.error(error))
                    }
                }
            }
        })
        task?.resume()
    }
    fileprivate func createBody(withBoundary boundary: String, parameters: [String: Any]?, paths: [[String:Any]]?) -> Data {
        var httpBody = Data()
        
        // add params (all params are strings)
        if let parameters = parameters {
            for (parameterKey, parameterValue) in parameters {
                if let arr = parameterValue as? [AnyObject]  {
                    for i in 0 ..< arr.count {
                        httpBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        httpBody.append("Content-Disposition: form-data; name=\"\(parameterKey)[]\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                        httpBody.append("\(arr[i])\r\n".data(using: String.Encoding.utf8)!)
                    }
                } else {
                    httpBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    httpBody.append("Content-Disposition: form-data; name=\"\(parameterKey)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                    httpBody.append("\(parameterValue)\r\n".data(using: String.Encoding.utf8)!)
                }
            }
        }
        
        // add File data
        if let paths = paths {
            for pathDic in paths {
                for path: String in pathDic[MultiPart.pathURLs] as! [String] {
                    let filename: String = URL(fileURLWithPath: path).lastPathComponent
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path))
                        
                        let mimetype: String = mimeType(forPath: path)
                        httpBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        httpBody.append("Content-Disposition: form-data; name=\"\(pathDic[MultiPart.fieldName] ?? "")\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
                        httpBody.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                        httpBody.append(data)
                        httpBody.append("\r\n".data(using: String.Encoding.utf8)!)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
            }
        }
        httpBody.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        return httpBody
    }
    fileprivate func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    fileprivate func mimeType(forPath path: String) -> String {
        // get a mime type for an extension using MobileCoreServices.framework
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
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
        observationLoaderView = view.observe(\UIView.bounds, options: .new) { [weak loaderView] view, change in
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
