//
//  TWMainRecentBlockTableViewCell.m
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWMainRecentBlockTableViewCell.h"
#import "TWMainBlockInfoTableViewCell.h"

@interface TWMainRecentBlockTableViewCell()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic , strong) UITableView *tableView;
@property(nonatomic , strong) NSArray *datas;

@end

@implementation TWMainRecentBlockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.tableView];
        self.contentView.backgroundColor = [UIColor themeDarkBgColor];
    }
    return self;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        CGRect frame = CGRectInset(self.bounds, 20, 0);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UINib *nib = [UINib nibWithNibName:@"TWMainBlockInfoTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"cellid"];
        
        _tableView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
}

-(void)bindData:(id)data
{
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    _tableView.frame = CGRectInset(self.bounds, 20, 0);
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;//_datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWMainBlockInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

@end
