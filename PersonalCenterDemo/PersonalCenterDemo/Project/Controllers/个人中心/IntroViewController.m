//
//  IntroViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/26.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation IntroViewController

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _mainScrollView.backgroundColor = [UIColor redColor];
        _mainScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight*1.5);
        _mainScrollView.delegate = self;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:@"12345" setLabelFrame:CGRectMake(0, 0, kScreenWidth, adaptY(30)) setLabelColor:[UIColor blackColor] setLabelFont:kFont(14)];
    [self.mainScrollView addSubview:lab];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;
    if (velocity < -5) {
        // 隐藏
        !_scrollDerictionEvent ? : _scrollDerictionEvent(YES);
    }else if (velocity > 5) {
        // 显示
        !_scrollDerictionEvent ? : _scrollDerictionEvent(NO);
    }
}

@end
