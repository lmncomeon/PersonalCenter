//
//  MNStatusTipView.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/6.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNStatusTipView : UIView

- (instancetype)initWithFrame:(CGRect)frame tip:(NSString *)tip bgColor:(UIColor *)bgColor;

- (void)showTipAnimation;

@property (nonatomic, assign) CGFloat animationDuration; // 默认0.5f
@property (nonatomic, assign) int dismissTime;           // 默认3s

@end
