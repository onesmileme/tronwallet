//
//  TWExSendViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/26.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWExSendViewController.h"
#import "TWQRViewController.h"
#import "NS+BTCBase58.h"
#import "TWWalletAccountClient.h"

@interface TWExSendViewController ()<UITextFieldDelegate>

@end

@implementation TWExSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tap];
    
#if DEBUG
    self.toLabel.text = @"27guAkL1Ny136ZoY6hMykPC3xt4Y93twFgf";
#endif
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTap:(UITapGestureRecognizer *)gesture
{
    [self.amountTextField resignFirstResponder];
}

-(IBAction)qrAction:(id)sender
{
    TWQRViewController *controller = [[TWQRViewController alloc]init];
    __weak typeof(self) wself = self;
    controller.captureBlock = ^(NSString *metaObbj) {
        wself.toLabel.text = metaObbj;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showConfirmAlert
{
    UIAlertController *aletController = [UIAlertController alertControllerWithTitle:@"TIP" message:@"Confirm Send Transcation?" preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reallySend];
    }];
    [aletController addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [aletController addAction:cancelAction];
    
    [self presentViewController:aletController animated:YES completion:nil];
}

-(void)reallySend
{
    TransferContract *contract = [[TransferContract alloc]init];
    contract.toAddress =  BTCDataFromBase58(_toLabel.text);
//    NSString *priKey = [TWWalletAccountClient loadPriKey];
    TWWalletAccountClient *client = AppWalletClient;
    contract.ownerAddress = [client address];
    contract.amount = [_amountTextField.text integerValue];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    [wallet createTransactionWithRequest:contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        //update amount
        if (error) {
            hud.label.text = [error localizedDescription];
            [hud hideAnimated:YES afterDelay:0.7 ];
            return ;
        }
        [wallet broadcastTransactionWithRequest:response handler:^(Return * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                hud.label.text = [error localizedDescription];
            }else{
                if (response.code == Return_response_code_Success) {
                    hud.label.text = @"Success";
                }else{
                    hud.label.text = [[NSString alloc] initWithData:response.message encoding:NSUTF8StringEncoding];
                }
            }
            
            [hud hideAnimated:YES afterDelay:0.7 ];
        }];
        
    }];
}

-(IBAction)confirmAction:(id)sender
{
    NSString *tip = nil;
    if (self.toLabel.text.length == 0) {
        tip = @"Please choose other wallet address";
    }else if (self.amountTextField.text.length == 0){
        tip = @"Please choose amount";
    }else{
        TWWalletAccountClient *accountClient = AppWalletClient;
        Account *account = accountClient.account;
//        if (account.balance < self.amountTextField.text.integerValue) {
//            tip = @"Input amount too much";
//        }
    }
    
    if (tip) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"WARNING" message:tip preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        return;
    }
    
//    Transaction *transaction = [[Transaction alloc]init];
    [self showConfirmAlert];
   
    
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
