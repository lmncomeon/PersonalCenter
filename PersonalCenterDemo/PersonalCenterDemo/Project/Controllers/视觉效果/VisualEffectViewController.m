//
//  VisualEffectViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/26.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "VisualEffectViewController.h"

@interface VisualEffectViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *moveView;

@property (nonatomic, strong) UIView *aView;

@end

@implementation VisualEffectViewController

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 70)];
        _topView.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:_topView];
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(10, 20, kScreenWidth-20, 30)];
        _container.layer.masksToBounds = true;
        _container.layer.cornerRadius = 15;
        _container.layer.borderWidth = 1;
        _container.layer.borderColor = [UIColor grayColor].CGColor;
        [_topView addSubview:_container];
        [_container addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)]];
        
        
        
        NSArray *arr = @[@"私信", @"评论", @"@我", @"通知"];
        CGFloat btnW = _container.frame.size.width/arr.count;
        CGFloat btnH = 30;
        for (int i = 0; i < arr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*btnW, 0, btnW, btnH);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.tag = 1000+i;//tag
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_container addSubview:btn];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        _moveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnW, btnH)];
        _moveView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _moveView.layer.masksToBounds = true;
        _moveView.layer.cornerRadius = 15;
        [_container addSubview:_moveView];
        
        _aView = [[UIView alloc] initWithFrame:_moveView.bounds];
        [_moveView addSubview:_aView];
        for (int i = 0; i < 4; i++) {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i*btnW, 0, btnW, btnH)];
            lab.text = arr[i];
            lab.textAlignment = 1;
            lab.font = [UIFont systemFontOfSize:14];
            lab.textColor = [UIColor whiteColor];
            [_aView addSubview:lab];
        }
        
    }
    return _topView;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGPoint location = [pan locationInView:_container];
    
    CGFloat btnW = (kScreenWidth-20) / 4;
    
    if (location.x > 3*btnW) {
        return;
    }
    
    
    if (pan.state == UIGestureRecognizerStateBegan ||
        pan.state == UIGestureRecognizerStateChanged)
    {
        [UIView animateWithDuration:0.4 animations:^{
            _moveView.x = location.x;
            _aView.x = -_moveView.x;
        }];
        
    }
    else
    {
        NSInteger index = (location.x + btnW*0.5)/btnW;
        
        [UIView animateWithDuration:0.4 animations:^{
            _moveView.x = btnW*index;
            _aView.x = -_moveView.x;
        }];
    }
    
    
    
    
    
    
    
    NSLog(@"===x:%.2f", location.x);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self topView];
    
    //    [self createTitleView];
    //    [self createViewManagement];
    
}

- (void)btnAction:(UIButton *)sender {
    [UIView animateWithDuration:0.4 animations:^{
        _moveView.x = sender.x;
        _aView.x = -(sender.tag-1000) * (kScreenWidth-20)/4;
    }];
}

@end
