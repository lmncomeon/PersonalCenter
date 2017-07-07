//
//  KTVCaptionViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/28.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "KTVCaptionViewController.h"

@interface KTVCaptionViewController ()

@end

@implementation KTVCaptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"哈哈你好哈哈你好哈哈你好哈哈你好哈哈你好哈哈你好哈哈你好哈哈你好";
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, adaptY(30))];
    background.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:background];
    
    SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:str setLabelFrame:background.bounds setLabelColor:[UIColor whiteColor] setLabelFont:[UIFont systemFontOfSize:12 weight:2]];
    [background addSubview:lab];
    
    
    UIView *show = [[UIView alloc] initWithFrame:background.bounds];
    show.backgroundColor = [UIColor clearColor];
    show.layer.masksToBounds = true;
    [background addSubview:show];
    
    SDKCustomLabel *showLab = [SDKCustomLabel setLabelTitle:str setLabelFrame:show.bounds setLabelColor:[UIColor purpleColor] setLabelFont:[UIFont systemFontOfSize:12 weight:2]];
    [show addSubview:showLab];
    
    // default
    
    show.width = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:8 animations:^{
            show.width = background.size.width;
        }];
    });
    
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, adaptX(100), adaptX(100))];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];

    CGFloat redViewW = adaptX(100);
    CGFloat padding  = adaptX(10);
    
    [path moveToPoint:CGPointZero];
    //添加四个二元曲线
    [path addQuadCurveToPoint:CGPointMake(redViewW, 0)
                 controlPoint:CGPointMake(redViewW*0.5, -padding)];
    [path addQuadCurveToPoint:CGPointMake(redViewW, redViewW)
                 controlPoint:CGPointMake(redViewW+padding, redViewW*0.5)];
    [path addQuadCurveToPoint:CGPointMake(0, redViewW)
                 controlPoint:CGPointMake(redViewW*0.5, redViewW+padding)];
    [path addQuadCurveToPoint:CGPointZero
                 controlPoint:CGPointMake(-padding, redViewW*0.5)];
    
    redView.layer.shadowColor = [UIColor yellowColor].CGColor;
    redView.layer.shadowOffset = CGSizeZero;
    redView.layer.shadowRadius = 3;
    redView.layer.shadowPath = path.CGPath;
    redView.layer.shadowOpacity = 1;


    self.view.layer.contents = (id)[UIImage imageNamed:@"bg.jpg"].CGImage;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(adaptX(20), adaptY(10), kScreenWidth-2*adaptX(20), adaptY(30));
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"我是透明按钮 好看不" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = commonWhiteColor;
    btn.alpha = 0.5f;
    [self.view addSubview:btn];
    
}
@end
