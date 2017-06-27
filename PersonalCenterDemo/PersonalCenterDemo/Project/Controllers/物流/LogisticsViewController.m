//
//  LogisticsViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/27.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "LogisticsViewController.h"
#import "FlowView.h"
#import "FlowModel.h"

@interface LogisticsViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation LogisticsViewController

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _mainScrollView.alwaysBounceVertical = true;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:10];
    [tmp addObject:[FlowModel modelWithTitle:@"第一天" content:@"收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额" num:0 isLast:NO]];
    [tmp addObject:[FlowModel modelWithTitle:@"第二天" content:@"收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额" num:1 isLast:NO]];
    [tmp addObject:[FlowModel modelWithTitle:@"第三天" content:@"收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额么额么额么额么额收到了什么额收到了什么额收到了什么额" num:2 isLast:NO]];
    [tmp addObject:[FlowModel modelWithTitle:@"第四天" content:@"收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额什么额收到了什么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额么额收到了什么额" num:3 isLast:NO]];
    [tmp addObject:[FlowModel modelWithTitle:@"第五天" content:@"收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了什么额收到了了什么额" num:4 isLast:YES]];
    
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 0)];
    [self.mainScrollView addSubview:container];
    
    CGFloat itemY = 0;
    for (int i = 0; i < tmp.count; i++) {
        FlowView *item = [[FlowView alloc] initWithFrame:CGRectMake(0, itemY, kScreenWidth, 0) data:tmp[i]];
        [container addSubview:item];
        
        itemY += item.height;
    }
    
    container.height = CGRectGetMaxY(container.subviews.lastObject.frame);
    
    self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(container.frame));
}

@end
