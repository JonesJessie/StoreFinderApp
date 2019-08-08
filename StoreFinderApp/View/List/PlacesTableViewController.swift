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
        if Reachability.isConnectedToNetwork() == true
        {
            print("Connected")
        } else {
            showAlert(title: "Cannot connect to Internet", message: "Device does not have internet connection, check to make sure the device is connected and try again.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserDefaults.standard.set(true, forKey: "tempstored")
        UserDefaults.standard.synchronize()
        return viewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesCell", for: indexPath) as! PlacesTableViewCell
        let vm = viewModels[indexPath.row]
        cell.configure(with: vm)


        return cell
    }
    
    func deleteArrayItem(index: Int) {
        viewModels.remove(at: index)
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.viewModels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.set(false, forKey: "tempstored")
            UserDefaults.standard.synchronize()
            print(self.viewModels)
        }
        return[delete]
    }
    
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") else {return}
        navigationController?.pushViewController(detailsViewController, animated: true)
        let vm = viewModels[indexPath.row]
        delegete?.didTapCell(detailsViewController, viewModel: vm)
    }
}
