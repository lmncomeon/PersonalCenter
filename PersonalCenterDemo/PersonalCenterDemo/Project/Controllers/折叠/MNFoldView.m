//
//  MNFoldView.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/5.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "MNFoldView.h"

@interface MNFoldView ()

@property (nonatomic, assign) BOOL currentSpread;

@end

@implementation MNFoldView

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _topView.backgroundColor = [UIColor orangeColor];
        _topView.userInteractionEnabled = true;
        [_topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
        [self addSubview:_topView];
        
        CGFloat iconWH = adaptX(10);
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(adaptX(16), adaptY(10), iconWH, iconWH)];
        icon.backgroundColor = [UIColor purpleColor];
        [_topView addSubview:icon];
        
        _topLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(CGRectGetMaxX(icon.frame), adaptY(5), kScreenWidth - CGRectGetMaxX(icon.frame) - adaptX(16), 0) setLabelColor:[UIColor blackColor] setLabelFont:kFont(12)];
        _topLab.numberOfLines = 0;
        [_topView addSubview:_topLab];
        
        _topView.height = CGRectGetMaxY(_topView.subviews.lastObject.frame);
    }
    return _topView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth, 0)];
        _bottomView.layer.masksToBounds = true;
        [self addSubview:_bottomView];
        
        
        CGFloat iconWH = adaptX(10);
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(adaptX(16), adaptY(10), iconWH, iconWH)];
        icon.backgroundColor = [UIColor purpleColor];
        [_bottomView addSubview:icon];
        
        _bottomLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(CGRectGetMaxX(icon.frame), adaptY(5), kScreenWidth - CGRectGetMaxX(icon.frame) - adaptX(16), 0) setLabelColor:[UIColor blackColor] setLabelFont:kFont(12)];
        _bottomLab.layer.masksToBounds = true;
        _bottomLab.numberOfLines = 0;
        [_bottomView addSubview:_bottomLab];
        
        
        _bottomView.height = CGRectGetMaxY(_bottomView.subviews.lastObject.frame);
    }
    return _bottomView;
}

- (instancetype)initWithFrame:(CGRect)frame model:(FoldModel *)model spread:(BOOL)spread
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bottomView];
        
        _currentSpread = spread;
    }
    return self;
}

- (void)tap {
    _currentSpread = !_currentSpread;
    
    HXWeak_self
    [self updateAnimationWithBolck:^{
        HXStrong_self
        
        !self.updateHeight ? : self.updateHeight();
    }];
}

- (void)updateAnimationWithBolck:(dispatch_block_t)block {
    HXWeak_self
    [UIView animateWithDuration:0.5 animations:^{
        HXStrong_self
        
        self.bottomLab.height = self.currentSpread ? self.currentBottomH : 0;
        self.bottomView.height = self.currentSpread ? CGRectGetMaxY(self.bottomView.subviews.lastObject.frame) + margin : 0;
        self.height = CGRectGetMaxY(self.bottomView.frame);
        
        if (block) {
            block();
        }
        
    }];
    
}

- (void)setSpread:(BOOL)spread {
    _spread = spread;
    
    if (spread == _currentSpread) return;
    
    _currentSpread = spread;
    
    [self updateAnimationWithBolck:nil];
}

@end
