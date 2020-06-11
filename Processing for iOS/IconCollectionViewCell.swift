//
//  IconCollectionViewCell.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/11/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconView: UIImageView!
    
    var icon: UIImage? {
        didSet {
            iconView.image = icon
        }
    }
    
    var iconColor: UIColor? {
        didSet {
            self.iconView.backgroundColor = iconColor
            
            if let iconColor = iconColor {
                if iconColor.needsDarkText {
                    iconView.tintColor = UIColor.black
                } else {
                    iconView.tintColor = UIColor.white
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 16
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        
        self.iconView.layer.cornerRadius = 12
        self.iconView.layer.masksToBounds = true
        self.iconView.clipsToBounds = true
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.layer.borderColor = UIColor.systemBlue.cgColor
                self.contentView.layer.borderWidth = 2.0
            } else {
                self.contentView.layer.borderColor = UIColor.systemBlue.cgColor
                self.contentView.layer.borderWidth = 0.0
            }
        }
    }
    
    func takeCleanScreenshot() -> UIImage {
        
        self.contentView.layer.cornerRadius = 0
        self.iconView.layer.cornerRadius = 0
        
        let screenshot = iconView.takeScreenshot()
        
        self.iconView.layer.cornerRadius = 12
        self.contentView.layer.cornerRadius = 16
        
        return screenshot
    }
}

extension UIColor {

    var luminance: CGFloat {

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return 0.2126 * red + 0.7152 * green + 0.0722 * blue

    }

    var needsDarkText: Bool {
        return luminance > 0.7
    }

}
