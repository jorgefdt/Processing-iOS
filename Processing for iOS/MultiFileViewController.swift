//
//  MultiFileViewController.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/25/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import UIKit

class MultiFileViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var textView: UITextView!
    
    var fileURL: URL! {
        didSet {
            loadFile()
        }
    }
    
    func loadFile() {
        if isViewLoaded {
            self.title = fileURL.lastPathComponent
            if let string = try? String(contentsOfFile: fileURL.path, encoding: .utf8) {
                textView.text = string
                textView.isHidden = false
                webView.isHidden = true
            } else {
                webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
                webView.isHidden = false
                textView.isHidden = true
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFile()
        // Do any additional setup after loading the view.
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
