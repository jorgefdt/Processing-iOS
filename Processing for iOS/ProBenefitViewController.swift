//
//  ProBenefitViewController.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 7/7/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import UIKit

class IndexedPageViewController: UIViewController {
    var index = 0
}

class ProBenefitViewController: IndexedPageViewController {

    @IBOutlet weak var headingTitleLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    let benefitTitles = [
        "Export your Processing Projects as Apps on your home screen!",
        "Processing analyzes your code and tells you what‘s causing the bug!",
        "Support the further development of this app!"
    ]
    
    let benefitDescriptions = [
        "With Processing Pro, you can support the further development of this app and get access to many exclusive features, such as exporting your sketches as apps!",
        "Processing Pro can now analyze your code and tells you where the problem is. That makes programming even more fun and enjoyable!",
        "Supporting this app financially helps a lot to spend more time on working on updates and adding new features."
    ]
    
    let benefitImageNames = [
        "export_upsell",
        "bug_fixer_screenshot",
        "education"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingTitleLabel.text = benefitTitles[index]
        descriptionTitleLabel.text = benefitDescriptions[index]
        imageView.image = UIImage(named: benefitImageNames[index])
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
