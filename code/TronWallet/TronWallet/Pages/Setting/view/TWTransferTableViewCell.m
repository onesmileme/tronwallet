//
//  TWTransferTableViewCell.m
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWTransferTableViewCell.h"
#import "TWShEncoder.h"

@implementation TWTransferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)bindData:(NSDictionary *)transaction
{
 
    NSString *from = transaction[@"transferFromAddress"];
    NSString *to = transaction[@"transferToAddress"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[transaction[@"timestamp"] doubleValue]/1000];
    NSString *d = [TKCommonTools dateDescForDate:date];
    NSInteger amount = [transaction[@"amount"] longLongValue]/kDense;
    NSString *hash = transaction[@"transactionHash"];
    
    
    self.fromLabel.text =  from?:@"--";
    self.toLabel.text   =  to?:@"--";
    self.dateLabel.text = d?:@"--";
    self.countLabel.text = [NSString stringWithFormat:@"%ld %@",amount,transaction[@"tokenName"]?:@""];
    self.hashLabel.text = hash?:@"--";
}

@end
