//
//  Router.swift
//  Workbox
//
//  Created by Ratan D K on 23/12/15.
//  Copyright © 2015 Incture Technologies. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = ConstantServer.apiURL
    
    case GetMovie(text:String)
    
    var method: Alamofire.Method {
        switch self {
    
        default:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .GetMovie(let name):
            return "/?t=\(name)&plot=full&r=json"
       
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        guard let URL = NSURL(string: Router.baseURLString) else{
            print("DEADLY ERROR : URL CREATION FAILED")
            return NSMutableURLRequest()

        }
        
        guard let url = NSURL(string: "\(Helper.urlEncode(path))", relativeToURL:URL) else{
            print("DEADLY ERROR : PATH CREATION FAILED")
            return NSMutableURLRequest()
        }
        
        let mutableURLRequest = NSMutableURLRequest(URL: url)
        mutableURLRequest.HTTPMethod = method.rawValue
  
        
        switch self {
            
              default:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        }
    }
}

