//
//  QQGroupViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/6.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "QQGroupViewController.h"
#import "QQGroupModel.h"

@interface QQGroupViewController ()

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray <QQGroupModel *> *dataList;

@end

static NSString *const cellID = @"UITableViewCellID";

@implementation QQGroupViewController

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight - 64)) style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _mainTableView.dataSource      = self;
        _mainTableView.delegate  = self;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
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
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataList[section].spread) {
        return self.dataList[section].list.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSArray <QQCellModel *> *tmp = self.dataList[indexPath.section].list;
    
    cell.textLabel.text = tmp[indexPath.row].content;
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.dataList[section].list.count ? adaptY(45) : 0.01f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataList[section].list.count)
    {
        SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:[@"  " stringByAppendingString:self.dataList[section].title] setLabelFrame:CGRectMake(0, 0, kScreenWidth, adaptY(45)) setLabelColor:commonBlackColor setLabelFont:kFont(12) setAlignment:1];
        lab.backgroundColor = [UIColor magentaColor];
        HXWeak_self
        [lab addSingleTapEvent:^{
            HXStrong_self
            
            QQGroupModel *group = self.dataList[section];
            group.spread = !group.spread;
            
//            [self closeOtherSectionsExcept:section];
            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            
        }];
        return lab;
    }
    
    return nil;
}

- (void)closeOtherSectionsExcept:(int)except {
    for (int i = 0; i < self.dataList.count; i++) {
        if (i == except) continue;
        
        self.dataList[i].spread = false;
    }
    
    
    [self.mainTableView reloadData];
}

#pragma mark - lazy load
- (NSMutableArray <QQGroupModel *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithCapacity:5];
        
        for (int i = 0; i < 8; i++) {
            QQGroupModel *group = [QQGroupModel new];
            group.title = [NSString stringWithFormat:@"第%d组", i];
            group.spread = false;
            
            
            NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:5];
            int cellCount = arc4random_uniform(8);
            for (int j = 0; j < cellCount; j++) {
                QQCellModel *cellM = [QQCellModel new];
                cellM.content = [NSString stringWithFormat:@"洗洗哈哈---%d", j];
                [tmp addObject:cellM];
            }
            group.list = tmp;
            
            [_dataList addObject:group];
        }
    }
    return _dataList;
}

@end
