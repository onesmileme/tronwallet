//
//  ViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/16.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "ViewController.h"
#import "TKTabControllerIniter.h"
#import "TWAccountViewController.h"

@interface ViewController ()<UITabBarControllerDelegate>

@end

@implementation ViewController

-(void)initItems
{
    BOOL isCold = (AppWalletClient.type == TWWalletCold);
    
    TKTabControllerItem *main = [[TKTabControllerItem alloc]initWithControllerName:@"TWMainInfoViewController" title:@"BLOCK" tabImageName:@"tab_news" selectedImageName:@"tab_news"];
    main.addNavController = true;
    
    TKTabControllerItem *wallet = [[TKTabControllerItem alloc]initWithControllerName:isCold?@"TWColdWalletViewController":@"TWWalletViewController" title:@"WALLET" tabImageName:@"tab_wallet" selectedImageName:@"tab_wallet"];
    wallet.addNavController = true;
    
    TKTabControllerItem *setting = [[TKTabControllerItem alloc]initWithControllerName:@"TWSettingViewController" title:@"SET" tabImageName:@"tab_set" selectedImageName:@"tab_set"];
    setting.addNavController = true;
    
    NSArray *tabItems = @[main,wallet,setting];
    
    NSArray *controllers = [TKTabControllerIniter viewControllersWithItems:tabItems];
    self.viewControllers = controllers;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initItems];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    self.delegate = self;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
}


-(void)reloadAll
{
    //重新创建控件
    [self initItems];
}


-(void)test
{
    UINavigationController *nav = self.viewControllers[0 ];
    
    TWAccountViewController *controller = [[TWAccountViewController alloc] initWithNibName:@"TWAccountViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [controller setupClient:AppWalletClient cold:YES];
    [nav pushViewController:controller animated:YES];
}


#pragma mark -
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{

    return YES;
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //首页手指从最左侧滑动不处理
    if (self.navigationController &&  [[self.navigationController viewControllers] count] == 1) {
        return NO;
    }
    return YES;
}


@end
