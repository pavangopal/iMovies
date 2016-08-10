//
//  Extensions.swift
//  Workbox
//
//  Created by Ratan D K on 15/12/15.
//  Copyright © 2015 Incture Technologies. All rights reserved.
//

import UIKit
import Kingfisher

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
  
}

extension UIColor {
    class func navBarColor() -> UIColor {
        return UIColor(red: 35/255.0, green: 39/255.0, blue: 50/255.0, alpha:1)
    }
    
    class func navBarItemColor() -> UIColor{
        return UIColor.whiteColor()
    }
}

extension UINavigationController{
    func setupNavigationBar() {
        self.navigationBar.barTintColor = UIColor.navBarColor()
        self.navigationBar.tintColor = UIColor.navBarItemColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.navBarItemColor()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.navBarItemColor()
        self.navigationItem.titleView?.tintColor = UIColor.navBarItemColor()

    }
}


extension AssetImage {
    var image : UIImage {
        if let unwrappedImage = UIImage(named: self.rawValue){
            return unwrappedImage
        }
        else{
            return UIImage()
        }
    }
}

extension UIView {
    func clipToCircularCornerWithRadius(radius:CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }

}

extension UIImageView{
    /// Use this for setting image to any imageView using OPTIONAL url (e.g. posterUrl) and an appropriate placeholder image.
    func setImageWithOptionalUrl(url : NSURL?, placeholderImage: UIImage){
        if let unwrappedUrl = url{
            self.kf_setImageWithURL(unwrappedUrl, placeholderImage: placeholderImage)
        }
        else{
            self.image = placeholderImage
        }
    }

    func clipToCircularImageView(){
        self.layer.cornerRadius = self.bounds.width/2
        self.clipsToBounds = true
    }

}


