//
//  CodeFixSuggestionTableViewCell.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/22/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import UIKit

class CodeFixSuggestionTableViewCell: UITableViewCell {

    @IBOutlet weak var codeFixIcon: UIImageView!
    @IBOutlet weak var codeFixTitleLabel: UILabel!
    @IBOutlet weak var codeFixDetailLabel: UILabel!
    
    
    var codeFix: [String: String]! {
        didSet {
            codeFixTitleLabel.text = codeFix["explanation"]
            codeFixDetailLabel.text = codeFix["explanation_subtitle"]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
