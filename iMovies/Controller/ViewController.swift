//
//  ViewController.swift
//  iMovies
//
//  Created by Incture Mac on 08/08/16.
//  Copyright © 2016 Incture Mac. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    
    var searchController: UISearchController!
    var resultsTableController: SearchController!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchController()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setSearchController(){
        resultsTableController = SearchController()
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search People"
        searchController.searchBar.sizeToFit()
        //        searchController.searchBar.barTintColor = ConstantColor.CWLightGray
        //        searchController.searchBar.tintColor = ConstantColor.CWLightGray
        //        searchController.searchBar.backgroundColor = ConstantColor.CWLightGray
        
        
        
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = true // default is YES
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        /*
         Search is now just presenting a view controller. As such, normal view controller
         presentation semantics apply. Namely that presentation will walk up the view controller
         hierarchy until it finds the root view controller or one that defines a presentation context.
         */
        definesPresentationContext = true
        self.tableView.contentOffset = CGPointMake(0, self.searchController.searchBar.bounds.size.height);
        
        
    }
}

//MARK: - Search Controller
extension ViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {

        guard let searchText = searchController.searchBar.text?.lowercaseString else{
            return
        }
        downloadAndDisplaySearchedMovie(searchText)
    }
    func downloadAndDisplaySearchedMovie(searchString : String) {
          Alamofire.request(Router.GetMovie(text: searchString)).responseJSON { response in
            
            switch response.result {
            case .Success(let JSON):
                guard let jsonData = JSON as? NSDictionary else{
                    print("Incorrect JSON from server : \(JSON)")
                    return
                }
                guard jsonData[kServerKeyResponse]?.lowercaseString == kServerKeyTrue else{
                    var message = jsonData[kServerKeyError]?.lowercaseString
                    #function
                    let alertController = UIAlertController.init(title: kServerKeyError, message:message , preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction.init(title: kOkString, style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    
                    print("Error Occured: JSON Without success")
                    return
                }
                
              
                

                let resultsController = self.searchController.searchResultsController as! SearchController
             
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

}
