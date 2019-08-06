//
//  DetailsPlacesViewController.swift
//  StoreFinderApp
//
//  Created by Mac User on 8/3/19.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit
import AlamofireImage
import MapKit
import CoreLocation

class DetailsPlacesViewController: UIViewController {

    
    @IBOutlet weak var detailsPlacesView: DetailsPlacesView?
    var viewModel: DetailsViewModel? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailsPlacesView?.collectionView?.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        detailsPlacesView?.collectionView?.dataSource = self
        detailsPlacesView?.collectionView?.delegate = self
    }

    func updateView() {
        if let viewModel = viewModel {
            detailsPlacesView?.priceLabel?.text = viewModel.price
            detailsPlacesView?.hoursLabel?.text = viewModel.isOpen
            detailsPlacesView?.locationLabel?.text = viewModel.phoneNumber
            detailsPlacesView?.ratingsLabel?.text = viewModel.rating
            detailsPlacesView?.collectionView?.reloadData()
            centerMap(for: viewModel.coordinate)
            title = viewModel.name
        }
    }
    
    func centerMap(for coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 150, longitudinalMeters: 150)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        detailsPlacesView?.mapView?.addAnnotation(annotation)
        detailsPlacesView?.mapView?.setRegion(region, animated: true)
    }
}

extension DetailsPlacesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.imageUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! DetailsCollectionViewCell
        if let url = viewModel?.imageUrls[indexPath.item] {
            cell.imageView.af_setImage(withURL: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        detailsPlacesView?.pageControl?.currentPage = indexPath.item
    }
}
