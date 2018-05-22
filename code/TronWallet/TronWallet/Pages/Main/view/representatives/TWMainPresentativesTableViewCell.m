//
//  TWMainPresentativesTableViewCell.m
//  TronWallet
//
//  Created by chunhui on 2018/5/20.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWMainPresentativesTableViewCell.h"
#import "NSData+HexToString.h"

@implementation TWMainPresentativesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateWithModel:(Witness *)model index:(NSInteger)index
{
    self.indexLabel.text = [NSString stringWithFormat:@"#%ld",index];
    
//
//    NSLog(@"address is: %@ \n or %@\n\n",[model.address convertToHexStr],[model.address dataToHexString]);
//
//    const unsigned char * bytes =  [model.address bytes];
//    for (int i = 0 ; i < model.address.length; i++) {
//        unsigned char c = (unsigned char )bytes[i];
//        printf("%c int value %d\n",c,(int)c);
//    }
    
    self.urlLabel.text = model.URL;
    self.idLabel.text =  [[NSString alloc] initWithData:model.address encoding:NSUTF8StringEncoding];
    self.votesLabel.text = [NSString stringWithFormat:@"Votes :  %lld",model.voteCount];
    self.blockLabel.text = [NSString stringWithFormat:@"Last BlockNum: %lld",model.latestBlockNum];
    self.productIdLabel.text = [NSString stringWithFormat:@"TotalProduced:  %lld",model.totalProduced];
    self.missLabel.text = [NSString stringWithFormat:@"TotalMissed: %lld",model.totalMissed];
    
}

@end
