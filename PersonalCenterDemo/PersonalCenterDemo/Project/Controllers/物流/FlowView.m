//
//  FlowView.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/27.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FlowView.h"
#import "FlowModel.h"
#import "SDKCustomLabel.h"
#import "SDKProjectHeader.h"
#import "UIView+CustomView.h"
#import "SDKAboutText.h"

@interface FlowView ()

@end

@implementation FlowView

- (instancetype)initWithFrame:(CGRect)frame data:(FlowModel *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat numWH = adaptX(20);
        SDKCustomLabel *numLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(adaptX(20), adaptY(5), numWH, numWH) setLabelColor:[UIColor blueColor] setLabelFont:kFont(8) setAlignment:1];
        numLab.layer.masksToBounds = true;
        numLab.layer.cornerRadius = numWH*0.5;
        numLab.layer.borderColor = [UIColor blueColor].CGColor;
        numLab.layer.borderWidth = 1;
        numLab.text = [NSString stringWithFormat:@"%ld", (long)data.num];
        numLab.backgroundColor = [UIColor whiteColor];
        [self addSubview:numLab];
        
        
        SDKCustomLabel *titleLab = [SDKCustomLabel setLabelTitle:data.title setLabelFrame:CGRectMake(CGRectGetMaxX(numLab.frame) + adaptX(10), CGRectGetMinY(numLab.frame), kScreenWidth-CGRectGetMaxX(numLab.frame)-adaptX(20), adaptY(20)) setLabelColor:[UIColor blackColor] setLabelFont:kFont(14)];
        [self addSubview:titleLab];
        
        SDKCustomLabel *contentLab = [SDKCustomLabel setLabelTitle:data.content setLabelFrame:CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) + adaptY(4), titleLab.width, 0) setLabelColor:[UIColor blackColor] setLabelFont:kFont(12)];
        contentLab.numberOfLines = 0;
        [self addSubview:contentLab];
        
        contentLab.height = [SDKAboutText calculateTextHeight:data.content maxWidth:contentLab.width font:kFont(12)];
        
        self.height = CGRectGetMaxY(contentLab.frame) + adaptY(10);
                                                                                                     
        if (!data.isLast) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(numLab.centerX, numLab.y, 1, self.height)];
            line.backgroundColor = [UIColor blackColor];
            [self addSubview:line];
            
            [self bringSubviewToFront:numLab];
        }
    }
    return self;
}

@end
