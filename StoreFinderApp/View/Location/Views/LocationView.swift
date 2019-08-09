//
//  LocationView.swift
//  StoreFinderApp
//
//  Created by Mac User on 8/3/19.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable class LocationView: BaseView {

    @IBOutlet weak var allowButton: UIButton!
    
    
    var didTapAllow: (() -> Void)?
    
    @IBAction func allowAction(_ sender: UIButton) {
        didTapAllow?()
    }
    
}


