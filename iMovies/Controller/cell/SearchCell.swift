//
//  SearchCell.swift
//  iMovies
//
//  Created by Incture Mac on 08/08/16.
//  Copyright © 2016 Incture Mac. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateDetailCell(searchedMovie:Movie?){
        if let unwrappedSearchedMovie = searchedMovie{
        moviePosterImageView.setImageWithOptionalUrl(Helper.nsurlFromString(unwrappedSearchedMovie.poster),placeholderImage: AssetImage.moviePlaceHolderImage.image)
            movieTitle.text = unwrappedSearchedMovie.title
        }
    }
}
