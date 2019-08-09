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
import CoreData

class DetailsPlacesViewController: UIViewController {

    
    @IBOutlet weak var detailsPlacesView: DetailsPlacesView?

    
    var viewModel: DetailsViewModel? {
        didSet {
            updateView()
        }
    }
    
    var likes = [Liked]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        detailsPlacesView?.collectionView?.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        detailsPlacesView?.collectionView?.dataSource = self
        detailsPlacesView?.collectionView?.delegate = self
        likes = fetchHearts()
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
    
    func fetchHearts() -> [Liked] {
//        showSpinner()
        let fetchRequest: NSFetchRequest<Liked> = Liked.fetchRequest()
        do {
            let result = try DataController.shared.viewContext.fetch(fetchRequest)
            likes = result
//            hideSpinner()
        } catch {
            print(error)
//            hideSpinner()
        }
        for like in likes {
            if like.name == title {
                detailsPlacesView?.addToFavoritesButton.isSelected = true
            }
        }
        return likes
    }
    
    @IBAction func addOrDeleteFavorite(_ sender: UIButton) {
            let liked: Liked = Liked(context: DataController.shared.viewContext)
        detailsPlacesView!.addToFavoritesButton.isSelected = !detailsPlacesView!.addToFavoritesButton.isSelected
            if detailsPlacesView!.addToFavoritesButton.isSelected {
                liked.name = title
                liked.heartPressed = true
                do {
                    try DataController.shared.viewContext.save()
                } catch {
                    showAlert(title: "Sorry", message: "Error while trying to Like.")
                }
                self.likes.append(liked)
            } else {
                for liked in likes {
                    if liked.name == title {
                        liked.heartPressed = false
                        DataController.shared.viewContext.delete(liked)
                    }
                }
                do {
                    try DataController.shared.viewContext.save()
                } catch {
                    showAlert(title: "Sorry", message: "Error while to remove Like.")
                }
            }
    }
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
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
