//
//  AddressViewController.m
//  AllDemo
//
//  Created by 美娜栾 on 2017/8/19.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "AddressViewController.h"
#import "SDKCustomLabel.h"
#import "MapViewController.h"

@interface AddressViewController ()

@property (nonatomic, strong) SDKCustomLabel *oneLab;
@property (nonatomic, strong) SDKCustomLabel *twoLab;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 100, kScreenWidth-30, 30);
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn setTitle:@"选择地图" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _oneLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(10, CGRectGetMaxY(btn.frame) + 30, kScreenWidth-20, 30) setLabelColor:[UIColor blackColor] setLabelFont:kFont(14)];
    _oneLab.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_oneLab];
    
    _twoLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(10, CGRectGetMaxY(_oneLab.frame) + 30, kScreenWidth-20, 30) setLabelColor:[UIColor blackColor] setLabelFont:kFont(14)];
    _twoLab.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_twoLab];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reveiveMapData:) name:@"mpValueNotification" object:nil];
}

- (void)btnAction {
    __weak typeof(self) weakSelf = self;
    
    MapViewController *mapVC = [MapViewController new];
    mapVC.mapValueBlock = ^(NSString *provinces, NSString *address) {
        weakSelf.oneLab.text = provinces;
        weakSelf.twoLab.text = address;
    };
    [self.navigationController pushViewController:mapVC animated:true];
}

- (void)reveiveMapData:(NSNotification *)note {
    NSDictionary *info = note.userInfo;
    
    self.oneLab.text = info[@"provinces"];
    self.twoLab.text = info[@"address"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
