//
//  FMAccountDetailCell.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/12.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FMAccountDetailCell.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"

@interface FMAccountDetailCell ()

@property (nonatomic, strong) SDKCustomLabel *lab;

@end

@implementation FMAccountDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    FMAccountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[FMAccountDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(adaptX(16), 0, kScreenWidth-2*adaptX(16), adaptY(40)) setLabelColor:UIColorFromRGB(0x333333) setLabelFont:kFont(14)];
        [self.contentView addSubview:_lab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, adaptY(42)-1, kScreenWidth, 1)];
        line.backgroundColor = UIColorFromRGB(0xe8e8e8);
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    _lab.text = content;
}

@end
