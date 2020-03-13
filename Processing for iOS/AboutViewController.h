//
//  AboutViewController.h
//  Processing for iOS
//
//  Created by Frederik Riedel on 17.02.17.
//  Copyright © 2017 Frederik Riedel. All rights reserved.
//

#import <UIKit/UIKit.h>
@import StoreKit;

@interface AboutViewController : UIViewController  <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (weak, nonatomic) IBOutlet UIButton *tier1Button;
@property (weak, nonatomic) IBOutlet UIButton *tier2Button;


@end
