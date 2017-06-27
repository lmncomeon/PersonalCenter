//
//  RightLoadView.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/27.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "RightLoadView.h"
#import "RightLoadModel.h"
#import "SDKCustomLabel.h"
#import "SDKProjectHeader.h"
#import "UIView+CustomView.h"

@interface RightLoadView () <UIScrollViewDelegate>

@property (nonatomic, strong) SDKCustomLabel *showLab;

@end

@implementation RightLoadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = false;
        self.delegate = self;
        

    }
    return self;
}

- (void)setDataList:(NSArray<RightLoadModel *> *)dataList {
    _dataList = dataList;
    
    if (!dataList) return;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat margin  = adaptX(5);
    CGFloat padding = adaptX(2);
    
    CGFloat itemH   = adaptY(50);
    CGFloat itemW   = adaptX(120);
    
    for (int i = 0; i < dataList.count; i++) {
        UIImageView *item = [[UIImageView alloc] initWithFrame:CGRectMake(margin+i*(itemW+padding), margin, itemW, itemH)];
        item.backgroundColor = [UIColor orangeColor];
        [self addSubview:item];
        
        SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:dataList[i].title setLabelFrame:CGRectMake(adaptX(5), 0, itemW-adaptX(5)*2, itemH) setLabelColor:[UIColor whiteColor] setLabelFont:kFont(12) setAlignment:1];
        lab.numberOfLines = 0;
        [item addSubview:lab];
    
        self.height = CGRectGetMaxY(item.frame) + margin;
        self.contentSize = CGSizeMake(CGRectGetMaxX(item.frame) + margin, 0);
    }
    
    _showLab = [SDKCustomLabel setLabelTitle:@"多更滑左" setLabelFrame:CGRectMake(self.frame.size.width + adaptX(50), itemH-30, itemH, 20) setLabelColor:[UIColor blackColor] setLabelFont:kFont(10) setAlignment:1];
    _showLab.transform = CGAffineTransformMakeRotation(M_PI_2*3);
    [self addSubview:_showLab];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat defaultOffsetX = self.contentSize.width - self.frame.size.width;
    
    CGFloat del = scrollView.contentOffset.x - defaultOffsetX;
    
    
    if (del >= 60) {
        _showLab.text = @"载加放释";
    } else {
        _showLab.text = @"多更滑左";
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGFloat defaultOffsetX = self.contentSize.width - self.frame.size.width;
    
    CGFloat del = scrollView.contentOffset.x - defaultOffsetX;
    
    if (del >= 60) {
        !_loadMore ? : _loadMore();
    }
}

@end
