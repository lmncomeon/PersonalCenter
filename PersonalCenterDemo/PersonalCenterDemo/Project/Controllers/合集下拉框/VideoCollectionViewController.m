//
//  VideoCollectionViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "VideoCollectionViewController.h"
#import "MineVideoCollectionView.h"
#import "MNAlertView.h"

@interface VideoCollectionViewController () <MNAlertViewDelegate>

@property (nonatomic, strong) UIView *naviagtionView;

@end

@implementation VideoCollectionViewController

- (UIView *)naviagtionView {
    if (!_naviagtionView) {
        _naviagtionView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, adaptY(50))];
        _naviagtionView.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:_naviagtionView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(adaptX(10), adaptY(10), adaptX(20), adaptY(34));
        [btn setImage:[UIImage imageNamed:@"arrow_back_white"] forState:0];
        [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_naviagtionView addSubview:btn];
    }
    return _naviagtionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 100, 80, 20);
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(btnAction1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)btnAction {
    MineVideoCollectionView *sheet = [[MineVideoCollectionView alloc] initWithFrame:CGRectZero list:nil];
    [sheet collectionShow];
    
    HXWeak_(sheet)
    sheet.createEvent = ^ {
        // 跳转页面
        
      // 模拟网路
        HXStrong_(sheet)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // success
            
            [sheet collectionHide];
        });
    };
    
    sheet.shareEvent = ^{
      // 分享
        DLog(@"===分享");
    };
    
    sheet.otherEvent = ^(NSString *value) {
        DLog(@"=== 你点击了%@", value);
    };
    
}

- (void)btnAction1 {
    MNAlertView *alert = [[MNAlertView alloc] initWithTitle:@"提示" content:@"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈" buttons:@[@"取消"] delegate:(id<MNAlertViewDelegate>)self];
    [alert alertShow];
}

- (void)MNAlertView:(MNAlertView *)MNAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLog(@"=====index:%ld", buttonIndex);
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)dealloc {
    DLog(@"== dealloc");
}

@end
