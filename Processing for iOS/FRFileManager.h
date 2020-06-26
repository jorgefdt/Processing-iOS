//
//  FileManager.h
//  Processing for iOS
//
//  Created by Frederik Riedel on 27.06.15.
//  Copyright (c) 2015 Frederik Riedel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRFileManager : NSObject

+(NSString *) documentsDirectory;
+(NSString *) containerFile;
+(NSArray *) syntaxHighlighterDictionaryForSourceFileType:(NSString*)fileExtension;

@end
