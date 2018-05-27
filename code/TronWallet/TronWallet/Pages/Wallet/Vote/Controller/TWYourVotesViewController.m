//
//  TWYourVotesViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWYourVotesViewController.h"
#import "TWCandicateTableViewCell.h"

@interface TWYourVotesViewController ()

@property(nonatomic , strong) NSMutableDictionary *voteMap;
@property(nonatomic , strong) NSMutableArray<Witness*> *witnessesArray;

@end

@implementation TWYourVotesViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    UINib *nib = [UINib nibWithNibName:@"TWCandicateTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell_id"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startRequest
{
    Wallet *wallet = [[TWNetworkManager sharedInstance] walletClient];
    [wallet listWitnessesWithRequest:[EmptyMessage new] handler:^(WitnessList * _Nullable response, NSError * _Nullable error) {
        
        BOOL success = NO;
        if (response.witnessesArray_Count > 0) {
            success = YES;
            self.witnessesArray = response.witnessesArray;
        }
        [self requestDone:success];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _witnessesArray.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWCandicateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id" forIndexPath:indexPath];
    cell.votesFields.enabled = NO;
    
//    if (!cell.updateVotes) {
//        __weak typeof(self) wself = self;
//        cell.updateVotes = ^(NSInteger votes, NSInteger index) {
//            wself.voteMap[@(index)] = @(votes);
//        };
//    }
//
    // Configure the cell...
    NSInteger index = indexPath.section+1;
    Witness *witness = _witnessesArray[indexPath.section];
    NSInteger votes = [self.voteMap[@(indexPath.section+1)] integerValue];
    [cell updateWithModel:witness index:index votes:votes];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section < _witnessesArray.count - 1) {
        return 2;
    }
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}

@end