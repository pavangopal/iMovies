//
//  Constants.h
//  Workbox
//
//  Created by Ratan D K on 07/12/15.
//  Copyright © 2015 Incture Technologies. All rights reserved.
//

import Foundation
import UIKit

let kheaderHeight:CGFloat = 44
let kActivityIndicatorDimention:CGFloat = 50

let kEmptyString: String = ""
let kServerKeyResponse: String = "Response"
let kServerKeyMessage: String = "message"
let kServerKeyError: String = "Error"
let kServerKeyFalse: String = "False"
let kServerKeyTrue: String = "True"
let kOkString: String = "OK"

let kSpaceString = "\u{200c}"
let kposter = "Poster"
let ktitle = "Title"
let kimdbRating = "imdbRating"
let kimdbVotes = "imdbVotes"
let kplot = "Plot"
let kAwards = "Awards"


struct ConstantServer {
    static var apiURL = "http://www.omdbapi.com"
}

//MARK: - ENUM of Assets
// Declare enum for required images here and there will be no any dependency on string named UIImage.
// Usages: imageview.image = AssetImage.ProfileImage.image

public enum AssetImage : String {
   case moviePlaceHolderImage = "placeholder"
    
}


