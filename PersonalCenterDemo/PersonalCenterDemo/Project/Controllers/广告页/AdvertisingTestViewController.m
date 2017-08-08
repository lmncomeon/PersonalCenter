//
//  AdvertisingTestViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/8/8.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "AdvertisingTestViewController.h"
#import "AdvertisingView.h"

@interface AdvertisingTestViewController ()

@property (nonatomic, strong) AdvertisingView *testView;

@end

@implementation AdvertisingTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(kScreenWidth/3), kScreenHeight-64-30, kScreenWidth/3, 30);
        btn.backgroundColor = krandomColor;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)btnAction:(UIButton *)sender {
    NSString *url = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    
    [_testView endPlayer];
    
    _testView = [[AdvertisingView alloc] initWithFrame:CGRectMake(10, 64, kScreenWidth-20, 200) videoUrl:url duration:10];
    [self.view addSubview:_testView];
}

@end
