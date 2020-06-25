
//
//  CodeErrorDetectionEngine.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/24/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import Foundation

@objc class DetectedBug: NSObject {
    
    internal init(bugType: BugType, wrongCode: String) {
        self.bugType = bugType
        self.wrongCode = wrongCode
    }
    
    @objc let bugType: BugType
    @objc let wrongCode: String
}

@objc enum BugType: Int {
    case referenceError, syntaxErrorVarUsage, unknownError
}

@objc class CodeErrorDetectionEngine: NSObject {
    @objc static func bug(fromString string: String) -> DetectedBug? {
        
        let referenceErrorPrefix = "ReferenceError: Can't find variable: "
        if string.starts(with: referenceErrorPrefix) {
            let wrongCode = string.replacingOccurrences(of: referenceErrorPrefix, with: "")
            return DetectedBug(bugType: .referenceError, wrongCode: wrongCode)
        }
        
        if string.starts(with: "SyntaxError: Cannot use the keyword 'var' as a variable name.") {
            return DetectedBug(bugType: .syntaxErrorVarUsage, wrongCode: "var")
        }
        
        return nil
    }
}
