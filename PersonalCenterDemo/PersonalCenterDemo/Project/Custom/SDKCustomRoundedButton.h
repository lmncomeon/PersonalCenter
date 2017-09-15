//
//  SDKCustomRoundedButton.h
//  coreEnterpriseDW
//
//  Created by 栾美娜 on 16/5/21.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDKCustomRoundedButton : UIButton

+ (instancetype)roundedBtnWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor normalBackgroundColor:(UIColor *)normalBackgroundColor highBackgroundColor:(UIColor *)highBackgroundColor;


+ (instancetype)roundedBtnWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor;

// 自定义圆角
+ (instancetype)customRoundedBtnWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius target:(id)target action:(SEL)action;

@end


/**
 *  带下划线的按钮
 */
@interface SDKCustomUnderlineButton : UIButton

+ (instancetype)underlinebuttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor addTaget:(id)target action:(SEL)action;

@end
