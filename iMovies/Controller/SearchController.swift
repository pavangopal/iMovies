//
//  SearchController.swift
//  iMovies
//
//  Created by Incture Mac on 08/08/16.
//  Copyright © 2016 Incture Mac. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var searchedMovie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension SearchController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Helper.lengthOfStringWithoutSpace(searchedMovie?.title) == 0 {
            return 0
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeueReusableCellWithIdentifier(String(SearchCell), forIndexPath: indexPath) as! SearchCell
        
        
        searchCell.updateDetailCell(searchedMovie)
        
        return searchCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(String(DetailController)) as! DetailController
        let nc = UINavigationController.init(rootViewController: detailController)
        if let unwrappedDataDict = searchedMovie?.dataDict{
            detailController.dataDict  = NSKeyedUnarchiver.unarchiveObjectWithData(unwrappedDataDict) as? NSDictionary
        }
        detailController.isPushed = false
        presentViewController(nc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search Result"
    }
}