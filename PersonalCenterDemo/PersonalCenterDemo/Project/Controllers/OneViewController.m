//
//  OneViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/26.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "OneViewController.h"
#import "ControllerModel.h"

@interface OneViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray <ControllerModel *> *dataList;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *tempimgView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation OneViewController

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-84) style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.dataSource      = self;
        _mainTableView.delegate  = self;
        [self.view addSubview:_mainTableView];
        
    }
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:@"测试" setLabelFrame:CGRectMake(0, 0, kScreenWidth, adaptY(20)) setLabelColor:commonBlueColor setLabelFont:kFont(12)];
    lab.textAlignment = 1;
    [self.view addSubview:lab];
    
    [self mainTableView];
    
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellID = @"UITableViewCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.dataList[indexPath.row].title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class class = NSClassFromString(self.dataList[indexPath.row].className);
    if (class) {
        SDKBaseViewController *vc = [class new];
        vc.title = self.dataList[indexPath.row].title;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:true];
    } else {
        // 购物车效果
        [self addShoppingCartEffect];
    }
}

- (void)addShoppingCartEffect {
    // 背景view
    self.backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backView.backgroundColor = [UIColor orangeColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    
    
    
    // 截取当前屏幕的img
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view.window drawViewHierarchyInRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) afterScreenUpdates:NO];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 截取的屏幕
    self.tempimgView = [[UIImageView alloc]initWithFrame:self.backView.bounds];
    self.tempimgView.image = img;
    [self.backView addSubview:self.tempimgView];
    // 遮罩层
    UIView *maskView = [[UIView alloc]initWithFrame:self.backView.bounds];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchMaskView)]];
    [self.backView addSubview:maskView];
    
    // 弹出的view
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height,  [UIScreen mainScreen].bounds.size.width, 200)];
    self.bottomView.backgroundColor = [UIColor redColor];
    [self.backView addSubview:self.bottomView];
    
    // 动画
    [UIView animateWithDuration: 0.35 animations: ^{
        self.tempimgView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
        self.tempimgView.y = adaptY(10);
        self.bottomView.frame = CGRectMake(0, kScreenHeight-adaptY(200), kScreenWidth, adaptY(200));
    } completion: nil];
}

-(void)didTouchMaskView {
    [UIView animateWithDuration: 0.35 animations: ^{
        self.tempimgView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
        self.tempimgView.y = 0;
        self.bottomView.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
}

#pragma mark - lazy load
- (NSMutableArray <ControllerModel *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithCapacity:10];
        [_dataList addObject:[ControllerModel modelWithTitle:@"上滑隐藏导航条 下滑显示" className:@"PersonalCenterViewController"]];
        [_dataList addObject:[ControllerModel modelWithTitle:@"视觉效果" className:@"VisualEffectViewController"]];
        [_dataList addObject:[ControllerModel modelWithTitle:@"密码输入框" className:@"PWDViewController"]];
        [_dataList addObject:[ControllerModel modelWithTitle:@"右拉加载" className:@"RightLoadViewController"]];
        [_dataList addObject:[ControllerModel modelWithTitle:@"物流" className:@"LogisticsViewController"]];
        [_dataList addObject:[ControllerModel modelWithTitle:@"KTV字幕建议实现" className:@"KTVCaptionViewController"]];
        [_dataList addObject:[ControllerModel modelWithTitle:@"购物车效果" className:@""]];
        [_dataList addObject:[ControllerModel modelWithTitle:@"弹性" className:@"SpringViewController"]];
        [_dataList addObject:[ControllerModel modelWithTitle:@"仿真" className:@"SimulationEffectViewController"]];
        [_dataList addObject:[ControllerModel modelWithTitle:@"折叠" className:@"FoldViewController"]];
        [_dataList addObject:[ControllerModel modelWithTitle:@"分组" className:@"QQGroupViewController"]];
        [_dataList addObject:[ControllerModel modelWithTitle:@"按钮系列" className:@"ButtonsViewController"]];
        [_dataList addObject:[ControllerModel modelWithTitle:@"RSA测试" className:@"RSAViewController"]];
        
    }
    return _dataList;
}

@end
