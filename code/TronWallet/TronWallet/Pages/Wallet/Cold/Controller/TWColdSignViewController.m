//
//  TWColdSignViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/30.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWColdSignViewController.h"
#import "TWQRViewController.h"
#import "TWColdSignTranscationViewController.h"


@interface TWColdSignViewController ()

@end

@implementation TWColdSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)scanAction:(id)sender
{
    TWQRViewController *controller = [[TWQRViewController alloc]init];
    __weak typeof(self) wself = self;
    controller.captureBlock = ^(NSString *metaObbj) {
        [wself jumpToSign:metaObbj];
    };
    if (_pushControllerBlock) {
        _pushControllerBlock(controller);
    }
}

-(void)jumpToSign:(NSString *)qr
{
    TWColdSignTranscationViewController *controller = [[TWColdSignTranscationViewController alloc]initWithNibName:@"TWColdSignTranscationViewController" bundle:nil];
    [controller updateTranscation:qr];
    
    if (_pushControllerBlock) {
        _pushControllerBlock(controller);
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
