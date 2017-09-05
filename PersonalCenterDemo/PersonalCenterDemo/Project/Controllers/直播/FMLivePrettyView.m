//
//  FMLivePrettyView.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/8/29.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FMLivePrettyView.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"
#import "UIView+CustomView.h"
#import "SDKAboutText.h"

@interface FMLivePrettyView ()

@property (nonatomic, strong) SDKCustomLabel *minuteNumLab;
@property (nonatomic, strong) UIScrollView *container;


@property (nonatomic, strong) UIView *rightView; // 这个你做好了
@property (nonatomic, strong) SDKCustomLabel *helloLab;

@end

@implementation FMLivePrettyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createDefaultView];
        
        [self createFMView];
    }
    return self;
}

- (void)createDefaultView {
    NSString *str = @"分钟号 1234";
    _minuteNumLab = [SDKCustomLabel setLabelTitle:str setLabelFrame:CGRectMake(0, adaptY(60), 0, adaptY(20)) setLabelColor:[UIColor whiteColor] setLabelFont:kFont(10) setAlignment:1];
    _minuteNumLab.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    _minuteNumLab.layer.masksToBounds = true;
    _minuteNumLab.layer.cornerRadius  = _minuteNumLab.height*0.5;
    [self addSubview:_minuteNumLab];
    
    CGFloat minuteNumWidth = [SDKAboutText calcaulateTextWidth:str height:_minuteNumLab.height font:_minuteNumLab.font] + adaptX(20);
    _minuteNumLab.width = minuteNumWidth;
    _minuteNumLab.x = kScreenWidth - minuteNumWidth - adaptX(16);
    
    
    
    // container
    _container = [[UIScrollView alloc] initWithFrame:self.bounds];
    _container.backgroundColor = [UIColor clearColor];
    _container.contentSize = CGSizeMake(kScreenWidth*2, 0);
    _container.contentOffset = CGPointMake(kScreenWidth, 0);
    _container.bounces = false;
    [self addSubview:_container];
 
    _rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    _rightView.backgroundColor = [UIColor clearColor];
    [_container addSubview:_rightView];
    
}

- (void)createFMView {
    
    // 在这里继续创建就行了
    _helloLab = [SDKCustomLabel setLabelTitle:@"走开了😄" setLabelFrame:CGRectMake(20, 100, 100, 30) setLabelColor:[UIColor blackColor] setLabelFont:kFont(12)];
    [_rightView addSubview:_helloLab];
    
}

@end
