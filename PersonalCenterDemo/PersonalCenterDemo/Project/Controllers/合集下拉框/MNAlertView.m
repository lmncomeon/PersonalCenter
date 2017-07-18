//
//  MNAlertView.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "MNAlertView.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"

@interface MNAlertView ()

@property (nonatomic, strong) SDKCustomLabel *titleLab;

@end

@implementation MNAlertView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content buttons:(NSArray <NSString *> *)buttons delegate:(id<MNAlertViewDelegate>)delegate {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
        
        CGFloat padding = adaptX(50);
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(padding, 0, kScreenWidth-2*padding, 0)];
        container.backgroundColor = UIColorFromRGB(0xf1f1f1);
        [self addSubview:container];
        
//        if (title) {
//            _titleLab = [SDKCustomLabel setLabelTitle:title setLabelFrame:CGRectMake(adaptX(3), <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>), <#const char *#>, <#int#> setLabelColor:<#(UIColor *)#> setLabelFont:<#(UIFont *)#>]
//        }
        
        
    }
    return self;
}

@end
