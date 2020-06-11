//
//  SelectAppIconViewController.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/11/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SelectAppIconViewController: UIViewController {

    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    @IBOutlet weak var continueButton: UIButton!
    
    
    @objc var project: PDESketch?
    
    let availableColors = [
        UIColor.systemRed,
        UIColor.systemOrange,
        UIColor.systemYellow,
        UIColor.systemBlue,
        UIColor.systemPink,
        UIColor.systemGreen,
        .systemPurple,
        .systemTeal,
        .darkGray,
        .black,
        .white
    ]
    
    var selectedColor = UIColor.systemRed
    var selectedIconIndex = 0
    
    let availableIcons = [
        UIImage(systemName: "sun.max.fill"),
        UIImage(systemName: "person.3.fill"),
        UIImage(systemName: "person.3.fill"),
        UIImage(systemName: "person.3.fill"),
        UIImage(systemName: "person.3.fill"),
        UIImage(systemName: "person.3.fill"),
        UIImage(systemName: "person.3.fill"),
        UIImage(systemName: "person.3.fill"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        iconCollectionView.register(UINib(nibName: "IconCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "icon-cell")
        
        iconCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
        
        colorCollectionView.register(UINib(nibName: "ColorCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "color-cell")

        colorCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
        
        continueButton.layer.cornerRadius = 16
        
    }
    
    @IBAction func nextStep(_ sender: Any) {
        
        let selectedCell = iconCollectionView.cellForItem(at: IndexPath(row: selectedIconIndex, section: 0)) as! IconCollectionViewCell
        
        let appIcon = selectedCell.takeCleanScreenshot()
        project?.appIcon = appIcon
        
        let addVC = AddToHomeScreenViewController()
        addVC.project = self.project
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

@available(iOS 13.0, *)
extension SelectAppIconViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == colorCollectionView {
            return availableColors.count
        }
        
        if collectionView == iconCollectionView {
            return availableIcons.count
        }
        
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == colorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "color-cell", for: indexPath) as! ColorCollectionViewCell
            
            let color = availableColors[indexPath.row]
            
            cell.color = color
            
            
            return cell
        }
        
        if collectionView == iconCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icon-cell", for: indexPath) as! IconCollectionViewCell
            cell.icon = availableIcons[indexPath.row]
            cell.iconColor = selectedColor
            return cell
        }
        
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height  * 0.66, height: collectionView.frame.height * 0.66)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == colorCollectionView {
            selectedColor = availableColors[indexPath.row]
            iconCollectionView.reloadSections([0])
            iconCollectionView.selectItem(at: IndexPath(item: selectedIconIndex, section: 0), animated: false, scrollPosition: .top)
        }
        
        if collectionView == iconCollectionView {
            selectedIconIndex = indexPath.row
        }
        
    }
    
}

extension UIView {

    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}
