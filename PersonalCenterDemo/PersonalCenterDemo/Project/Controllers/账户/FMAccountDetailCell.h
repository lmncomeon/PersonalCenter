//
//  FMAccountDetailCell.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/12.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMAccountDetailCell : UITableViewCell

@property (nonatomic, copy) NSString *content;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@end
