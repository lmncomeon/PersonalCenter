//
//  FMAccountDetailViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/12.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FMAccountDetailViewController.h"
#import "FMIncomeOrConsumptionDetailViewController.h"
#import "FMRechargeViewController.h"
#import "FMAccountDetailCell.h"

@interface FMAccountDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIView *customHeader;
@property (nonatomic, strong) SDKCustomLabel *coinCountLab;
@property (nonatomic, strong) SDKCustomLabel *cashAmountLab;
@property (nonatomic, strong) SDKCustomLabel *earningsAmountLab;

@property (nonatomic, strong) SDKCustomRoundedButton *cashBtn;

@property (nonatomic, strong) NSArray *textListArray;

@end

static NSString *const cellID = @"FMAccountDetailCellID";

@implementation FMAccountDetailViewController

- (UIView *)customHeader {
    if (!_customHeader) {
        _customHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(206))];
        _customHeader.backgroundColor = [UIColor whiteColor];
        
        _coinCountLab = [SDKCustomLabel setLabelTitle:@"0" setLabelFrame:CGRectMake(0, adaptY(15), kScreenWidth, adaptY(42)) setLabelColor:UIColorFromRGB(0x333333) setLabelFont:kFont(30) setAlignment:1];
        [_customHeader addSubview:_coinCountLab];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@" 分钟币余额" attributes:@{NSFontAttributeName : kFont(13), NSForegroundColorAttributeName : UIColorFromRGB(0x666666)}];
        
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"live_gift_icon_coin"];
        attach.bounds = CGRectMake(0, -adaptY(1.75), adaptX(15), adaptX(15));
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        [attr insertAttributedString:attachString atIndex:0];
        
        
        SDKCustomLabel *lab = [SDKCustomLabel setLabelAttrTitle:attr setLabelFrame:CGRectMake(0, CGRectGetMaxY(_coinCountLab.frame) + adaptY(10), kScreenWidth, adaptY(18.5)) setAlignment:1];
        [_customHeader addSubview:lab];
        
        UIView *horLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame) + adaptY(30), kScreenWidth, 1)];
        horLine.backgroundColor = UIColorFromRGB(0xe8e8e8);
        [_customHeader addSubview:horLine];
        
        NSArray *tmp = @[@"可提现金额(元)", @"累计收益金额(元)"];
        for (int i = 0; i < tmp.count; i++) {
            UIView *item = [[UIView alloc] initWithFrame:CGRectMake(i*kScreenWidth*0.5, CGRectGetMaxY(horLine.frame), kScreenWidth*0.5, _customHeader.height - CGRectGetMaxY(horLine.frame))];
            [_customHeader addSubview:item];
            
            SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:tmp[i] setLabelFrame:CGRectMake(0, adaptY(7.5), item.width, adaptY(16.5)) setLabelColor:UIColorFromRGB(0x999999) setLabelFont:kFont(12) setAlignment:1];
            [item addSubview:lab];
            
            SDKCustomLabel *valueLab = [SDKCustomLabel setLabelTitle:@"0.00" setLabelFrame:CGRectMake(0, CGRectGetMaxY(lab.frame) + adaptY(10), item.width, adaptY(25)) setLabelColor:UIColorFromRGB(0x333333) setLabelFont:kFont(18) setAlignment:1];
            [item addSubview:valueLab];
            
            if (i == 0) {
                _cashAmountLab = lab;
            } else {
                _earningsAmountLab = lab;
            }
            
            if (i == 0) {
                UIView *verLine = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-1)*0.5,CGRectGetMaxY(horLine.frame) +(item.height - adaptY(50))*0.5, 1, adaptY(50))];
                verLine.backgroundColor = UIColorFromRGB(0xe8e8e8);
                [_customHeader addSubview:verLine];
            }
            
        }

    }
    return _customHeader;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight - 64)) style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _mainTableView.dataSource      = self;
        _mainTableView.delegate  = self;
        _mainTableView.tableHeaderView = self.customHeader;
        _mainTableView.rowHeight = adaptY(40);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的账户";
    
    self.textListArray = @[@"收益明细", @"消费记录", @"提现记录"];
    
    [self mainTableView];
    
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMAccountDetailCell *cell = [FMAccountDetailCell cellWithTableView:tableView identifier:cellID];
    
    cell.content = self.textListArray[indexPath.row];
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (indexPath.row != 2) {
        FMIncomeOrConsumptionDetailViewController *vc = [FMIncomeOrConsumptionDetailViewController new];
        vc.displayType = indexPath.row;
        [self.navigationController pushViewController:vc animated:true];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return adaptY(8);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return adaptY(133);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(133))];
    
    CGFloat padding = adaptX(50);
    CGFloat btnH    = adaptY(44);
    
    SDKCustomRoundedButton *rechargeBtn = [SDKCustomRoundedButton customRoundedBtnWithFrame:CGRectMake(padding, adaptY(30), kScreenWidth-2*padding, btnH) title:@"充值" font:kFont(17) titleColor:[UIColor whiteColor] backgroundColor:UIColorFromRGB(0xFA5A5A) cornerRadius:btnH*0.5 target:self action:@selector(rechargeOrCashAction:)];
    [footer addSubview:rechargeBtn];
    
    _cashBtn = [SDKCustomRoundedButton customRoundedBtnWithFrame:CGRectMake(padding, CGRectGetMaxY(rechargeBtn.frame) + adaptY(12), rechargeBtn.width, rechargeBtn.height) title:@"提现" font:kFont(17) titleColor:UIColorFromRGB(0xFA5A5A) backgroundColor:[UIColor whiteColor] cornerRadius:btnH*0.5 target:self action:@selector(rechargeOrCashAction:)];
    [_cashBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xE6E6E6)] forState:UIControlStateDisabled];
    [_cashBtn setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateDisabled];
    _cashBtn.layer.borderWidth = 1;
    _cashBtn.layer.borderColor = UIColorFromRGB(0xFA5A5A).CGColor;
    [footer addSubview:_cashBtn];
    
    rechargeBtn.tag = 1000;
    _cashBtn.tag = 1001;
 
    
    return footer;
}

- (void)rechargeOrCashAction:(UIButton *)sender {
    NSInteger index = sender.tag-1000;
    
    if (index == 0) {
        // 充值
        
        [self.navigationController pushViewController:[FMRechargeViewController new] animated:true];
    } else {
        // 提现
        
    }
}

@end
