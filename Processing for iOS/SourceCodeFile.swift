//
//  JSFile.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/11/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import Foundation

@objc class SourceCodeFile: NSObject {
    
    @objc var filePath: String
    @objc var content: String?
    
    init(filePath: String) {
        self.filePath = filePath
        self.content = try? String(contentsOfFile: filePath)
    }
    
    @objc var fileName: String {
        return URL(fileURLWithPath: filePath).lastPathComponent
    }
    
    @objc var fileExtension: String {
        return URL(fileURLWithPath: filePath).pathExtension
    }
    
    @objc func save(newContent: String? = nil) {
        print("save code of file \(fileName)")
        if let newContent = newContent {
            self.content = newContent
        }
        
        try? self.content?.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
}
