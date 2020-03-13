//
//  ProcessingNavigationViewController.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 5/13/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import UIKit

class ProcessingNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemBackground
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
