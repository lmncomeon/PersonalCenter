//
//  PersonalCenterViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/26.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "VideoListViewController.h"
#import "IntroViewController.h"
@interface PersonalCenterViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *naviagtionView;
@property (nonatomic, strong) UIView *titlesView;
@property (nonatomic, strong) UIButton *selectedBtn;


@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) VideoListViewController *videoVC;
@property (nonatomic, strong) IntroViewController *introVC;

@end

@implementation PersonalCenterViewController

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20+adaptY(80))];
        _topView.backgroundColor = UIColorFromRGB(0xFF7373);
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (UIView *)naviagtionView {
    if (!_naviagtionView) {
        _naviagtionView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, adaptY(50))];
        _naviagtionView.backgroundColor = [UIColor orangeColor];
        [self.topView addSubview:_naviagtionView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(adaptX(10), adaptY(10), adaptX(20), adaptY(34));
        [btn setImage:[UIImage imageNamed:@"arrow_back_white"] forState:0];
        [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_naviagtionView addSubview:btn];
    }
    return _naviagtionView;
}

- (UIView *)titlesView {
    if (!_titlesView) {
        _titlesView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.naviagtionView.frame), kScreenWidth, adaptY(30))];
        [self.topView addSubview:_titlesView];
        
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*kScreenWidth*0.5, 0, kScreenWidth*0.5, adaptY(30));
            [btn setTitle:[NSString stringWithFormat:@"%d==%d", i, i] forState:0];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
            btn.tag = 1000+i; //tag
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_titlesView addSubview:btn];
            
            // default
            if (i == 0) {
                btn.selected = true;
                _selectedBtn = btn;
            }
        }
    }
    return _titlesView;
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth, kScreenHeight-CGRectGetMaxY(self.topView.frame))];
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.bounces = false;
        _mainScrollView.contentSize = CGSizeMake(kScreenWidth*2, 0);
        [self.view addSubview:_mainScrollView];
        
        _videoVC = [VideoListViewController new];
        _introVC = [IntroViewController new];
        
        [self addChildViewController:_videoVC];
        [self addChildViewController:_introVC];
        
        
        _videoVC.view.frame = CGRectMake(0, 0, kScreenWidth, _mainScrollView.height);
        _introVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, _mainScrollView.height);
        
        [_mainScrollView addSubview:_videoVC.view];
        [_mainScrollView addSubview:_introVC.view];
        
        
        __weak __typeof(&*self)weakSelf = self;
        _videoVC.scrollDerictionEvent = ^ (BOOL up) {
            [weakSelf changeFrameByIsUp:up];
        };
        
        
        _introVC.scrollDerictionEvent = ^ (BOOL up) {
            [weakSelf changeFrameByIsUp:up];
        };
    }
    return _mainScrollView;
}

- (void)changeFrameByIsUp:(BOOL)up {
    [UIView animateWithDuration:0.2f animations:^{
        self.topView.y = up ? -(adaptY(50) + 20) : 0;
        _mainScrollView.y = CGRectGetMaxY(self.topView.frame);
        _mainScrollView.height = kScreenHeight- CGRectGetMaxY(self.topView.frame);;
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self titlesView];
    [self mainScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = false;
}

- (void)btnAction:(UIButton *)sender {
    NSInteger index = sender.tag-1000;
    
    if (sender == _selectedBtn) return;
    
    sender.selected = true;
    _selectedBtn.selected = false;
    _selectedBtn = sender;
    
    _mainScrollView.contentOffset = CGPointMake(kScreenWidth*index, 0);
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = (scrollView.contentOffset.x + kScreenWidth*0.5) / kScreenWidth;
    
    UIButton *sender = [_titlesView viewWithTag:1000+page];
    if (sender == _selectedBtn) return;
    
    sender.selected = true;
    _selectedBtn.selected = false;
    _selectedBtn = sender;
}

@end
