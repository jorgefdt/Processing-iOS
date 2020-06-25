//
//  PDEProject.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/15/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import Foundation

class PDEProject: SimpleTextProject {
    
    init(with name: String) {
        super.init(with: name, sourceCodeExtension: "pde")
    }
    
    static var containerFile: String {
        return try! String(contentsOfFile: Bundle.main.path(forResource: "container", ofType: "html")!)
    }
    
    override var htmlPage: String {
        
        let processingJs = try! String(contentsOfFile: Bundle.main.path(forResource: "processing.min", ofType: "js")!)
        
        let appIcon = self.appIcon?.resize(newWidth: 192)
        let base64 = appIcon?.base64()
        
        return String(format: PDEProject.containerFile, base64 ?? "", processingJs, name, cummulatedSourceCode)
    }
    
    override var emptyFile: String {
        return "void setup() {\n   size(screenWidth, screenHeight);\n}\n\n" +
               "void draw() {\n   background(0,0,255);\n}"
    }
}
