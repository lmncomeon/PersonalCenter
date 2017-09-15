//
//  FMIncomeOrConsumptionCell.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/14.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FMIncomeOrConsumptionCell.h"
#import "SDKLineView.h"
#import "UIView+CustomView.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"
#import "FMDetailModel.h"

@interface FMIncomeOrConsumptionCell ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *upLab;
@property (nonatomic, strong) SDKCustomLabel *downLab;

@end

@implementation FMIncomeOrConsumptionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    FMIncomeOrConsumptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[FMIncomeOrConsumptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat cellH = adaptY(60);
        
        CGFloat avatarWH = adaptX(40);
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(kDefaultPadding, (cellH - avatarWH)*0.5, avatarWH, avatarWH)];
        _avatarView.backgroundColor = [UIColor redColor];
        _avatarView.layer.masksToBounds = true;
        _avatarView.layer.cornerRadius = avatarWH*0.5;
        [self.contentView addSubview:_avatarView];
        
        _upLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarView.frame) + adaptX(10), adaptY(8), kScreenWidth-CGRectGetMaxX(_avatarView.frame) - adaptX(10), adaptY(20))];
        [self.contentView addSubview:_upLab];
        
        _downLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(_upLab.x, CGRectGetMaxY(_upLab.frame), kScreenWidth-_upLab.x, adaptY(16)) setLabelColor:UIColorFromRGB(0x999999) setLabelFont:kFont(12)];
        [self.contentView addSubview:_downLab];
        
        [self.contentView addSubview:[SDKLineView screenWidthLineWithY:cellH-0.5]];
    }
    return self;
}

- (void)setModel:(FMDetailModel *)model {
    _model = model;
    
    if ([model.type isEqualToString:@"0"]) {
        
        NSString *total = [NSString stringWithFormat:@"赠送 %@ X%@", model.giftName, model.giftCount];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:total attributes:@{NSFontAttributeName : kFont(14), NSForegroundColorAttributeName : commonBlackColor}];
        [attr addAttribute:NSForegroundColorAttributeName value:kOrangeColor range:[total rangeOfString:[NSString stringWithFormat:@"X%@", model.giftCount]]];
        
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[total rangeOfString:@"赠送"]];

        _upLab.attributedText = attr;
    } else {
        NSString *total = [NSString stringWithFormat:@"%@ X%@", model.giftName, model.giftCount];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:total attributes:@{NSFontAttributeName : kFont(14), NSForegroundColorAttributeName : commonBlackColor}];
        [attr addAttribute:NSForegroundColorAttributeName value:kOrangeColor range:[total rangeOfString:[NSString stringWithFormat:@"X%@", model.giftCount]]];
        
        _upLab.attributedText = attr;
    }
    
    
    _downLab.text = ([model.type isEqualToString:@"0"]) ? model.sender : [NSString stringWithFormat:@"赠送给 %@", model.sended];
    
    
}

@end
