//
//  ViewController.swift
//  iMovies
//
//  Created by Incture Mac on 08/08/16.
//  Copyright © 2016 Incture Mac. All rights reserved.
//

import UIKit
import Alamofire

class DashboardController: UIViewController {
    
    
    var searchController: UISearchController!
    var resultsTableController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(String(SearchController)) as! SearchController
    
    @IBOutlet weak var tableView: UITableView!
    var History : [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        setSearchController()
        self.navigationController?.setupNavigationBar()
        History = Parser.fetchAllSearchedMovies()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSearchController(){
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.navBarColor()
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = true // default is YES
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        definesPresentationContext = true
    }
}

//MARK: - Search Controller
extension DashboardController: UISearchBarDelegate, UISearchControllerDelegate{
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.lowercaseString else{
            return
        }
        downloadAndDisplaySearchedMovie(searchText)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        History = Parser.fetchAllSearchedMovies()
        tableView.reloadData()
    }
    
    
    func downloadAndDisplaySearchedMovie(searchString : String) {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.frame = CGRect(x: (view.bounds.size.width/2) - (kActivityIndicatorDimention/2), y: view.bounds.size.height/2, width: kActivityIndicatorDimention, height: kActivityIndicatorDimention)
        activityIndicator.startAnimating()
        resultsTableController.view.addSubview(activityIndicator)
        
        Alamofire.request(Router.GetMovie(text: searchString)).responseJSON { response in
            activityIndicator.stopAnimating()
            
            switch response.result {
            case .Success(let JSON):
                guard let jsonData = JSON as? NSDictionary else{
                    print("Incorrect JSON from server : \(JSON)")
                    return
                }
                guard jsonData[kServerKeyResponse] as? String == kServerKeyTrue else{
                    let message = jsonData[kServerKeyError]?.lowercaseString
                    #function
                    
                    let alertController = UIAlertController.init(title: kServerKeyError, message: message?.capitalizedString , preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction.init(title: kOkString, style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    print("Error Occured: JSON Without success")
                    return
                }
                
                let movie  = Parser.movieForDictionary(jsonData)
                
                let resultsController = self.searchController.searchResultsController as! SearchController
                resultsController.searchedMovie = movie
                resultsController.tableView.reloadData()
                
            case .Failure(let error):
                let message = error.localizedDescription
                #function
                let alertController = UIAlertController.init(title: kServerKeyError, message:message , preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction.init(title: kOkString, style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(okAction)
                print("Request failed with error: \(error)")
            }
        }
    }
}

extension DashboardController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let moviesCount = History?.count{
            if moviesCount == 0{
                return 1
            }else{
                return moviesCount
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let moviesCount = History?.count where moviesCount > 0{
            let dashboardCell = tableView.dequeueReusableCellWithIdentifier(String(DashboardCell), forIndexPath: indexPath) as! DashboardCell
            if let unwrappedMovie = History?[indexPath.row]{
                dashboardCell.updateDetailCell(unwrappedMovie)
                return dashboardCell
            }
        }
        else{
            let MessageCell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            MessageCell.textLabel?.textAlignment = .Center
            MessageCell.textLabel?.font = UIFont.systemFontOfSize(14)
            MessageCell.textLabel?.textColor = UIColor.navBarColor()
            MessageCell.textLabel?.text = "You don't have any recent search ..."
            MessageCell.accessoryType = .None
            MessageCell.userInteractionEnabled = false
            return MessageCell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(String(DetailController)) as! DetailController
        detailController.isPushed = true
        
        if let unwrappedDataDict = History?[indexPath.row].dataDict{
            detailController.dataDict  = NSKeyedUnarchiver.unarchiveObjectWithData(unwrappedDataDict) as? NSDictionary
        }
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search History"
    }
    
}