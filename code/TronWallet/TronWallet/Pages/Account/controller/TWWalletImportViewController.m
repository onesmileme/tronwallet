//
//  TWWalletImportViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWWalletImportViewController.h"
#import "TWQRViewController.h"


@interface TWWalletImportViewController ()<UITextFieldDelegate>

@end

@implementation TWWalletImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIColor *color = [UIColor lightGrayColor];
    
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName:color}];
    
    self.privateKeyField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"Private Key" attributes:@{NSForegroundColorAttributeName:color}];
        
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.contentView.superview) {
        self.contentView.width = SCREEN_WIDTH;
        [self.scrollView addSubview:self.contentView];
        self.scrollView.contentSize = self.contentView.size;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)qaAction:(id)sender
{
    TWQRViewController *controller = [[TWQRViewController alloc]init];
    __weak typeof(self) wself = self;
    controller.captureBlock = ^(NSString *metaObbj) {
        wself.privateKeyField.text = metaObbj;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)importAction:(id)sender
{
    NSString *tip = nil;
    if (self.passwordField.text.length == 0) {
        tip = @"Please input password";
    }else if (self.passwordField.text.length < 6){
        tip = @"Password must longer than 6";
    }else if (self.privateKeyField.text.length == 0){
        tip = @"Please input private key";
    }else if (!self.riskSwitch.isOn){
        tip = @"Please agree risks";
    }
    
    if (tip) {
        [self showAlert:nil mssage:tip confrim:@"Confirm" cancel:nil];
        return;
    }
    
    [self reallyImportWallet];
}

-(void)reallyImportWallet
{
    NSString *prikey = self.privateKeyField.text;
    NSString *password = self.passwordField.text;
    TWWalletAccountClient *client = [[TWWalletAccountClient alloc]initWithPriKeyStr:prikey];
    [client store:password];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.walletClient = client;
    
    [self.navigationController popViewControllerAnimated:YES];
    [appDelegate createAccountDone:self.navigationController];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
