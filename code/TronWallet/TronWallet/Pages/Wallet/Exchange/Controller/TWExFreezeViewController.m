//
//  TWExFreezeViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWExFreezeViewController.h"

@interface TWExFreezeViewController ()<UITextFieldDelegate>

@end

@implementation TWExFreezeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshData
{
    TWWalletAccountClient *client = AppWalletClient;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [client refreshAccount:^(Account *account, NSError *error) {
        if (error) {
            hud.label.text = [error localizedDescription];
        }else{
            [self updateUI:account];
        }
        [hud hideAnimated:YES afterDelay:0.7];
    }];
}

-(void)updateUI:(Account *)account
{
    
}

-(IBAction)freezeAction:(id)sender
{
    
    Wallet *wallet = [[TWNetworkManager sharedInstance] walletClient];
    
    TWWalletAccountClient *client = AppWalletClient;
    FreezeBalanceContract *contract = [[FreezeBalanceContract alloc] init];
    contract.ownerAddress = [client address];
    contract.frozenBalance = [_amountField.text integerValue];
    contract.frozenDuration = 3;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [wallet freezeBalanceWithRequest:contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        if (error) {
            hud.label.text = [error localizedDescription];
        }else{
            
        }
        [hud hideAnimated:YES afterDelay:0.7];
    }];
    
}

-(IBAction)unfreezeAction:(id)sender
{
    Wallet *wallet = [[TWNetworkManager sharedInstance] walletClient];
    
    TWWalletAccountClient *client = AppWalletClient;
    
    UnfreezeBalanceContract *contract = [[UnfreezeBalanceContract alloc]init];
    contract.ownerAddress = [client address];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [wallet unfreezeBalanceWithRequest:contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        if (error) {
            hud.label.text = [error localizedDescription];
        }else{
            
        }
        [hud hideAnimated:YES afterDelay:0.7];
    }];
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
