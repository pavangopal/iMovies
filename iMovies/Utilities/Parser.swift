//
//  Parser.swift
//  Workbox
//
//  Created by Ratan D K on 08/12/15.
//  Copyright © 2015 Incture Technologies. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class Parser {

    //MARK: CORE DATA

    class func movieForDictionary(dict: NSDictionary) -> Movie? {
        
        guard let response = dict["Response"] as? String where response == kServerKeyTrue else{
            return nil
        }
        
        guard let id = dict["imdbID"] else {
            return nil
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let predicate = NSPredicate(format: "id = %@", argumentArray: [id])
        let newObject = coreDataObjectForPredicate(predicate, entityName: String(Movie)) as! Movie
        
        newObject.id = id as? String
        newObject.poster = dict.valueForKey("Poster") as? String
        newObject.title = dict.valueForKey("Title") as? String
        newObject.dataDict = NSKeyedArchiver.archivedDataWithRootObject(dict)

        var optionalDate : NSDate?
        optionalDate = NSDate()
        newObject.updatedAt = optionalDate
        
        do {
            try appDelegate.managedObjectContext.save()
        } catch let error {
            print("Coredata error: \(error)")
        }
        
        return newObject
        
    }
    
    class func coreDataObjectForPredicate(predicate: NSPredicate, entityName: String) -> AnyObject {
        
        let fetchRequest = NSFetchRequest(entityName:entityName)
        fetchRequest.predicate = predicate
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var result: NSArray?
        
        do {
            result = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        // Return that eobject if already exists or create a new one
        if result?.count > 0 {
            let object: NSManagedObject = result?.firstObject as! NSManagedObject
            return object
        }else{
            return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: appDelegate.managedObjectContext)
        }
    }
    
    // Not really needed
    class func fetchMovie(forId forId : String) -> Movie?{
        let fetchRequest = NSFetchRequest(entityName: String(Movie))
        
        let predicateForId = NSPredicate(format: "id = %@", argumentArray: [forId])
        
        fetchRequest.predicate = predicateForId
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var result: NSArray?
        do {
            result = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        guard let unwrappedResult = result where unwrappedResult.count > 0  else{
            print("workitemArray is empty")
            return nil
        }
        guard let unwrappedWorkitemData = unwrappedResult.firstObject as? Movie else{
            print("unwrappedworkitem is empty")
            return nil
        }
        
        return unwrappedWorkitemData
        
    }
    
    class func fetchAllSearchedMovies() -> [Movie]{
        let fetchRequest = NSFetchRequest(entityName: String(Movie))
        var workitemArray = [Movie]()
        

        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var result: NSArray?
        do {
            result = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        guard let unwrappedResult = result where unwrappedResult.count > 0  else{
            print("unwrappedResult is empty")
            return workitemArray
        }
        
        for workitem in unwrappedResult{
            if let workitemElement = workitem as? Movie{
                workitemArray.append(workitemElement)
            }
            
        }
        
        return workitemArray
    }

}
