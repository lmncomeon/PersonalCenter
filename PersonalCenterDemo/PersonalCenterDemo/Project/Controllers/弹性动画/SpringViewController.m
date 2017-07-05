//
//  SpringViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/4.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SpringViewController.h"

@interface SpringViewController ()

@end

@implementation SpringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self spring1];
    
    [self spring2];
}

- (void)spring1 {
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(20, 200, kScreenWidth-40, 0)];
    [self.view addSubview:container];
    
    CGFloat itemWH = (kScreenWidth-40) / 3;
    for (int i = 0; i < 9; i++) {
        int row = i / 3;
        int col = i % 3;
        
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(col*itemWH, row*itemWH, itemWH, itemWH)];
        item.backgroundColor = krandomColor;
        [container addSubview:item];
        
        if (i == 8) {
            container.height = CGRectGetMaxY(item.frame);
        }
    }
    
    [self addActionOneWithContainer:container];
    
}

- (void)addActionOneWithContainer:(UIView *)container {
    for (int i = 0; i < container.subviews.count; i++) {
        UIView *item = container.subviews[i];
        
        item.transform = CGAffineTransformMakeTranslation(0, 100);
        item.alpha = 0;
        
        [UIView animateWithDuration:1
                              delay:i*0.08
             usingSpringWithDamping:0.5
              initialSpringVelocity:0
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             item.transform = CGAffineTransformIdentity;
                             item.alpha = 1;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)spring2 {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(100))];
    topView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:topView];
    
    topView.transform = CGAffineTransformMakeTranslation(0, -adaptY(100));
    
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         topView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         
                     }];
}

@end
