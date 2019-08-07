//
//  RestaurantTableTableViewController.swift
//  StoreFinderApp
//
//  Created by Mac User on 8/3/19.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit

protocol ListActions: class {
    func didTapCell(_ viewController : UIViewController, viewModel: PlacesListViewModel)
}

class PlacesTableViewController: UITableViewController {
    
    
    var viewModels = [PlacesListViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegete: ListActions?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesCell", for: indexPath) as! PlacesTableViewCell
        let vm = viewModels[indexPath.row]
        cell.configure(with: vm)


        return cell
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") else {return}
        navigationController?.pushViewController(detailsViewController, animated: true)
        let vm = viewModels[indexPath.row]
        delegete?.didTapCell(detailsViewController, viewModel: vm)
    }
}
