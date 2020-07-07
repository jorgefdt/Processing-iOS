//
//  P5JSProject.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/15/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import Foundation

@objc class P5JSProject: SimpleTextProject {
    
    @objc init(withProjectName name: String, importingFiles: [URL] = []) {
        super.init(with: name, sourceCodeExtension: "js", importingFiles: importingFiles)
    }
    
    static var containerFile: String {
        return try! String(contentsOfFile: Bundle.main.path(forResource: "p5js-container", ofType: "html")!)
    }
    
    override var htmlPage: String {
        let p5jsMin = try! String(contentsOfFile: Bundle.main.path(forResource: "p5.min", ofType: "js")!)
        let p5jsSoundMin = try! String(contentsOfFile: Bundle.main.path(forResource: "p5.sound.min", ofType: "js")!)
                
        return String(format: P5JSProject.containerFile, name, "base64-icon-empty", p5jsMin, p5jsSoundMin, cummulatedSourceCode)
    }
    
    override var emptyFile: String {
        let sketchJs = try! String(contentsOfFile: Bundle.main.path(forResource: "p5js-sketch", ofType: "js")!)
        return sketchJs
    }
    
}
