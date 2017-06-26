//
//  OneViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/26.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "OneViewController.h"
#import "PersonalCenterViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
}

- (void)tapAction {
    PersonalCenterViewController *centerVC = [PersonalCenterViewController new];
    centerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:centerVC animated:true];
}

@end
