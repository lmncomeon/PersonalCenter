//
//  FMIncomeOrConsumptionCell.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/14.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMDetailModel;

@interface FMIncomeOrConsumptionCell : UITableViewCell

@property (nonatomic, strong) FMDetailModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@end
