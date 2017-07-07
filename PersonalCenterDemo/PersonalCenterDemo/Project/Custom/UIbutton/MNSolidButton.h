//
//  MNSolidButton.h
//  ExtensionsDemo
//
//  Created by 栾美娜 on 2017/7/7.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNSolidButton : UIView

+ (instancetype)btnWithFrame:(CGRect)frame
                     padding:(CGFloat)padding
                 ornerRadius:(CGFloat)cornerRadius
                       title:(NSString *)title
                  titleColor:(UIColor *)titleColor
                        font:(UIFont *)font
             backgroundColor:(UIColor *)backgroundColor
        solidBackgroundColor:(UIColor *)solidBackgroundColor
                  clickEvent:(dispatch_block_t)clickEvent;

@end
