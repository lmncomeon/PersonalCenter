//
//  PWDView.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/27.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWDView : UIView

- (instancetype)initWithFrame:(CGRect)frame inputCount:(NSInteger)inputCount;

- (NSString *)getPWD;


@property (nonatomic, strong) UIColor *borderColor;

@end
