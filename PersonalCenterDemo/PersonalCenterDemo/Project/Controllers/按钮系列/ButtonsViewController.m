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
}

@end
