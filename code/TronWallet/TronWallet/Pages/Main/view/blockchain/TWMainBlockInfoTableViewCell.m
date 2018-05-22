//
//  TWMainBlockInfoTableViewCell.m
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWMainBlockInfoTableViewCell.h"
#import "TKCommonTools.h"

@implementation TWMainBlockInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateWithModel:(BlockHeader *)model index:(NSInteger)index
{
    BlockHeader_raw *data =  model.rawData;
    self.indexLabel.text = [NSString stringWithFormat:@"#%ld",data.number];        
    self.accountLabel.text =  [[NSString alloc]initWithData:data.witnessAddress encoding:NSUTF8StringEncoding ];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:data.timestamp];
    NSString *time = [TKCommonTools dateDescForDate:date];
    [self.timeButton setTitle:time forState:UIControlStateNormal];
}


@end
