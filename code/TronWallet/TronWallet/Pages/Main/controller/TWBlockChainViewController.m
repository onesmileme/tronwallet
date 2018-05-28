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
@property(nonatomic, readwrite, strong) NSMutableArray<Block*> *blockArray;
@property(nonatomic, readwrite, strong) NSMutableArray<Transaction*> *transactionsArray;

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

-(void)requestBlock
{
    Wallet *walletClient = [[TWNetworkManager sharedInstance] walletClient];
    NumberMessage *numMsg = [NumberMessage new];
    numMsg.num = 25;
    
    [walletClient getBlockByLatestNumWithRequest:numMsg handler:^(BlockList * _Nullable response, NSError * _Nullable error) {
        BOOL success = NO;
        if (response.blockArray_Count > 0) {
            success = YES;
            self.blockArray = [[response.blockArray sortedArrayUsingComparator:^NSComparisonResult(Block * _Nonnull obj1, Block*  _Nonnull obj2) {
                return obj1.blockHeader.rawData.number - obj2.blockHeader.rawData.number;
            }] mutableCopy];
            if (!self.transactionsArray) {
                self.transactionsArray = [NSMutableArray new];
            }else{
                [self.transactionsArray removeAllObjects];
            }
            for (Block *b in self.blockArray) {
                [self.transactionsArray addObjectsFromArray:b.transactionsArray];
            }
            
        }
        [self requestDone:success];        
    }];
    
    
    
}

-(void)startRequest
{
    [self requestBlock];
    [self requestDone:YES];
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
        
        [blockCell updateWithModel:self.blockArray];
        
    }else{
        
        TWMainRecentTransactionTableViewCell *recentCell = [tableView dequeueReusableCellWithIdentifier:@"recent_cell"];
        
        cell = recentCell;
        
        [recentCell bindData:self.transactionsArray];
        
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
    infoTip.tipLabel.text = (section == 0? @"    BLOCKCHAIN":@"    RECENT TRANSACTIONS");
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
