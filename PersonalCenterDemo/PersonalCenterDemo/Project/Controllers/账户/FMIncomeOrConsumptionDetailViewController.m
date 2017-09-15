//
//  FMIncomeOrConsumptionDetailViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/14.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FMIncomeOrConsumptionDetailViewController.h"
#import "FMIncomeOrConsumptionCell.h"
#import "FMDetailModel.h"

@interface FMIncomeOrConsumptionDetailViewController ()

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray <FMDetailGroupModel *> *dataList;

@end

static NSString *const cellID = @"FMIncomeOrConsumptionCellID";

@implementation FMIncomeOrConsumptionDetailViewController

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight - 64)) style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _mainTableView.dataSource      = self;
        _mainTableView.delegate  = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.rowHeight = adaptY(60);
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = (_displayType == FMViewControllerTypeIncome) ? @"收益明细" : @"消费记录";
    
    [self mainTableView];

    NSDictionary *dic = (_displayType == FMViewControllerTypeIncome) ?
    [SDKCommonTools dicFromJsonFileName:@"AccountIncome"] :
    [SDKCommonTools dicFromJsonFileName:@"AccountConsumption"];
    
    if (!dic) return;
    
    NSArray *arr = [NSArray yy_modelArrayWithClass:[FMDetailGroupModel class] json:dic[@"data"]];
    
    [self.dataList addObjectsFromArray:arr];
    [self.mainTableView reloadData];
    
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList[section].list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FMIncomeOrConsumptionCell *cell = [FMIncomeOrConsumptionCell cellWithTableView:tableView identifier:cellID];
    
    FMDetailModel *model = self.dataList[indexPath.section].list[indexPath.row];
    model.type = (_displayType == FMViewControllerTypeIncome) ? @"0" : @"1";
    cell.model = model;

    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return adaptY(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(40))];
    header.backgroundColor = commonWhiteColor;
    
    SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:self.dataList[section].dateString setLabelFrame:CGRectMake(kDefaultPadding, 0, kScreenWidth - 2*kDefaultPadding, header.height) setLabelColor:UIColorFromRGB(0x999999) setLabelFont:kFont(13)];
    [header addSubview:lab];
    
    [header addSubview:[SDKLineView screenWidthLineWithY:header.height-0.5f]];
 
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return adaptY(8);
}

#pragma mark - lazy load
- (NSMutableArray <FMDetailGroupModel *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithCapacity:5];
    }
    return _dataList;
}

@end
