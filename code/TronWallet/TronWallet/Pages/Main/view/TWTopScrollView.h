//
//  TWTopScrollView.h
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWTopScrollView : UIView

@property(nonatomic , copy) void (^chooseBlock)(NSInteger index, NSInteger lastIndex);

-(void)scrollToShow:(NSInteger)index;

@end
