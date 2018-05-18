//
//  MainInfoViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/16.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWMainInfoViewController.h"
#import "TWTopScrollView.h"
#import "TWAccountViewController.h"
#import "TWBlockChainViewController.h"
#import "TWNodesViewController.h"
#import "TWRepresentativeViewController.h"
#import "TWTokensViewController.h"

#define kTopScrollHeight 40

@interface TWMainInfoViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property(nonatomic , strong) TWTopScrollView *topScrollView;
@property(nonatomic , strong) UIPageViewController *pageContainerViewController;
@property(nonatomic , strong) NSArray *controllers;

@end

@implementation TWMainInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11.0 , *)) {
        insets = [[[UIApplication sharedApplication] keyWindow] safeAreaInsets];
    }
    
    _topScrollView = [[TWTopScrollView alloc]initWithFrame:CGRectMake(0, insets.top+ 64, CGRectGetWidth(self.view.bounds), kTopScrollHeight)];
    [self.view addSubview:_topScrollView];
    
    _pageContainerViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageContainerViewController.dataSource = self;
    _pageContainerViewController.delegate = self;
    

    
    CGRect frame = [[UIScreen mainScreen]bounds];
    frame.size.height -= (insets.bottom+kTopScrollHeight + 49 + 64);
    frame.origin.y = CGRectGetMaxY(_topScrollView.frame);
    _pageContainerViewController.view.frame = frame;
    
    
    [self addChildViewController:_pageContainerViewController];
    [_pageContainerViewController didMoveToParentViewController:self];
    
    _controllers = @[[[TWBlockChainViewController alloc]init],
                     [[TWRepresentativeViewController alloc]init],
                     [[TWNodesViewController alloc]init],
                     [[TWTokensViewController alloc]init],
                     [[TWAccountViewController alloc]init]
                     ];
    [_pageContainerViewController setViewControllers:@[_controllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.view addSubview:_pageContainerViewController.view];
    
    for (int i = 0 ; i < _controllers.count ; i++) {
        UIViewController *controller = _controllers[i];
        controller.view.backgroundColor = i % 2 == 0 ? [UIColor redColor] : [UIColor greenColor];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"nav bar is: %@",self.navigationController.navigationBar);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [_controllers indexOfObject:viewController];
    if (index <= 0) {
        return nil;
    }
    return _controllers[index-1];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [_controllers indexOfObject:viewController];
    if (index < 0 || index >= [_controllers count] - 1) {
        return nil;
    }
    return _controllers[index+1];
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
