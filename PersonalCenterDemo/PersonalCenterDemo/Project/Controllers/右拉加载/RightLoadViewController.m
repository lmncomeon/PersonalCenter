//
//  RightLoadViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/27.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "RightLoadViewController.h"
#import "RightLoadView.h"
#import "RightLoadModel.h"
#import "PWDViewController.h"

@interface RightLoadViewController ()

@end

@implementation RightLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:5];
    [tmp addObject:[RightLoadModel loadWithTitle:@"你好" imageName:@""]];
    [tmp addObject:[RightLoadModel loadWithTitle:@"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈" imageName:@""]];
    [tmp addObject:[RightLoadModel loadWithTitle:@"你好" imageName:@""]];
    
    HXWeak_self
    RightLoadView *loadView = [[RightLoadView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, 0)];
    loadView.dataList = tmp.copy;
    loadView.loadMore = ^ () {
        HXStrong_self
        
        [self.navigationController pushViewController:[PWDViewController new] animated:true];
    };
    [self.view addSubview:loadView];
}

@end
