//
//  AboutViewController.m
//  Processing for iOS
//
//  Created by Frederik Riedel on 17.02.17.
//  Copyright © 2017 Frederik Riedel. All rights reserved.
//

#import "AboutViewController.h"
@import SafariServices;

@interface AboutViewController ()

@end

@implementation AboutViewController

SKProductsRequest *request;

NSString* tier1Id = @"io.frogg.processing.tier1";
NSString* tier2Id = @"io.frogg.processing.tier2";

SKProduct* tier1Product;
SKProduct* tier2Product;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"About Processing for iOS";
    
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = done;
    
    NSArray *productIds = @[tier1Id, tier2Id];
    
    request = [[SKProductsRequest alloc] initWithProductIdentifiers: [[NSSet alloc] initWithArray:productIds] ];
    request.delegate = self;
    [request start];
    
    [SKPaymentQueue.defaultQueue addTransactionObserver:self];
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    for(SKProduct* product in response.products) {
        
        NSNumberFormatter* priceFormatter = [[NSNumberFormatter alloc] init];
        priceFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        priceFormatter.locale = product.priceLocale;
        
        NSString* price = [priceFormatter stringFromNumber:product.price];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([product.productIdentifier isEqualToString:tier1Id]) {
                
                tier1Product = product;
                [self.tier1Button setTitle: [NSString stringWithFormat:@"Tip %@", price] forState:UIControlStateNormal];
                
            } else if ([product.productIdentifier isEqualToString:tier2Id]) {
                tier2Product = product;
                [self.tier2Button setTitle: [NSString stringWithFormat:@"Tip %@", price] forState:UIControlStateNormal];
                
            }
            
        });
    }
}

-(void) done {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openTwitter:(id)sender {
    
    SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://twitter.com/frederikriedel"]];
    
    [self presentViewController:sfvc animated:YES completion:nil];
    
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"twitter://user?screen_name=frederikriedel"]];
}

- (IBAction)buyTier1:(id)sender {
    SKPayment* tier1Payment = [SKPayment paymentWithProduct:tier1Product];
    [SKPaymentQueue.defaultQueue addPayment:tier1Payment];
}

- (IBAction)buyTier2:(id)sender {
    SKPayment* tier2Payment = [SKPayment paymentWithProduct:tier2Product];
    [SKPaymentQueue.defaultQueue addPayment:tier2Payment];
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    for (SKPaymentTransaction* transation in transactions) {
        if (transation.transactionState == SKPaymentTransactionStatePurchased) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"Thanks for your Support ❤️" message: @"Thanks for supporting the furter development of Processing for iOS. Thanks to people like you, I can spend more time on future updates!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Great!" style:UIAlertActionStyleDefault handler: nil];
            
            [alert addAction: ok];
            [self presentViewController:alert animated:YES completion: nil];
        }
    }
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
