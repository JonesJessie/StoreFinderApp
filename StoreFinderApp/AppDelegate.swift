//
//  AppDelegate.swift
//  StoreFinderApp
//
//  Created by Mac User on 8/3/19.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit
import CoreData
import Moya
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()
    let locationService = LocationService()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    let jsonDecoder = JSONDecoder()
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DataController.shared.load()
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        locationService.didChangeStatus = { [weak self] success in
            if success {
                self?.locationService.getLocation()
            }
        }
        //
        locationService.newLocation = { [weak self] result in
            switch result {
            case .success(let location):
                self?.loadBusinesses(with: location.coordinate)
            case .failure(let error):
                assertionFailure("Error getting the users location \(error)")
            }
        }
        
        switch locationService.status {
        case .notDetermined, .denied, .restricted:
            let locationViewController = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController
            locationViewController?.delegate = self
            window.rootViewController = locationViewController
        default:
            let nav = storyboard
                .instantiateViewController(withIdentifier: "PlacesNavigationController") as? UINavigationController
            self.navigationController = nav
            window.rootViewController = nav
            locationService.getLocation()
            (nav?.topViewController as? PlacesTableViewController)?.delegete = self
        }
        window.makeKeyAndVisible()
        
        return true
    }
    
    private func loadDetails(for viewController: UIViewController, withId id: String) {
        service.request(.details(id: id)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let strongSelf = self else {return}
                if let details = try? strongSelf.jsonDecoder.decode(Details.self, from: response.data) {
                    let detailsViewModel = DetailsViewModel(details: details)
                    (viewController as? DetailsPlacesViewController)?.viewModel = detailsViewModel
                }
            case . failure(let error):
                print("Failed to get details \(error)")
            }
        }
    }
    
    private func loadBusinesses(with coordinate: CLLocationCoordinate2D) {
        service.request(.search(lat: coordinate.latitude, long: coordinate.longitude)) { [weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                
                let root = try? strongSelf.jsonDecoder.decode(Root.self, from: response.data)
                let viewModels = root?.businesses
                    .compactMap(PlacesListViewModel.init)
                    .sorted(by: { $0.distance < $1.distance })
                if let nav = strongSelf.window.rootViewController as? UINavigationController,
                    let placesListViewController = nav.topViewController as? PlacesTableViewController {
                    placesListViewController.viewModels = viewModels ?? []
                    } else if let nav = strongSelf.storyboard.instantiateViewController(withIdentifier: "PlacesNavigationController") as? UINavigationController {
                        strongSelf.navigationController = nav
                        strongSelf.window.rootViewController?.present(nav, animated: true) {
                            (nav.topViewController as? PlacesTableViewController)?.delegete = self
                            (nav.topViewController as? PlacesTableViewController)?.viewModels = viewModels ?? []
                        }
                    }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "StoreFinderApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
           
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate: LocationActions, ListActions {
    func didTapAllow() {
        locationService.requestLocationAuthorization()
    }
    func didTapCell(_ viewController: UIViewController, viewModel: PlacesListViewModel) {
        loadDetails(for: viewController, withId: viewModel.id)
    }
}
