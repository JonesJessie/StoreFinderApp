//
//  DetailsPlacesView.swift
//  StoreFinderApp
//
//  Created by Mac User on 8/3/19.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit
import MapKit
import CoreData

@IBDesignable class DetailsPlacesView: BaseView {
    
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var pageControl: UIPageControl?
    @IBOutlet weak var priceLabel: UILabel?
    @IBOutlet weak var hoursLabel: UILabel?
    @IBOutlet weak var locationLabel: UILabel?
    @IBOutlet weak var ratingsLabel: UILabel?
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var addToFavoritesButton: UIButton!
    @IBAction func handleControl(_ sender: UIPageControl) {
        
        

    }

}
