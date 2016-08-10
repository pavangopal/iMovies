//
//  DetailController.swift
//  iMovies
//
//  Created by Incture Mac on 08/08/16.
//  Copyright © 2016 Incture Mac. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var isPushed = true
    var kSections = 4
    var dataDict : NSDictionary?
    var generalSectionKeys : [String]?
    var castSectionkeys : [String]?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        setupNavigationBar() 
        formatHeaderViewUI()
       
        createKeyArrays()

     
        // Do any additional setup after loading the view.
    }
    
    func createKeyArrays(){
         generalSectionKeys = ["Released","Runtime","Language","Genre"]
         castSectionkeys = ["Actors","Director","Writer"]
    }
    
    func formatHeaderViewUI(){
        if let unwrappedSearchedMovie = dataDict{
            posterImageView.setImageWithOptionalUrl(Helper.nsurlFromString(unwrappedSearchedMovie[kposter] as? String),placeholderImage: AssetImage.moviePlaceHolderImage.image)
            backgroundImageView.setImageWithOptionalUrl(Helper.nsurlFromString(unwrappedSearchedMovie[kposter] as? String),placeholderImage: AssetImage.moviePlaceHolderImage.image)
            createBlurEffect()
            ratingView.clipToCircularCornerWithRadius(4)
            ratingLabel.text = getRatingInPercent(unwrappedSearchedMovie[kimdbRating] as? String) + "%"
            votesLabel.text = ((unwrappedSearchedMovie[kimdbVotes] as? String) ?? kSpaceString ) + " votes"
        }
    }
    
    func getRatingInPercent(rating:String?) -> String{
        return String(((Float(rating ?? "0") ?? 0) * 10))
        
        
    }
    
    func setupNavigationBar(){
        if !isPushed{
        self.navigationController?.setupNavigationBar()
        
        let closeControllerNavBarItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(self.closeButtonPressed))
        self.navigationItem.leftBarButtonItem = closeControllerNavBarItem
        }
        navigationItem.title = (dataDict?[ktitle] as? String)

    }
    
    func closeButtonPressed(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createBlurEffect(){
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        // for supporting device rotation
        backgroundImageView.alpha = 0.01
        backgroundImageView.addSubview(blurEffectView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension DetailController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return kSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return generalSectionKeys?.count ?? 0
        case 1:
            return castSectionkeys?.count ?? 0
        case 2:
            return 1
        case 3 :
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 3{
            let synopsisCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SynopsisCell")!
                synopsisCell.textLabel?.text = dataDict?[kplot] as? String
            return synopsisCell
            
        }else{
        let movieDeatilCell = tableView.dequeueReusableCellWithIdentifier(String(MovieDetailCell), forIndexPath: indexPath) as! MovieDetailCell
            switch indexPath.section{
            case 0:
                movieDeatilCell.updateDetailCell(generalSectionKeys?[indexPath.row], value: dataDict?[generalSectionKeys?[indexPath.row] ?? kEmptyString] as? String)

            case 1:
                movieDeatilCell.updateDetailCell(castSectionkeys?[indexPath.row], value: dataDict?[castSectionkeys?[indexPath.row] ?? kEmptyString] as? String)
            case 2:
                movieDeatilCell.updateDetailCell(kAwards, value: dataDict?[kAwards] as? String)
         
            default:
                break
                
            }
        return movieDeatilCell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "GENERAL"
        case 1:
            return "CAST"
        case 2:
            return "AWARDS"
        case 3 :
            return "SYNOPSIS"
        default:
            return kEmptyString
            
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return kheaderHeight
        case 1:
            return kheaderHeight
        case 2:
            return kheaderHeight
        case 3 :
            return kheaderHeight
        default:
            return kheaderHeight
            
        }
    }
}