//
//  TWQRViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/26.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWQRViewController.h"
#import "TWQRScanView.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
@interface TWQRViewController ()

@end

@implementation TWQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"SCAN QR";
    
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil message:@"Can't access capture, please switch on in settings" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            if(self.navigationController){
                [self.navigationController popViewControllerAnimated:YES ];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
        
        [alertC addAction:action];
        
        [self presentViewController:alertC animated:YES completion:nil];
        
    }else{
        
        [self tryAddScan];
        
    }
    

    
}

-(void)tryAddScan
{
    TWQRScanView *scanview = [[TWQRScanView alloc] init];
    __weak typeof(self) wself = self;
    scanview.captureBlock = ^(NSArray *metaObbjs) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.navigationController popViewControllerAnimated:YES];
            
            if (wself.captureBlock) {
                AVMetadataMachineReadableCodeObject *object = [metaObbjs firstObject];
                wself.captureBlock(object.stringValue);
            }
        });
    };
    [self.view addSubview:scanview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
