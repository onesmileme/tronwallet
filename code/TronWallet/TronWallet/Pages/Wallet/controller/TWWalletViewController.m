//
//  WalletViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/16.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWWalletViewController.h"
#import "TWPriceUpdater.h"
@interface TWWalletViewController ()

@property(nonatomic , strong) TWPriceUpdater *priceUpdater;

@end

@implementation TWWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _priceUpdater = [[TWPriceUpdater alloc]init];
    [_priceUpdater startUpdate];
    _priceLabel.text = @"--";
    _changeLabel.text = @"--";
    __weak typeof(self) wself = self;
    _priceUpdater.updatePrice = ^(TWPrice *price) {
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.priceLabel.text = price.price_usd;
            wself.changeLabel.text = [NSString stringWithFormat:@"%@%%",price.percent_change_1h];
        });
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_priceUpdater startUpdate];
}


-(IBAction)walletAction:(id)sender
{
    
}

-(IBAction)exchangeAction:(id)sender
{
    
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
