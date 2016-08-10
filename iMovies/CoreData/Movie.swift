//
//  Movie.swift
//  
//
//  Created by Incture Mac on 08/08/16.
//
//

import Foundation
import CoreData


class Movie: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    @NSManaged var id: String? // primary key
    
    @NSManaged var title: String?
    @NSManaged var poster: String?
    @NSManaged var updatedAt: NSDate?
    @NSManaged var dataDict: NSData? // sorting


}
