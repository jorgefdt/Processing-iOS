//
//  FileManager.m
//  Processing for iOS
//
//  Created by Frederik Riedel on 27.06.15.
//  Copyright (c) 2015 Frederik Riedel. All rights reserved.
//

#import "FRFileManager.h"

@implementation FRFileManager

static NSString *documentsDirectory;
static NSString *container;
static NSArray *pdeSyntaxHighlighter;
static NSArray *p5jsSyntaxHighlighter;

+(NSString *) documentsDirectory {
    if(!documentsDirectory) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
    }
    
    return documentsDirectory;
}

+(NSString *) containerFile {
    if(!container) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"container" ofType:@"html"];
        
        if (filePath) {
            container = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        }
        
    }
    
    return container;
}

+(NSArray *) syntaxHighlighterDictionaryForSourceFileType:(NSString*)fileExtension {
    
    if ([fileExtension isEqualToString:@"pde"]) {
        
        if(!pdeSyntaxHighlighter) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"syntax-highlighting-pde"
                                                             ofType:@"plist"];
            pdeSyntaxHighlighter = [[NSArray alloc]
                                  initWithContentsOfFile:path];
        }
        
        return pdeSyntaxHighlighter;
        
    } else if ([fileExtension isEqualToString:@"js"]) {
        if(!p5jsSyntaxHighlighter) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"syntax-highlighting-p5js"
                                                             ofType:@"plist"];
            p5jsSyntaxHighlighter = [[NSArray alloc]
                                  initWithContentsOfFile:path];
        }
        
        return p5jsSyntaxHighlighter;
    }
    
    return @[];
}



@end
