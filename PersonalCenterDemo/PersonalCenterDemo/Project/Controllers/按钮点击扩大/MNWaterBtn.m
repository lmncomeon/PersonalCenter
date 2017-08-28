//
//  MNWaterBtn.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/8/28.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "MNWaterBtn.h"

@interface MNWaterBtn () <CAAnimationDelegate>
{
    CAShapeLayer *shapeLayer;
}

@end

@implementation MNWaterBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(touchDown: event:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (void)touchDown:(UIButton *)btn event:(UIEvent *)event {
    [shapeLayer removeFromSuperlayer];
    
    UITouch *touch = event.allTouches.allObjects.firstObject;
    CGPoint po     = [touch locationInView:self];
    
    CGFloat maxX = MAX(po.x, self.frame.size.width - po.x);
    CGFloat maxY = MAX(po.y, self.frame.size.height - po.y);
    CGFloat circleW = MAX(maxX, maxY);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-circleW, -circleW, circleW*2, circleW*2) cornerRadius:circleW];
    
    
    self.layer.masksToBounds = true;
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = self.waterColor.CGColor ? : [UIColor whiteColor].CGColor;
    shapeLayer.opacity = 0.5;
    shapeLayer.anchorPoint = CGPointMake(0.5, 0.5);
    shapeLayer.position = po;
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = 0.f;
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:shapeLayer];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @0;
    scaleAnimation.toValue   = @1;
    scaleAnimation.duration  = 0.5;
    scaleAnimation.delegate  = self;
    [shapeLayer addAnimation:scaleAnimation forKey:@"animation"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [shapeLayer removeFromSuperlayer];
    }
}

- (void)dealloc {
    [shapeLayer removeAnimationForKey:@"animation"];
}

@end
