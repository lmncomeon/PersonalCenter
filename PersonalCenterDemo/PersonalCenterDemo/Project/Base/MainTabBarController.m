//
//  MainTabBarController.m
//  SubscriptionDemo
//
//  Created by 栾美娜 on 2017/6/19.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "MainTabBarController.h"
// nav
#import "SDKNavigationController.h"

// 四个模块
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"

@interface MainTabBarController () 

@end

@implementation MainTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createChildViewControllerWithController:[OneViewController new] title:@"one" normalImg:@"bar-zhuanan_no" selectedImg:@"bar-zhuanan"];
    
    [self createChildViewControllerWithController:[TwoViewController new] title:@"two" normalImg:@"bar-dingyue_no" selectedImg:@"bar-dingyue"];
    
    [self createChildViewControllerWithController:[ThreeViewController new] title:@"three" normalImg:@"bar-qunzu_no" selectedImg:@"bar-qunzu"];
    
    [self createChildViewControllerWithController:[FourViewController new] title:@"four" normalImg:@"bar-mine_no" selectedImg:@"bar-mine"];
}

- (void)createChildViewControllerWithController:(SDKBaseViewController *)controller title:(NSString *)title normalImg:(NSString *)normalImg selectedImg:(NSString *)selectedImg {
    SDKNavigationController *nav = [[SDKNavigationController alloc] initWithRootViewController:controller];
    
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:normalImg]  selectedImage:[UIImage imageNamed:selectedImg]];
    
    nav.tabBarItem.image = [[UIImage imageNamed:normalImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor orangeColor]} forState:UIControlStateSelected];
    
    
    [self addChildViewController:nav];
}

@end
