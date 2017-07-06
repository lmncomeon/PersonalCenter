//
//  MNFoldView.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/5.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKProjectHeader.h"
#import "UIView+CustomView.h"
#import "SDKCustomLabel.h"
#import "SDKAboutText.h"

#import "FoldModel.h"

#define margin adaptY(10)

@interface MNFoldView : UIView

- (instancetype)initWithFrame:(CGRect)frame model:(FoldModel *)model spread:(BOOL)spread;

@property (nonatomic, copy) dispatch_block_t updateHeight;

@property (nonatomic, assign) BOOL spread;



@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) SDKCustomLabel *topLab;
@property (nonatomic, strong) SDKCustomLabel *bottomLab;

@property (nonatomic, assign) CGFloat currentBottomH;


@end
