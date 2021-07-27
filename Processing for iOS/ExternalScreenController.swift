//
//  ExternalScreenController.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 9/25/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import Foundation


@objc class ExternalScreenController: NSObject {
    
    static var extWindow: UIWindow?
    
    @objc static func start() {
        NotificationCenter.default.addObserver(forName: .UIScreenDidConnect, object: nil, queue: nil) { (connectNotice) in
            let extScreen = connectNotice.object as! UIScreen
            let extScreenBounds = extScreen.bounds
            
            
            // Our unique content
            extWindow = UIWindow(frame: extScreenBounds)
            extWindow?.screen = extScreen
            extWindow?.rootViewController = ExternalScreenViewController()
            extWindow?.isHidden = false
        }
        
        
        NotificationCenter.default.addObserver(forName: .UIScreenDidDisconnect, object: nil, queue: nil) { (disconnectNotice) in
           let extScreen = disconnectNotice.object as! UIScreen

           if extScreen == extWindow?.screen
           {
                extWindow?.isHidden = true
                extWindow = nil
           }
        }
    }
    
    @objc static func showSketch(project: SimpleTextProject) {
        let runSketchVC = RunSketchViewController(simpleTextProject: project)
        extWindow?.rootViewController = runSketchVC
    }
    
}
