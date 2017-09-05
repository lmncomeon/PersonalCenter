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
    
    
    // 温度计动画
    [self thermometerAnimation];
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

- (void)thermometerAnimation {
    UIView *mikeView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 30, 100)];
    mikeView.layer.masksToBounds = true;
    mikeView.layer.cornerRadius  = 10;
    mikeView.layer.borderWidth = 2;
    mikeView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:mikeView];
    
    UIView *insideView = [[UIView alloc] initWithFrame:mikeView.bounds];
    insideView.backgroundColor = [UIColor redColor];
    [mikeView addSubview:insideView];
    
    // 默认
    insideView.y = 100;
    insideView.height = 0;
    
    for (int i = 0; i < 10; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((1+i) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.5f animations:^{
                
                if (i % 3 != 0) {
                    insideView.height += 15;
                } else {
                    insideView.height -= 15;
                }
                
                insideView.y = 100 - insideView.height;
            }];
        });
    }
}

@end
