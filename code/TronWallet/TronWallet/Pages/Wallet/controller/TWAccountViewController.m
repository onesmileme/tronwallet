//
//  TWAccountViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/25.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWAccountViewController.h"
#import "TWQRCoderGenerator.h"
#import "TWWalletAccountClient.h"
#import "TWHexConvert.h"
#import "NS+BTCBase58.h"
#import "AppDelegate.h"

@interface TWAccountViewController ()

@property(nonatomic , strong) NSString *address;
@property(nonatomic , strong) NSString *password;
@property(nonatomic , assign) BOOL cold;
@property(nonatomic , strong) TWWalletAccountClient *client;

@end

@implementation TWAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.scrollView addSubview:self.conentView];
    self.contentWidth.constant = CGRectGetWidth(self.view.frame);
    CGRect frame = self.conentView.frame;
    frame.origin = CGPointZero;
    self.conentView.frame = frame;
    self.scrollView.contentSize = self.conentView.frame.size;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.addressQR.image) {
        self.addressQR.image = [TWQRCoderGenerator generate:self.address];
        NSData *priKeyData = [_client.crypto privateKey];
        NSString *priKey = [TWHexConvert convertDataToHexStr:priKeyData];
        self.priKeyQR.image = [TWQRCoderGenerator generate:priKey];
    }
}

-(void)setupPassword:(NSString *)password cold:(BOOL)cold
{
    self.password = password;
    self.cold = cold;
    
    _client = [TWWalletAccountClient walletWithPassword:password];
    NSData *addressData = [_client address];
    
    self.address = BTCBase58CheckStringWithData(addressData);
    
}

-(IBAction)continueAction:(id)sender
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appdelegate createAccountDone:self.navigationController];
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
