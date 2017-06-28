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

@end

@implementation OneViewController

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight - 64)) style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _mainTableView.dataSource      = self;
        _mainTableView.delegate  = self;
        [self.view addSubview:_mainTableView];
        
    }
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class class = NSClassFromString(self.dataList[indexPath.row].className);
    if (class) {
        SDKBaseViewController *vc = [class new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:true];
    }
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
        
        
    }
    return _dataList;
}

@end
