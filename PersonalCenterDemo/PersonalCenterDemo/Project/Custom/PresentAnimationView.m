//
//  PresentAnimationView.m
//  SubscriptionDemo
//
//  Created by 栾美娜 on 2017/6/22.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "PresentAnimationView.h"
#import "SDKProjectHeader.h"
#import "UIView+CustomView.h"

@interface PresentAnimationView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) CGPoint firPoint;

@end

static NSTimeInterval animationDuration = 0.5f;
//最小拖拽返回相应距离
static CGFloat minPanLength = 100.0f;

@implementation PresentAnimationView

- (instancetype)initWithFrame:(CGRect)frame top:(CGFloat)top
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-top);
        self.delegate = self;
        [self addCornerRadiusWithSize:CGSizeMake(5, 5) innerView:self];
        
        [self.panGestureRecognizer addTarget:self action:@selector(panAction:)];
       
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)]];
        
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor orangeColor];
        _contentView.userInteractionEnabled = true;
        [self addSubview:_contentView];

        CGFloat btnWH = adaptX(20);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"关" forState:UIControlStateNormal];
        btn.frame = CGRectMake(kScreenWidth-btnWH-adaptY(10), adaptY(10), btnWH, btnWH);
        [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:btn];
        
        _firPoint = CGPointZero;
    }
    return self;
}

- (void)addCornerRadiusWithSize:(CGSize)size innerView:(UIView *)innerView {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    innerView.layer.mask = maskLayer;
}

- (void)showAction {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.y -= self.height;
    }];
}


- (void)hideAction {
    [UIView animateWithDuration:animationDuration animations:^{
        self.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)close {
    [self hideAction];
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    CGPoint translatedPoint = [recognizer translationInView:self];
    CGFloat x = recognizer.view.center.x + translatedPoint.x;
    CGFloat y = recognizer.view.center.y + translatedPoint.y;
    recognizer.view.center = CGPointMake(x, y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}


- (void)other:(UIPanGestureRecognizer *)pan {
    if (self.contentOffset.y > 0) {return;}
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (ABS(self.contentOffset.y) < minPanLength) {
            
            [self hideAction];
            
        }else{
            
            self.contentInset = UIEdgeInsetsZero;
        }
    }else{
        
        self.contentInset = UIEdgeInsetsMake(-self.contentOffset.y, 0, 0, 0);
            }
}

@end
