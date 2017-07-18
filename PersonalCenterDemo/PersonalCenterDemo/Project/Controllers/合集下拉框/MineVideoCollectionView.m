//
//  MineVideoCollectionView.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "MineVideoCollectionView.h"
#import "UIView+CustomView.h"
#import "SDKProjectHeader.h"

#import "SDKCustomLabel.h"

#define maxCount 5
#define itemH    adaptY(40)

@interface MineVideoCollectionView ()

@property (nonatomic, strong) UIScrollView *container;

@property (nonatomic, strong) NSMutableArray *defaultArr;

@end

@implementation MineVideoCollectionView

- (instancetype)initWithFrame:(CGRect)frame list:(NSArray <NSString *> *)list {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelfAction)]];
    
        
        if (list && list.count) { [self.defaultArr addObjectsFromArray:list]; }

        _container = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
        _container.backgroundColor = [UIColor whiteColor];
        [self addSubview:_container];
        
        [self createUIWithFirst:true];
        
    }
    return self;
}

- (void)createUIWithFirst:(BOOL)first {
    CGFloat currentCount = self.defaultArr.count > maxCount ? maxCount : self.defaultArr.count;
    CGFloat containerH   =  currentCount*itemH;
    
    [UIView animateWithDuration:0.5 animations:^{
        _container.height = containerH;
        _container.y = first ? kScreenHeight : kScreenHeight-_container.height;
        _container.contentSize = CGSizeMake(0, self.defaultArr.count*itemH+adaptY(10));
        
        if (self.defaultArr.count > maxCount) {
            _container.contentOffset = CGPointMake(0, itemH);
        }
    }];
    
    for (int i = 0; i < self.defaultArr.count; i++) {
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0, i*itemH, kScreenWidth, itemH)];
        item.tag = 10000 +i;//tag
        [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [_container addSubview:item];
        
        // icon
        CGFloat iconWH = itemH;
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconWH, iconWH)];
        icon.backgroundColor = [UIColor orangeColor];
        icon.layer.masksToBounds = true;
        icon.layer.cornerRadius = iconWH*0.5;
        [item addSubview:icon];
        
        // text
        SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:self.defaultArr[i] setLabelFrame:CGRectMake(CGRectGetMaxX(icon.frame), 0, kScreenWidth-CGRectGetMaxX(icon.frame), itemH) setLabelColor:[UIColor blackColor] setLabelFont:kFont(14)];
        [item addSubview:lab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(lab.x, itemH-0.5f, kScreenWidth-lab.x, 0.5f)];
        line.backgroundColor = cuttingLineColor;
        [item addSubview:line];
    }
}

- (void)tap:(UITapGestureRecognizer *)sender {
    NSInteger index = sender.view.tag-10000;
    
    if (index == 0) {
        // 分享
        !_shareEvent ? : _shareEvent();
        
        [self collectionHide];
        
    } else if (index == 1) {
        // 新建合集
        !_createEvent ? : _createEvent();
    } else {
        !_otherEvent ? : _otherEvent(self.defaultArr[index]);
        
        [self collectionHide];
    }
}

- (void)tapSelfAction {
    [self collectionHide];
}

- (void)collectionShow {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5f animations:^{
        _container.y -= _container.height;
    }];
}

- (void)collectionHide {
    [UIView animateWithDuration:0.5f animations:^{
        _container.y += _container.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)reloadDataViewWithValue:(NSString *)value {
    [_container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.defaultArr insertObject:value atIndex:2];
    
    [self createUIWithFirst:false];
}

#pragma mark - lazy load
- (NSMutableArray *)defaultArr {
    if (!_defaultArr) {
        _defaultArr = @[@"分享", @"新建集合"].mutableCopy;
    }
    return _defaultArr;
}

@end
