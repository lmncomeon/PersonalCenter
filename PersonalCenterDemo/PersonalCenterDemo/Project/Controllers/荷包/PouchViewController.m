//
//  PouchViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/5.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "PouchViewController.h"
#import "MNStatusTipView.h"
#import "MNTipView.h"

@interface PouchViewController () 

@property (nonatomic, strong) UIView *whiteView;

@end

@implementation PouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAnimation];
}

// *********** 提示 ***********
- (IBAction)tipAction:(UIButton *)sender {
    MNStatusTipView *tipView = [[MNStatusTipView alloc] initWithFrame:CGRectZero tip:@"No data!" bgColor:[UIColor redColor]];
    tipView.animationDuration = 1;
    tipView.dismissTime = 1;
    [tipView showTipAnimation];
}

- (IBAction)changeImageAndShrinkAction:(UIButton *)sender {
    MNTipView *tipView = [MNTipView tipViewWithText:@"hello"];
    [tipView tipViewShow];
}




// ******* 模仿抖音关注效果 *******
- (void)addAnimation {
    
//    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    circle.backgroundColor = [UIColor redColor];
//    circle.layer.masksToBounds = true;
//    circle.layer.cornerRadius = 50;
//    [self.view addSubview:circle];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100+ (100-adaptX(61))*0.5, 200 - adaptX(61)*0.5, adaptX(61), adaptX(61));
    [btn setImage:[UIImage imageNamed:@"default_add"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    CGFloat whiteViewWH = adaptX(43);
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, whiteViewWH, whiteViewWH)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.masksToBounds = true;
    _whiteView.layer.cornerRadius = whiteViewWH*0.5;
    _whiteView.center = CGPointMake(btn.width*0.5-1, btn.height*0.5-1);
    [btn addSubview:_whiteView];
    _whiteView.alpha = 0;
}

- (void)btnAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5f animations:^{
        _whiteView.alpha = 1.f;
    } completion:^(BOOL finished) {
        if (finished) {
            _whiteView.hidden = true;
            
            [sender setImage:[UIImage imageNamed:@"default_close"] forState:UIControlStateNormal];
            
            [UIView beginAnimations:@"rotate" context:nil ];
            [UIView setAnimationDuration:0.5f];
            [UIView setAnimationDelegate:self];
            [sender setTransform:CGAffineTransformMakeRotation(M_PI)];
            [UIView commitAnimations];
            
            
            [UIView beginAnimations:@"scale" context:nil];
            [UIView setAnimationDuration:0.5f];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDelay:0.5f];
            [sender setTransform:CGAffineTransformMakeScale(0.01, 0.01)];
            [UIView commitAnimations];
        }
    }];

    
}



@end
