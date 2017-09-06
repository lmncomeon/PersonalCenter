//
//  MNStatusTipView.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/6.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "MNStatusTipView.h"
#import "SDKCustomLabel.h"
#import "UIView+CustomView.h"
#import "SDKProjectHeader.h"

@interface MNStatusTipView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger num;

@property (nonatomic, strong) UIWindow *keyWindow;

@end

@implementation MNStatusTipView

- (instancetype)initWithFrame:(CGRect)frame tip:(NSString *)tip bgColor:(UIColor *)bgColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, -adaptY(52), kScreenWidth, adaptY(52));
        self.backgroundColor = bgColor;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];
        
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:tip attributes:@{NSFontAttributeName : kFont(14), NSForegroundColorAttributeName : commonWhiteColor, NSParagraphStyleAttributeName: paragraphStyle}];

        SDKCustomLabel *lab = [SDKCustomLabel setLabelAttrTitle:attr setLabelFrame:CGRectMake(adaptX(16), 0, kScreenWidth-2*adaptX(16), self.height)];
        lab.numberOfLines = 0;
        [self addSubview:lab];
        
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTipAnimation)]];
        
    }
    return self;
}

- (void)showTipAnimation {
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _keyWindow.windowLevel = UIWindowLevelAlert;
    [_keyWindow addSubview:self];
        
    HXWeak_self
    [UIView animateWithDuration:_animationDuration ? : 0.5f
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:0
                     animations: ^{
        self.y += self.height;
                         
     }
                     completion:^(BOOL finished) {
        HXStrong_self
        
        [self startTimer];
    }];
    
}

- (void)startTimer {
    _num = 0;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(add) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)add {
    _num++;
    
    _dismissTime = _dismissTime ? : 3;
    
    if (_num == _dismissTime) {
        [self hideTipAnimation];
    }
    
}

- (void)hideTipAnimation {
    [_timer invalidate];
    _timer = nil;
    
    HXWeak_self
    CGFloat animate = _animationDuration ? : 0.5f;
    [UIView animateWithDuration:animate animations:^{
        self.y -= self.height;
    } completion:^(BOOL finished) {
        HXStrong_self
        [self removeFromSuperview];
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _keyWindow.windowLevel = UIWindowLevelNormal;;
    });
}

@end
