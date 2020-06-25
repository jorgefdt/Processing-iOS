//
//  SketchController.h
//  Processing for iOS
//
//  Created by Frederik Riedel on 10/25/17.
//  Copyright © 2017 Frederik Riedel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDESketch.h"

@class SimpleTextProject;

@interface SketchController : NSObject
+(void)loadSketches:(void (^)(NSArray<PDESketch*>* sketches))callback;
+(void)loadProjects:(void (^)(NSArray<SimpleTextProject*>* projects))callback;
+(void)deleteSketchWithName:(NSString*)sketchName;
+(void)savePDESketch:(PDESketch*)sketch;
+(NSString*)documentsDirectory;
@end
