//
//  AppDelegate.m
//  Processing for iOS
//
//  Created by Frederik Riedel on 27.06.15.
//  Copyright (c) 2015 Frederik Riedel. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+ProcessingColor.h"
#import "SketchController.h"
#import "Processing_for_iOS-Swift.h"

#if !TARGET_OS_UIKITFORMAC
@import Firebase;
#endif


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    #if !TARGET_OS_UIKITFORMAC
    [FIRApp configure];
    #endif
    
    [[UINavigationBar appearance] setTintColor: [UIColor whiteColor]];
    
    [[UISegmentedControl appearance] setTintColor: [UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor: [UIColor processingColor]];
    
    
    [[UISearchBar appearance] setBarTintColor: [UIColor processingColor]];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    if (@available(iOS 11.0, *)) {
        [[UINavigationBar appearance] setLargeTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }
    
    
//    [ExternalScreenController start];
    
    
    
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance* appearance = [[UINavigationBarAppearance alloc] init];
        
        [appearance configureWithOpaqueBackground];
        [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [appearance setLargeTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [appearance setBackgroundColor: [UIColor processingColor]];
        
        [[UINavigationBar appearanceWhenContainedInInstancesOfClasses: @[UINavigationController.class] ] setStandardAppearance:appearance];
        [[UINavigationBar appearanceWhenContainedInInstancesOfClasses: @[UINavigationController.class] ] setScrollEdgeAppearance:appearance];
    }
    
    
    [ProBenefitsViewController preloadProductInfo];
    [ProBenefitsViewController completePendingTransactions];
    [ProBenefitsViewController updateExpirationDate];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // save code
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveCode" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveCode" object:nil];
}

@end
