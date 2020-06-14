//
//  JSFile.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/11/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import Foundation

class JSFile {
    
    var filePath: String
    var content: String?
    
    init(filePath: String) {
        self.filePath = filePath
        self.content = try? String(contentsOfFile: filePath)
    }
    
    func save(newContent: String? = nil) {
        
        if let newContent = newContent {
            self.content = newContent
        }
        
        try? self.content?.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
    
}
