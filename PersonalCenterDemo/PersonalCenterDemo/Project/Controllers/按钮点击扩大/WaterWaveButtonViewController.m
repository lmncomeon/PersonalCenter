//
//  WaterWaveButtonViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/8/28.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "WaterWaveButtonViewController.h"
#import "MNWaterBtn.h"

@interface WaterWaveButtonViewController ()

@end

@implementation WaterWaveButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MNWaterBtn *waterBtn = [[MNWaterBtn alloc] initWithFrame:CGRectMake(10, 100, kScreenWidth-20, 60)];
    waterBtn.backgroundColor = [UIColor greenColor];
    waterBtn.waterColor = [UIColor yellowColor];
    [waterBtn setTitle:@"click" forState:UIControlStateNormal];
    [waterBtn setTitleColor:commonWhiteColor forState:UIControlStateNormal];
    [waterBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:waterBtn];
    
}

- (void)btnAction {
    DLog(@"UIControlEventTouchDown");
}

@end
