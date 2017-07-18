//
//  MNAlertView.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MNAlertViewDelegate <NSObject>

@optional


@end

@interface MNAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content buttons:(NSArray <NSString *> *)buttons delegate:(id<MNAlertViewDelegate>)delegate;

@end
