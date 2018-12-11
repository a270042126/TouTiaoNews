//
//  NetworkTools.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/20.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}
class NetworkTools {

    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            finishedCallback(result)
        }
    }
    
    class func requestString(url: String, finishedCallback :  @escaping (_ result : Any) -> ()){
        Alamofire.request(url).responseString { (response) in
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            finishedCallback(result)
        }
    }
}
