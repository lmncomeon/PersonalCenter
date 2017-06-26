//
//  BaseTableViewCell.h
//  SubscriptionDemo
//
//  Created by 栾美娜 on 2017/6/19.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+CustomView.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"
#import "SDKAboutText.h"
#import "UIImage+ColorImage.h"

@interface BaseTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

- (void)settingValueWithModel:(id)model;

@end
