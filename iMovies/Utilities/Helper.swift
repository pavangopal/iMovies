//
//  Helper.swift
//  Workbox
//
//  Created by Ratan D K on 07/12/15.
//  Copyright © 2015 Incture Technologies. All rights reserved.
//

import UIKit
import CoreData

class Helper {
    class func urlEncode(string: String) -> String {
        let encodedURL = string.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        return encodedURL
    }
    
    class func nsurlFromString(urlString: String? ) -> NSURL? {
        guard let unwrappedUrlString = urlString where unwrappedUrlString.characters.count > 0 else{
            return nil
        }
        let url = NSURL(string: "\(unwrappedUrlString)")
        return url;
    }

    class func lengthOfStringWithoutSpace(string:String?) -> Int {
        guard let text = string else {
            return 0
        }
        
        let trimmedText = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return trimmedText.characters.count
    }
}


