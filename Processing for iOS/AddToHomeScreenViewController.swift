//
//  AddToHomeScreenViewController.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/11/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import UIKit

class AddToHomeScreenViewController: UIViewController {

    @IBOutlet weak var continueInSafariButton: ActivityButton!
    @objc var project: SimpleTextProject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueInSafariButton.layer.cornerRadius = 16
        
        // Do any additional setup after loading the view.
    }

    @IBAction func openSafari(_ sender: Any) {
        if let project = project {
            HomeScreenSharer.share(sketch: project)
        }
        
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
}
