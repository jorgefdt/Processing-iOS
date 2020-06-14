//
//  P5JSSketch.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/11/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import Foundation



class P5JSSketch {

    var sketchName: String
    
    init(sketchName: String) {
        self.sketchName = sketchName
    }
    
    var sketchPath: URL {
        let docDir = URL(fileURLWithPath: SketchController.documentsDirectory())
        let sketchPath = docDir.appendingPathComponent("sketches/\(self.sketchName)")
        return sketchPath
    }

    var jsFiles: [JSFile] {
        
        
        
        if let filePaths = try? FileManager.default.contentsOfDirectory(atPath: sketchPath.absoluteString) {
            
            return filePaths.compactMap { (filePath) -> JSFile? in
                
                if filePath.hasSuffix(".js") {
                    return JSFile(filePath: filePath)
                }
                
                return nil
            }
            
        }
        
        
        return []
    }
    
    var cummulatedSourceCode: String {
        return jsFiles.reduce("") { (result, jsFile) -> String in
            if let code = jsFile.content {
                return """
                       \(result)
                       \(code)
                       """
            }
            return result
        }
    }
    
    var htmlPage: String {
        let p5jsMin = try! String(contentsOfFile: Bundle.main.path(forResource: "p5.min", ofType: "js")!)
        let p5jsSoundMin = try! String(contentsOfFile: Bundle.main.path(forResource: "p5.sound.min", ofType: "js")!)
        
        let p5jsContainer = try! String(contentsOfFile: Bundle.main.path(forResource: "p5js-container", ofType: "html")!)
        
        
        return String(format: p5jsContainer, sketchName, p5jsMin, p5jsSoundMin, cummulatedSourceCode)
    }
    
    var emptySketch: String {
        let sketchJs = try! String(contentsOfFile: Bundle.main.path(forResource: "p5js-sketch", ofType: "js")!)
        return sketchJs
    }
    
    var creationDate: Date {
        let fileAttrs = try! FileManager.default.attributesOfItem(atPath: sketchPath.absoluteString)
        return fileAttrs[FileAttributeKey.creationDate] as! Date
    }
    
}
