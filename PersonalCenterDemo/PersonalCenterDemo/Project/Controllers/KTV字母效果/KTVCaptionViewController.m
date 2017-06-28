//
//  KTVCaptionViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/28.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "KTVCaptionViewController.h"

@interface KTVCaptionViewController ()

@end

@implementation KTVCaptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"哈哈你好哈哈你好哈哈你好哈哈你好哈哈你好哈哈你好哈哈你好哈哈你好";
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, adaptY(30))];
    background.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:background];
    
    SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:str setLabelFrame:background.bounds setLabelColor:[UIColor whiteColor] setLabelFont:[UIFont systemFontOfSize:12 weight:2]];
    [background addSubview:lab];
    
    
    UIView *show = [[UIView alloc] initWithFrame:background.bounds];
    show.backgroundColor = [UIColor clearColor];
    show.layer.masksToBounds = true;
    [background addSubview:show];
    
    SDKCustomLabel *showLab = [SDKCustomLabel setLabelTitle:str setLabelFrame:show.bounds setLabelColor:[UIColor purpleColor] setLabelFont:[UIFont systemFontOfSize:12 weight:2]];
    [show addSubview:showLab];
    
    // default
    
    show.width = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:8 animations:^{
            show.width = background.size.width;
        }];
    });
}

@end
