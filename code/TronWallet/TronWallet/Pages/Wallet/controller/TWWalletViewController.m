//
//  WalletViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/16.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWWalletViewController.h"
#import "TWPriceUpdater.h"
#import "AppDelegate.h"
#import "TWExchangeViewController.h"
#import "AppDelegate.h"
#import "TWVoteViewController.h"
#import "TWAssetIssueViewController.h"

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
    
    UIColor *lineColor = [UIColor themeRed];
    self.walletButton.layer.borderColor = [lineColor CGColor];
    self.walletButton.layer.borderWidth = 1;
    self.walletButton.layer.cornerRadius = 6;
    
    self.exchangeButton.layer.borderColor = [lineColor CGColor];
    self.exchangeButton.layer.borderWidth = 1;
    self.exchangeButton.layer.cornerRadius = 6;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountUpdateNotification:) name:kAccountUpdateNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_priceUpdater startUpdate];
    
    [self updateAccount];
    
}


-(void)updateAccount
{
    TWWalletAccountClient *client = AppWalletClient;
    self.tokenLabel.text = [client base58OwnerAddress];
    
    self.countLabel.text = [NSString stringWithFormat:@"%@", @(client.account.balance/kDense)];
}

-(void)accountUpdateNotification:(NSNotification *)notfication
{
    [self updateAccount];
}


-(IBAction)walletAction:(id)sender
{
    if(AppWalletClient.account.asset){
        [self showAlert:nil mssage:@"You may create only one token per account" confrim:@"Confirm" cancel:nil];
        return;
    }
    
    TWVoteViewController *vote = [[TWVoteViewController alloc]initWithNibName:@"TWVoteViewController" bundle:nil];
    vote.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vote animated:YES];
}

-(IBAction)exchangeAction:(id)sender
{
    TWExchangeViewController *controller = [[TWExchangeViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)issueTokenAction:(id)sender
{
    TWAssetIssueViewController *controller = [[TWAssetIssueViewController alloc]initWithNibName:@"TWAssetIssueViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
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
