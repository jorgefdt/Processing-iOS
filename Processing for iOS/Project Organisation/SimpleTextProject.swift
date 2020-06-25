//
//  Project.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/15/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import Foundation

class SimpleTextProject {
    
    var name: String
    var sourceCodeExtension: String
    var appIcon: UIImage?
    
    init(with name: String, sourceCodeExtension: String) {
        self.name = name
        self.sourceCodeExtension = sourceCodeExtension
        
        if !FileManager.default.fileExists(atPath: folder.absoluteString) {
            try? FileManager.default.createDirectory(atPath: folder.absoluteString, withIntermediateDirectories: true, attributes: nil)
            
            let startFile = SourceCodeFile(filePath: folder.appendingPathComponent("\(name).\(sourceCodeExtension)").absoluteString)
            startFile.save(newContent: self.emptyFile)
            
        }
    }
    
    var folder: URL {
        let docDir = URL(fileURLWithPath: SketchController.documentsDirectory())
        let sketchPath = docDir.appendingPathComponent("sketches/\(self.name)")
        return sketchPath
    }
    
    var sourceCodeFiles: [SourceCodeFile] {
        if let filePaths = try? FileManager.default.contentsOfDirectory(atPath: folder.absoluteString) {
            
            return filePaths.compactMap { (filePath) -> SourceCodeFile? in
                
                if filePath.hasSuffix(".\(sourceCodeExtension)") {
                    return SourceCodeFile(filePath: filePath)
                }
                
                return nil
            }
        }
        
        return []
    }
    
    var cummulatedSourceCode: String {
        return sourceCodeFiles.reduce("") { (result, jsFile) -> String in
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
        return cummulatedSourceCode
    }
    
    var emptyFile: String {
        return ""
    }
    
    var creationDate: Date {
        let fileAttrs = try! FileManager.default.attributesOfItem(atPath: folder.absoluteString)
        return fileAttrs[FileAttributeKey.creationDate] as! Date
    }
    
    func createNewFile(withName name: String, content: String? = nil) {
        let newFile = SourceCodeFile(filePath: folder.appendingPathComponent("\(name).\(sourceCodeExtension)").absoluteString)
        if let content = content {
            newFile.save(newContent: content)
        } else {
            newFile.save(newContent: emptyFile)
        }
        
    }
    
}
