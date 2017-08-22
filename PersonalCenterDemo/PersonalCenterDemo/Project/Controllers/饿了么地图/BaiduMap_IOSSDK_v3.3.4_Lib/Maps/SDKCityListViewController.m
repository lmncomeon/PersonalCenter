//
//  SDKCityListViewController.m
//  handheldCredit
//
//  Created by 栾美娜 on 2017/8/21.
//  Copyright © 2017年 liguiwen. All rights reserved.
//

#import "SDKCityListViewController.h"
#import "SDKLineView.h"

@interface SDKCityListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) SDKCustomLabel *currentCityLab;

@end

static NSString *const cellID = @"UITableViewCellID";

@implementation SDKCityListViewController

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight - 64)) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _mainTableView.dataSource      = self;
        _mainTableView.delegate  = self;
        _mainTableView.rowHeight = adaptY(45);
        _mainTableView.sectionIndexColor = commonGrayColor;
        _mainTableView.tableHeaderView = ({
            UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(50))];
            tableHeader.backgroundColor = commonWhiteColor;
            
            _currentCityLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(kDefaultPadding, 0, kScreenWidth-2*kDefaultPadding, adaptY(50)) setLabelColor:[UIColor blackColor] setLabelFont:kFont(12)];
            HXWeak_self
            [_currentCityLab addSingleTapEvent:^{
                HXStrong_self
                
                !self.sendValue ? : self.sendValue(self.currentString);
            }];
            [tableHeader addSubview:_currentCityLab];
            
            SDKLineView *divider = [SDKLineView screenWidthLineWithY:0.5f];
            [tableHeader addSubview:divider];
            
            tableHeader;
        });
        [self.view addSubview:_mainTableView];
        
    }
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setCurrentString:(NSString *)currentString {
    _currentString = currentString;
    
    NSString *total = [NSString stringWithFormat:@"%@ 定位当前城市", currentString];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:total attributes:@{NSFontAttributeName : kFont(12), NSForegroundColorAttributeName : commonGrayColor}];
    
    NSRange range = [total rangeOfString:currentString];
    [attr addAttribute:NSFontAttributeName value:kFont(14) range:range];
    [attr addAttribute:NSForegroundColorAttributeName value:commonBlackColor range:range];
    
    self.currentCityLab.attributedText = attr;
}

- (void)setList:(NSArray *)list {
    _list = list;
}

- (void)setIndexArray:(NSArray *)indexArray {
    _indexArray = indexArray;
    
    [self.mainTableView reloadData];
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.list[section] allValues] firstObject] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSArray *tmp = [[self.list[indexPath.section] allValues] firstObject];
    cell.textLabel.text = tmp[indexPath.row];
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *tmp  = [[self.list[indexPath.section] allValues] firstObject];
    NSString *str = tmp[indexPath.row];
    
    !_sendValue ? : _sendValue(str);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return adaptY(25);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(25))];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:self.indexArray[section] setLabelFrame:CGRectMake(kDefaultPadding, 0, kScreenWidth-2*kDefaultPadding, adaptY(25)) setLabelColor:commonGrayColor setLabelFont:kFont(12)];
    [header addSubview:lab];
    
    return header;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
}

@end
