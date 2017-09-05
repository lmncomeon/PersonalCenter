//
//  MNPrettyAvatar.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/1.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNPrettyAvatar : UIView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName;

@property (nonatomic, strong) UIColor *borderColor;

@end
