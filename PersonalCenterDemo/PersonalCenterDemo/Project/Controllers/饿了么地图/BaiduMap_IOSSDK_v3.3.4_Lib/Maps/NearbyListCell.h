//
//  NearbyListCell.h
//  AllDemo
//
//  Created by 美娜栾 on 2017/8/19.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDKPoiModel;

@interface NearbyListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

+ (CGFloat)listCellHeightWith:(SDKPoiModel *)model;


@property (nonatomic, strong) SDKPoiModel *model;

- (void)settingTextColor:(UIColor *)textColor;

// 变色
- (void)colorfulWithModel:(SDKPoiModel *)model;
+ (CGFloat)searchCellHeightWith:(SDKPoiModel *)model;

@end
