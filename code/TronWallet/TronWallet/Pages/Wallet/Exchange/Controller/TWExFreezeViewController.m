//
//  TWExFreezeViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWExFreezeViewController.h"
#import "TKCommonTools.h"
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
    long freezed = 0;
    long unfreezable = 0;
    long expire = 0;
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    for (Account_Frozen *frozen in account.frozenArray) {
        freezed += frozen.frozenBalance;
        if (frozen.expireTime > expire) {
            expire = frozen.expireTime;
        }
        if (frozen.expireTime < current) {
            unfreezable += frozen.frozenBalance;
        }
    }
    
    //TODO add local us format
    _fronzenLabel.text = [@(freezed/kDense) description];
    _currentTpLabel.text = [@(freezed/kDense) description];
    _currentEntropyLabel.text = @"0";//[@(account.)];
    _expireLabel.text = (expire == 0 ? @"-":[TKCommonTools dateStringWithFormat:TKDateFormatEnglishAll date:[NSDate dateWithTimeIntervalSince1970:expire]]);
    
    NSString *freezeStr = [_amountField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    long freeze = [freezeStr integerValue]*kDense;
    long newFreeze = freezed + freeze;
    _freezeLabel.text = [@(newFreeze/kDense) description];
    _tpLabel.text = [@(newFreeze/kDense) description];
    _entropyLabel.text = @"0"; //
    
}

-(IBAction)freezeAction:(id)sender
{    
    Wallet *wallet = [[TWNetworkManager sharedInstance] walletClient];
    
    TWWalletAccountClient *client = AppWalletClient;
    FreezeBalanceContract *contract = [[FreezeBalanceContract alloc] init];
    contract.ownerAddress = [client address];
    contract.frozenBalance = (int64_t)[_amountField.text integerValue]*kDense;
    contract.frozenDuration = 3;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [wallet freezeBalanceWithRequest:contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        if (error) {
            hud.label.text = [error localizedDescription];
        }else{
            [client refreshAccount:^(Account *account, NSError *error) {
                [self refreshData];
            }];
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
            [client refreshAccount:^(Account *account, NSError *error) {
                [self updateUI:account];
            }];
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
