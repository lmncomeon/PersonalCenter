//
//  AdvertisingView.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/8/8.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertisingView : UIView

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSString *)videoUrl duration:(NSInteger)duration;

- (void)endPlayer;

@property (nonatomic, copy) dispatch_block_t playEndBlock;

@end
