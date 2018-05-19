//
//  TWBlockChainViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWBlockChainViewController.h"
#import "TWMainRecentBlockTableViewCell.h"
#import "TWMainRecentTransactionTableViewCell.h"
#import "TWMainInfoTipHeader.h"

@interface TWBlockChainViewController ()

@property(nonatomic , strong) TWMainRecentBlockTableViewCell *blockCell;
@property(nonatomic , strong) TWMainRecentBlockTableViewCell *recentCell;

@end

@implementation TWBlockChainViewController

- (void)viewDidLoad {
    
    self.showSearcher = NO;
    
    [super viewDidLoad];
    
    [self.tableView registerClass:[TWMainRecentBlockTableViewCell class] forCellReuseIdentifier:@"block_cell"];
    [self.tableView registerClass:[TWMainRecentTransactionTableViewCell class] forCellReuseIdentifier:@"recent_cell"];

    self.tableView.allowsSelection = NO;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 10)];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    self.tableView.backgroundColor = [UIColor themeDarkBgColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    // Configure the cell...
    if (indexPath.section == 0) {
        
        TWMainRecentBlockTableViewCell *blockCell = [tableView dequeueReusableCellWithIdentifier:@"block_cell"];
        
        cell = blockCell;
        
    }else{
        
        TWMainRecentTransactionTableViewCell *recentCell = [tableView dequeueReusableCellWithIdentifier:@"recent_cell"];
        
        
        cell = recentCell;
        
    }
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGRectGetHeight(tableView.frame)-110)/2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TWMainInfoTipHeader *infoTip = [[TWMainInfoTipHeader alloc]init];
    infoTip.tipLabel.text = (section == 0? @"    BLOCKCHAIN":@"    RECENT");
    return infoTip;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
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
