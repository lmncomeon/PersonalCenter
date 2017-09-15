//
//  FMRechargeCell.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/13.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FMRechargeCell.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"
#import "SDKCustomRoundedButton.h"
#import "UIView+CustomView.h"

@interface FMRechargeCell ()

@property (nonatomic, strong) SDKCustomLabel *coinCountLab;
@property (nonatomic, strong) SDKCustomRoundedButton *priceBtn;

@end

@implementation FMRechargeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    FMRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[FMRechargeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat cellH = adaptY(57.5);
        
        CGFloat iconWH = adaptX(15);
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(kDefaultPadding, (cellH - iconWH)*0.5, iconWH, iconWH)];
        icon.image = [UIImage imageNamed:@"live_gift_icon_coin"];
        [self.contentView addSubview:icon];

        _priceBtn = [SDKCustomRoundedButton customRoundedBtnWithFrame:CGRectMake(kScreenWidth-adaptX(80)-kDefaultPadding, (cellH - adaptY(27))*0.5, adaptX(80), adaptY(27)) title:@"¥" font:kFont(14) titleColor:UIColorFromRGB(0xFA5A5A) backgroundColor:commonWhiteColor cornerRadius:adaptY(27)*0.5 target:self action:@selector(priceAction)];
        _priceBtn.layer.borderWidth = 1;
        _priceBtn.layer.borderColor = UIColorFromRGB(0xFA5A5A).CGColor;
        [self.contentView addSubview:_priceBtn];
        
        _coinCountLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(CGRectGetMaxX(icon.frame)+adaptX(10), 0, _priceBtn.x - _coinCountLab.x, cellH) setLabelColor:UIColorFromRGB(0x333333) setLabelFont:kFont(15)];
        [self.contentView addSubview:_coinCountLab];
    }
    
    return self;
}

- (void)priceAction {
    !_priceEvent ? : _priceEvent();
}

@end
