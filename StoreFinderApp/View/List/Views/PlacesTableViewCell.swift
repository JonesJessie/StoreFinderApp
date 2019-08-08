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
    @IBOutlet weak var heartButton: UIButton!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        }

    
    //MARK - STRUGGLING TO PERSIST TO DEFAULTS JUST TO HAVE A FILLED IN HEART APPEAR WHEN NEAR LOCATION USER MAY HAVE ATE AT AND "FAVORITED" AND MAY SEE AGAIN WHEN NEXT IN THE AREA
    @IBAction func heartButtonPressed(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        heartButton.tintColor = isSelected ? UIColor.lightGray : .red
        if let heartButton = sender as? UIButton {
            if heartButton.isSelected {
                heartButton.isSelected = true
                UserDefaults.standard.set(true, forKey: "Favs")
                UserDefaults.standard.synchronize()
            } else {
                heartButton.isSelected = false
                UserDefaults.standard.set(false, forKey: "Favs")
                UserDefaults.standard.synchronize()
            }
        }
//        heartButton.addTarget(self, action: #selector(getter: self.heartButton), for: .touchUpInside)
//        heartButton.isSelected = UserDefaults.standard.bool(forKey: "isSaved")
//        sender.isSelected = !sender.isSelected
//        UserDefaults.standard.set(sender.isSelected, forKey: "isSaved")
//        heartButton.tintColor = isSelected ? UIColor.lightGray : .red
    }
//         Configure the view for the selected state
    

    func configure(with viewModel: PlacesListViewModel) {
        placesImageView.af_setImage(withURL: viewModel.imageUrl)
        placeNameLabel.text = viewModel.name
        locationLabel.text = viewModel.formattedDistance
    }
    
}
