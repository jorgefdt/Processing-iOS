//
//  ColorCollectionViewCell.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/11/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    var color: UIColor? {
        didSet {
            self.colorView.backgroundColor = color
        }
    }
    
    @IBOutlet weak var colorView: UIView!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.colorView.layer.cornerRadius = self.colorView.bounds.height / 2
        self.contentView.layer.cornerRadius = self.contentView.bounds.height / 2
        
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.colorView.layer.cornerRadius = self.colorView.bounds.height / 2
        self.contentView.layer.cornerRadius = self.contentView.bounds.height / 2
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.colorView.layer.cornerRadius = self.colorView.bounds.height / 2
        self.contentView.layer.cornerRadius = self.contentView.bounds.height / 2
    }

}
