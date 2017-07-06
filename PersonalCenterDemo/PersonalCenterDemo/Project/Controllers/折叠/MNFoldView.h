//
//  MNFoldView.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/5.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoldModel;

@interface MNFoldView : UIView

- (instancetype)initWithFrame:(CGRect)frame model:(FoldModel *)model spread:(BOOL)spread;

@property (nonatomic, copy) dispatch_block_t updateHeight;

@property (nonatomic, assign) BOOL spread;

@end
