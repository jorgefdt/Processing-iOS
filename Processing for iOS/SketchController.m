//
//  SketchController.m
//  Processing for iOS
//
//  Created by Frederik Riedel on 10/25/17.
//  Copyright © 2017 Frederik Riedel. All rights reserved.
//

#import "SketchController.h"
#import "FirstStart.h"
#import "Processing_for_iOS-Swift.h"

@implementation SketchController

+(void)copySampleProjectsOnFirstStart {
    if ([FirstStart isFirstStart]) {
        NSArray<NSString*>* sampleProjects = @[@"Example_3D",@"Example_Draw",@"Example_Clock",@"Example_FollowMe",@"Example_Multitouch", @"Example_Gyroscope_Accelerometer"];
        
        for (NSString* fileName in sampleProjects) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[[[self documentsDirectory] stringByAppendingPathComponent:@"sketches"] stringByAppendingPathComponent:fileName] withIntermediateDirectories:YES attributes:nil error:nil];
            NSError* error;
            
            
            NSString* mainBundlePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"pde"];
            NSString* documentsDirectoryPath = [[[[[self documentsDirectory] stringByAppendingPathComponent:@"sketches"] stringByAppendingPathComponent:fileName] stringByAppendingPathComponent:fileName] stringByAppendingString:@".pde"];
            
            [[NSFileManager defaultManager] copyItemAtPath:mainBundlePath toPath:documentsDirectoryPath error:&error];
        }
        
    }
}

+(void)loadSketches:(void (^)(NSArray<PDESketch*>* sketches))callback {
    if (![self haveSketchesBeenUpdated]) {
        // start update routine
        [self updateFilesToNewFolderStructure];
        if (![self haveSketchesBeenUpdated]) {
            NSLog(@"Error occured while updating to new folder structure.");
        }
    }
    
    [self copySampleProjectsOnFirstStart];
    
    NSMutableArray<PDESketch*>* pdeSketches = [NSMutableArray array];
    NSArray *filePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[self documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"sketches"]]  error:nil];
    for (NSString* sketchFolder in filePathsArray) {
        NSString* sketchName = [sketchFolder lastPathComponent];
        if (![sketchName isEqualToString:@".DS_Store"]) {
            PDESketch* sketch = [[PDESketch alloc] initWithSketchName:sketchName];
            [pdeSketches addObject:sketch];
        }
    }
    
    NSArray* sortedArray = [pdeSketches sortedArrayUsingComparator:^NSComparisonResult(PDESketch* sketch1, PDESketch* sketch2) {
        return [sketch1.sketchName.lowercaseString compare:sketch2.sketchName.lowercaseString];
    }];
    
    callback(sortedArray);
}

+(void)loadProjects:(void (^)(NSArray<SimpleTextProject *> *))callback {
    
    [self copySampleProjectsOnFirstStart];
    
    NSMutableArray<SimpleTextProject*>* projects = [NSMutableArray array];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[self documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"sketches"]]  error:nil];
    
    for (NSString* projectFolder in filePathsArray) {
        
        NSString* projectName = [projectFolder lastPathComponent];
        
        if (![projectName isEqualToString:@".DS_Store"]) {
            
            NSMutableArray* projectFiles = [NSMutableArray arrayWithArray: [[NSFileManager defaultManager] contentsOfDirectoryAtPath: [[SketchController documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"sketches/%@", projectFolder]]  error:nil]];
            
            NSString* fileFormat;
            
            for (NSString* projectFile in projectFiles) {
                
                NSString* extension = [projectFile pathExtension];
                
                if ([extension isEqualToString:@"pde"]) {
                    fileFormat = @"pde";
                }
                
                if ([extension isEqualToString:@"js"]) {
                    fileFormat = @"js";
                }
                
                if ([extension isEqualToString:@"txt"]) {
                    fileFormat = @"txt";
                }
            }
            
            if ([fileFormat isEqualToString:@"pde"]) {
                
                
                PDEProject* project = [[PDEProject alloc] initWithProjectName:projectFolder];
                [projects addObject:project];
                
            } else if ([fileFormat isEqualToString:@"js"]) {
                
                P5JSProject* project = [[P5JSProject alloc] initWithProjectName:projectFolder];
                [projects addObject:project];
                
            } else if ([fileFormat isEqualToString:@"txt"]) {
                SimpleTextProject* project = [[SimpleTextProject alloc] initWith:projectFolder sourceCodeExtension:@"txt"];
                [projects addObject:project];
            }
        }
    }
    
    NSArray* sortedArray = [projects sortedArrayUsingComparator:^NSComparisonResult(SimpleTextProject* project1, SimpleTextProject* project2) {
        return [project1.name.lowercaseString compare: project2.name.lowercaseString];
    }];
    
    callback(sortedArray);
    
}

+(void)updateFilesToNewFolderStructure {
    NSArray<NSString*>* legacyFiles = [self legacyItemsFromMenuFile];
    for (NSString* legacyFileName in legacyFiles) {
        NSString* currentPath = [[self documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pde", legacyFileName]];
        NSString* movePath =  [[self documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"sketches/%@/%@.pde", legacyFileName, legacyFileName]];
        NSString* moveFolder = [[self documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"sketches/%@/data", legacyFileName]];
        NSError* error;
        [[NSFileManager defaultManager] createDirectoryAtPath:moveFolder withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] moveItemAtPath:currentPath toPath:movePath error:&error];
        if (error) {
            NSLog(@"Error occured while copying the files: %@",error.description);
        }
    }
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentsDirectory]  error:nil];
    for (NSString* file in filePathsArray) {
        if ([file.pathExtension isEqualToString:@"pde"]) {
            NSString* path = [[self documentsDirectory] stringByAppendingPathComponent:file];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
}

+(NSArray<NSString*>*)legacyItemsFromMenuFile {
    NSMutableArray* legacyFiles = [[NSMutableArray alloc] init];
    
    NSString *programmCodesPath = [[self documentsDirectory] stringByAppendingPathComponent:@"menu.txt"];
    NSString *programmCodesString = [NSString stringWithContentsOfFile:programmCodesPath encoding:NSUTF8StringEncoding error:NULL];
    
    for(NSString *fileName in [programmCodesString componentsSeparatedByString:@"\n"]) {
        if(![fileName isEqualToString:@""]) {
            [legacyFiles addObject:fileName];
        }
    }
    return legacyFiles.copy;
}

+(BOOL)haveSketchesBeenUpdated {
    NSArray *filePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentsDirectory]  error:nil];
    for (NSString* file in filePathsArray) {
        if ([file.pathExtension isEqualToString:@"pde"]) {
            return NO;
        }
    }
    return YES;
}

+(void)deleteSketchWithName:(NSString*)sketchName {
    NSString* path = [[self documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"sketches/%@/",sketchName]];
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
}

+(void)savePDESketch:(PDESketch*)sketch {
    NSString* sketchPath = [[self documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"sketches/%@/data",sketch.sketchName]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:sketchPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:sketchPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"Created new folder for new sketch");
    }
}

+(NSString*)documentsDirectory {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    return documentsDirectory;
}

@end
