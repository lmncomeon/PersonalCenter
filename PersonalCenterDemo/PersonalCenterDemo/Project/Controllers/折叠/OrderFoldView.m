//
//  OrderFoldView.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/6.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "OrderFoldView.h"



@implementation OrderFoldView

- (instancetype)initWithFrame:(CGRect)frame model:(FoldModel *)model spread:(BOOL)spread {
    self = [super initWithFrame:frame model:model spread:spread];
    if (self) {
        self.topLab.text   = model.title;
        self.bottomLab.text = model.content;
        
        
        CGFloat topH =  [SDKAboutText calculateTextHeight:model.title maxWidth:self.topLab.width font:self.topLab.font];
        self.topLab.height = topH;
        self.topView.height = CGRectGetMaxY(self.topView.subviews.lastObject.frame) + margin;
        
        self.bottomView.y = CGRectGetMaxY(self.topView.frame);
        
        CGFloat bottomH = [SDKAboutText calculateTextHeight:model.content maxWidth:self.bottomLab.width font:self.bottomLab.font];
        self.bottomLab.height = spread ? bottomH : 0;
        self.bottomView.height = spread ? CGRectGetMaxY(self.bottomView.subviews.lastObject.frame) + margin : 0;
        
        self.height = CGRectGetMaxY(self.bottomView.frame);
        
        
        // 传值
        self.currentBottomH = bottomH;
        
    }
    return self;
}

@end
