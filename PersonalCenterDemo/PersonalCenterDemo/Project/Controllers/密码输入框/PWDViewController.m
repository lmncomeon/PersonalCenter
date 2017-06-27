//
//  PWDViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/27.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "PWDViewController.h"
#import "PWDView.h"

@interface PWDViewController ()

@property (nonatomic, strong) PWDView *passwordView;

@end

@implementation PWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _passwordView = [[PWDView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 0) inputCount:6];
    _passwordView.borderColor = [UIColor purpleColor];
    [self.view addSubview:_passwordView];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    
}

- (void)tap {
    [self.view endEditing:YES];
    
    
}

@end
