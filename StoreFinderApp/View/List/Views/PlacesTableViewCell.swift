//
//  PlacesTableViewCell.swift
//  StoreFinderApp
//
//  Created by Mac User on 8/3/19.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit
import AlamofireImage

class PlacesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placesImageView: UIImageView!
    @IBOutlet weak var makerImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        }

//         Configure the view for the selected state
    

    func configure(with viewModel: PlacesListViewModel) {
        placesImageView.af_setImage(withURL: viewModel.imageUrl)
        placeNameLabel.text = viewModel.name
        locationLabel.text = viewModel.formattedDistance
    }
    
}
