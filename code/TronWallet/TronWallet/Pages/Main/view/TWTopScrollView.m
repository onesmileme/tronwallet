//
//  TWTopScrollView.m
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWTopScrollView.h"
#import "NSString+TKSize.h"

#define kTitleFont [UIFont boldSystemFontOfSize:16]

@interface TWScrollItemViewCell : UICollectionViewCell

@property(nonatomic , strong) UILabel *titleLabel;

@end

@interface TWTopScrollView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic , strong) UICollectionView *collectionView;
@property(nonatomic , strong) NSArray *items;
@end

@implementation TWTopScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor themeRed];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[TWScrollItemViewCell class] forCellWithReuseIdentifier:@"cellid"];
        [self addSubview:_collectionView];
        
        _items = @[@"BLOCKCHAIN",@"REPRESENTATIVES",@"NODES",@"TOKENS",@"ACCOUNT"];
        
        self.backgroundColor = [UIColor whiteColor];
        
        
    }
    return self;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TWScrollItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    NSString *title = _items[indexPath.item];
    
    cell.titleLabel.text = title;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = _items[indexPath.item];
    CGSize size = [title sizeWithMaxWidth:1000 font:kTitleFont];
    
    size.width += 20;
    
    if (size.width < 60) {
        size.width = 60;
    }
    
    return CGSizeMake(size.width, CGRectGetHeight(collectionView.bounds));
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation TWScrollItemViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kTitleFont;
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
