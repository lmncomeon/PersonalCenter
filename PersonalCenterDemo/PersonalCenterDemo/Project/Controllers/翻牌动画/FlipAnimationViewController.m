//
//  FlipAnimationViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/8/28.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FlipAnimationViewController.h"

@interface FlipAnimationViewController ()

@property (nonatomic, strong) UIView *testView;

@property (nonatomic, assign) BOOL left;
@property (nonatomic, strong) UIView *smallView;
@property (nonatomic, strong) UIView *bigView;

@end

@implementation FlipAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _testView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, kScreenWidth-40, kScreenWidth-40)];
    HXWeak_self
    [_testView addSingleTapEvent:^{
        HXStrong_self

        [self addAnimationWithView:self.testView];
    }];
    [self.view addSubview:_testView];
    
    
    _left = true;
    
    _smallView = [[UIView alloc] initWithFrame:_testView.bounds];
    _smallView.backgroundColor = [UIColor yellowColor];
    [_testView addSubview:_smallView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, _smallView.frame.size.width, 30)];
    lab.text = @"hello命名";
    lab.textAlignment = 1;
    [_smallView addSubview:lab];
    
    
    _bigView = [[UIView alloc] initWithFrame:_testView.bounds];
    _bigView.backgroundColor = [UIColor redColor];
    [_testView addSubview:_bigView];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, _bigView.frame.size.width, 30)];
    lab2.textAlignment = 1;
    lab2.text = @"厉害了 娜娜";
    [_bigView addSubview:lab2];
    
    
    _smallView.hidden = false;
    _bigView.hidden   = true;
}



- (void)addAnimationWithView:(UIView *)sub {
    _left = !_left;
    
    UIViewAnimationTransition test = _left ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft;
    
    _smallView.hidden = !_left;
    _bigView.hidden   = _left;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:test forView:sub cache:YES];
    [UIView setAnimationDuration:1];
    [UIView commitAnimations];
}

@end
