//
//  ButtonsViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/7.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "ButtonsViewController.h"
#import "MNSolidButton.h"

@interface ButtonsViewController ()

@end

@implementation ButtonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MNSolidButton *btn = [MNSolidButton btnWithFrame:CGRectMake(10, 10, 100, 30) padding:3 ornerRadius:3 title:@"hello" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] backgroundColor:[UIColor blackColor] solidBackgroundColor:[UIColor grayColor] clickEvent:^{
        NSLog(@"====click");
    }];
    [self.view addSubview:btn];
    
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(adaptX(20), CGRectGetMaxY(btn.frame) + adaptY(10), kScreenWidth-2*adaptX(20), adaptY(80))];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(adaptX(5), 0.5f, blackView.width-adaptX(5)-0.5f, blackView.height-adaptX(5)-0.5f)];
    container.backgroundColor = [UIColor whiteColor];
    [blackView addSubview:container];
    
    UIButton *speBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    speBtn.frame = container.bounds;
    [speBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [speBtn addTarget:self action:@selector(speBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:speBtn];
}

- (void)speBtnAction {
    
}

@end
