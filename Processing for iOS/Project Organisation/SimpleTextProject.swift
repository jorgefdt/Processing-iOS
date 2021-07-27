//
//  Project.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/15/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import Foundation

@objc class SimpleTextProject: NSObject {
    
    @objc var name: String
    @objc var sourceCodeExtension: String
    @objc var appIcon: UIImage?
    
    @objc init(with name: String, sourceCodeExtension: String, importingFiles: [URL] = []) {
        
        self.name = name
        self.sourceCodeExtension = sourceCodeExtension
        
        super.init()
        
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            
            if importingFiles.isEmpty {
                let startFile = SourceCodeFile(filePath: folder.appendingPathComponent("\(name).\(sourceCodeExtension)").path)
                startFile.save(newContent: self.emptyFile)
            }
            
        } else {
            print("already exists: \(folder.lastPathComponent)")
        }
        
        
        importingFiles.forEach { (url) in
            url.startAccessingSecurityScopedResource()
            
            if url.isDirectory {
                try! FileManager.default.removeItem(at: folder)
                try! FileManager.default.copyItem(at: url, to: folder)
            } else {
                let content = try? String(contentsOf: url)
                let startFile = SourceCodeFile(filePath: folder.appendingPathComponent(url.lastPathComponent).path)
                startFile.save(newContent: content)
            }
            
            url.stopAccessingSecurityScopedResource()
        }
    }
    
    @objc var folder: URL {
        let docDir = URL(fileURLWithPath: SketchController.documentsDirectory())
        let sketchPath = docDir.appendingPathComponent("sketches/\(self.name)")
        return sketchPath
    }
    
    @objc var sourceCodeFiles: [SourceCodeFile] {
        if let filePaths = try? FileManager.default.contentsOfDirectory(atPath: folder.path) {
            
            return filePaths.compactMap { (filePath) -> SourceCodeFile? in
                
                if filePath.hasSuffix(".\(sourceCodeExtension)") {
                    return SourceCodeFile(filePath: folder.appendingPathComponent(filePath).path)
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
    
    @objc var htmlPage: String {
        return cummulatedSourceCode
    }
    
    var emptyFile: String {
        return ""
    }
    
    var creationDate: Date {
        if let fileAttrs = try? FileManager.default.attributesOfItem(atPath: folder.path) {
            return fileAttrs[FileAttributeKey.creationDate] as! Date
        } else {
            return Date()
        }
    }
    
    func createNewFile(withName name: String, content: String? = nil) {
        let newFile = SourceCodeFile(filePath: folder.appendingPathComponent("\(name).\(sourceCodeExtension)").path)
        if let content = content {
            newFile.save(newContent: content)
        } else {
            newFile.save(newContent: emptyFile)
        }
        
    }
    
}

extension URL {
    var isDirectory: Bool {
       return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
