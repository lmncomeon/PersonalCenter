//
//  FMRechargeCell.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/13.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRechargeCell : UITableViewCell

@property (nonatomic, copy) dispatch_block_t priceEvent;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@end
