//
//  AdvertisingTestViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/8/8.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "AdvertisingTestViewController.h"
#import "AdvertisingView.h"

@interface AdvertisingTestViewController ()

@property (nonatomic, strong) AdvertisingView *testView;

@end

@implementation AdvertisingTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addDeviceOrientationNotifiaction];
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(kScreenWidth/3), kScreenHeight-64-30, kScreenWidth/3, 30);
        btn.backgroundColor = krandomColor;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    
}

- (void)addDeviceOrientationNotifiaction {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateViews:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)removeDeviceOrientationNotifiaction {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)rotateViews:(NSNotification *)note {
    UIDevice* device = [note valueForKey:@"object"];
    
    switch (device.orientation) {
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationLandscapeLeft:
        {
            DLog(@"横屏");
            [_testView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
            
            _testView.avPlayerLayer.frame = [UIScreen mainScreen].bounds;

            [_testView layoutIfNeeded];
           
        } break;
        case UIDeviceOrientationPortrait:
        {
            DLog(@"竖屏");
            
            [_testView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(-(kScreenHeight-200));
            }];
            
            _testView.layer.frame = _testView.avPlayerLayer.frame = CGRectMake(0, 0, kScreenWidth, 200);
            
            [_testView layoutIfNeeded];
        } break;
        default:
        { DLog(@"其他");} break;
    }

}

- (void)btnAction:(UIButton *)sender {
    NSString *url = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    
    [_testView endPlayer];
    
    _testView = [[AdvertisingView alloc] initWithFrame:CGRectMake(10, 64, kScreenWidth-20, 200) videoUrl:url duration:10];
    [[UIApplication sharedApplication].keyWindow addSubview:_testView];
    
    [_testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-(kScreenHeight-200));
    }];
    
    
    _testView.layer.frame = _testView.avPlayerLayer.frame = CGRectMake(0, 0, kScreenWidth, 200);
    
    
}

- (BOOL)shouldAutorotate{ // 是否支持旋转
    return YES;
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

- (void)dealloc {
    [self removeDeviceOrientationNotifiaction];
}


@end
