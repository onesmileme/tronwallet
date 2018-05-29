//
//  TWVoteViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWVoteViewController.h"
#import "TWCandicateViewController.h"
#import "TWYourVotesViewController.h"
#import "TWTopScrollView.h"

#define kTopScrollHeight 40

@interface TWVoteViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property(nonatomic , strong) TWTopScrollView *topScrollView;
@property(nonatomic , strong) UIPageViewController *pageContainerViewController;
@property(nonatomic , strong) NSArray *controllers;
@property(nonatomic , strong) TWCandicateViewController *canController;
@property(nonatomic , strong) TWYourVotesViewController *ownController;

@end

@implementation TWVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11.0 , *)) {
        insets = [[[UIApplication sharedApplication] keyWindow] safeAreaInsets];
    }
    
    NSArray *items = @[@"CADIDATES",@"YOUR VOTES"];
    _topScrollView = [[TWTopScrollView alloc]initWithFrame:CGRectMake(0, insets.top+ 64, CGRectGetWidth(self.view.bounds), kTopScrollHeight) items:items type:TWTopScrollViewTypeEqualWidth];
    [self.view addSubview:_topScrollView];
    __weak typeof(self) wself = self;
    _topScrollView.chooseBlock = ^(NSInteger index,NSInteger lastIndex) {
        UIViewController *controller = wself.controllers[index];
        [wself.pageContainerViewController setViewControllers:@[controller] direction:index>=lastIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    };
    
    _pageContainerViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageContainerViewController.dataSource = self;
    _pageContainerViewController.delegate = self;
    _pageContainerViewController.view.backgroundColor = [UIColor themeDarkBgColor];
    
    
    CGRect frame = [[UIScreen mainScreen]bounds];
    frame.size.height -= (insets.bottom+kTopScrollHeight + 49 + 64);
    frame.origin.y = CGRectGetMaxY(_topScrollView.frame);
    _pageContainerViewController.view.frame = frame;
    
    
    [self addChildViewController:_pageContainerViewController];
    [_pageContainerViewController didMoveToParentViewController:self];
    
    _canController = [[TWCandicateViewController alloc]init];
    _ownController = [[TWYourVotesViewController alloc]init];
    _controllers = @[_canController,_ownController ];
    
    [_pageContainerViewController setViewControllers:@[_controllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    _pageContainerViewController.view.frame = self.containerView.bounds;
    _pageContainerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:_pageContainerViewController.view];
    
    self.containerView.backgroundColor = [UIColor themeDarkBgColor];
    
    [_topScrollView scrollToShow:0];
    
    [self refrshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refrshUI
{
    TWWalletAccountClient * client =  AppWalletClient ;
    NSMutableArray<Vote*> *voteArray = client.account.votesArray;
    
    NSMutableArray *voteWitness = [NSMutableArray new];
    
    NSInteger totalVotes = 0;
    NSInteger fronzes = 0;
    
    for (Vote *vote in voteArray) {
        totalVotes += vote.voteCount;
    }
    
    for (Account_Frozen *frozen in  client.account.frozenArray) {
        fronzes += frozen.frozenBalance;
    }
    
    long balance = fronzes/kDense;
    _amountLabel.text = [NSString stringWithFormat:@"%@ / %@",@(balance - totalVotes),@(balance)];
    
}

-(IBAction)submitAction:(id)sender
{
    if (self.canController.voteWitness.count == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Please choose Votes";
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    
    Wallet *wallet = [[TWNetworkManager sharedInstance] walletClient];
    VoteWitnessContract *contract = [VoteWitnessContract new];
    contract.ownerAddress = [AppWalletClient address];
    for (TWVoteWitnessModel *model in self.canController.voteWitness) {
        VoteWitnessContract_Vote *vote = [VoteWitnessContract_Vote new];
        vote.voteAddress = model.witness.address;
        [contract.votesArray addObject:vote];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [wallet voteWitnessAccountWithRequest:contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        if (error) {
            hud.label.text = [NSString stringWithFormat:@"%@",error];
        }else{
            [AppWalletClient refreshAccount:^(Account *account, NSError *error) {
                [self refrshUI];
            }];
            [self.canController refresh];
            [self.ownController refresh];
        }
    }];
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

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    UIViewController *controller = [pendingViewControllers firstObject];
    NSInteger index = [self.controllers indexOfObject:controller];
    [self.topScrollView scrollToShow:index];
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
