//
//  MNSolidButton.m
//  ExtensionsDemo
//
//  Created by 栾美娜 on 2017/7/7.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "MNSolidButton.h"

@interface MNSolidButton ()

@property (nonatomic, assign) CGRect selfFrame;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, copy)   dispatch_block_t clickEvent;

@end

@implementation MNSolidButton

+ (instancetype)btnWithFrame:(CGRect)frame
                     padding:(CGFloat)padding
                 ornerRadius:(CGFloat)cornerRadius
                       title:(NSString *)title
                  titleColor:(UIColor *)titleColor
                        font:(UIFont *)font
             backgroundColor:(UIColor *)backgroundColor
        solidBackgroundColor:(UIColor *)solidBackgroundColor
                  clickEvent:(dispatch_block_t)clickEvent {
    
    MNSolidButton *btn = [[MNSolidButton alloc] initWithFrame:frame padding:padding cornerRadius:cornerRadius title:title titleColor:titleColor font:font backgroundColor:backgroundColor solidBackgroundColor:solidBackgroundColor clickEvent:clickEvent];
    return btn;
}

- (instancetype)initWithFrame:(CGRect)frame padding:(CGFloat)padding cornerRadius:(CGFloat)cornerRadius title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor solidBackgroundColor:(UIColor *)solidBackgroundColor clickEvent:(dispatch_block_t)clickEvent {
    self = [super initWithFrame:frame];
    if (self) {
        
        _selfFrame = frame;
        _padding   = padding;
        _clickEvent = clickEvent;
       
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        btnView.backgroundColor = solidBackgroundColor;
        btnView.layer.masksToBounds = true;
        btnView.layer.cornerRadius = cornerRadius;
        [self addSubview:btnView];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(padding, 0, frame.size.width-padding, frame.size.height-padding);
        btn.backgroundColor = backgroundColor;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btnView addSubview:btn];
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = cornerRadius;
        [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)btnTouchDown:(UIButton *)sender {
    sender.frame = CGRectMake(0, 0, _selfFrame.size.width, _selfFrame.size.height);
}

- (void)btnAction:(UIButton *)sender {
    sender.frame = CGRectMake(_padding, 0, _selfFrame.size.width-_padding, _selfFrame.size.height-_padding);
    
    if (_clickEvent) {
        _clickEvent();
    }
}

@end
