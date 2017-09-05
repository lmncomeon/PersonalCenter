//
//  NearbyListCell.m
//  AllDemo
//
//  Created by 美娜栾 on 2017/8/19.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "NearbyListCell.h"
#import "SDKProjectHeader.h"
#import "UIView+CustomView.h"
#import "SDKCustomLabel.h"
#import "SDKPoiModel.h"
#import "SDKAboutText.h"

@interface NearbyListCell ()

@property (nonatomic, strong) SDKCustomLabel *nameLab;
@property (nonatomic, strong) SDKCustomLabel *addressLab;

@property (nonatomic, strong) SDKCustomLabel *distanceLab;

@end

@implementation NearbyListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    NearbyListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NearbyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(adaptX(16), 0, kScreenWidth-2*adaptX(16), 0) setLabelColor:titleTextColor setLabelFont:kFont(14)];
        _nameLab.numberOfLines = 0;
        [self.contentView addSubview:_nameLab];
        
        _addressLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(adaptX(16), 0, kScreenWidth-2*adaptX(16), 0) setLabelColor:UIColorFromRGB(0x999999) setLabelFont:kFont(12)];
        _addressLab.numberOfLines = 0;
        [self.contentView addSubview:_addressLab];
        
        CGFloat distaceW = adaptX(70);
        _distanceLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(kScreenWidth-kDefaultPadding- distaceW, 0, distaceW, adaptY(30)) setLabelColor:commonGrayColor setLabelFont:kFont(12) setAlignment:2];
        [self.contentView addSubview:_distanceLab];
        
        _distanceLab.hidden = true;
        
    }
    return self;
}

+ (CGFloat)listCellHeightWith:(SDKPoiModel *)model {
    NearbyListCell *cell = [[NearbyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.model = model;
    
    [cell layoutIfNeeded];
    
    CGRect frame = cell.addressLab.frame;
    return frame.origin.y + frame.size.height + adaptY(5);
}

- (void)setModel:(SDKPoiModel *)model {
    _model = model;
    
    model.address = model.address.length ? model.address : model.name;
    
    _nameLab.text    = model.name;
    _addressLab.text = model.address;
    
    // update Frame
    CGFloat padding = adaptY(5);
    
    CGFloat nameH = [SDKAboutText calculateTextHeight:model.name maxWidth:_nameLab.width font:_nameLab.font];
    nameH = nameH < adaptY(30) ? adaptY(30) : nameH + padding;
    _nameLab.height = nameH;
    
    _addressLab.y = CGRectGetMaxY(_nameLab.frame);
    
    CGFloat addressH = [SDKAboutText calculateTextHeight:model.address maxWidth:_addressLab.width font:_addressLab.font];
    addressH = addressH < adaptY(20) ? adaptY(20) : addressH + padding;
    _addressLab.height = addressH;
    
}

- (void)settingTextColor:(UIColor *)textColor {
    _nameLab.textColor = textColor;
}

- (NSString *)handleDistance:(double)distance {
    NSString *str = [NSString stringWithFormat:@"%.f", distance];
    
    if (str && str.length >= 4) {
        return [NSString stringWithFormat:@"%.2f千米", distance/1000];
    } else {
        return [NSString stringWithFormat:@"%@米", str];
    }
}

// 变色
- (void)colorfulWithModel:(SDKPoiModel *)model {
    
    if (model.distance) {
        _distanceLab.hidden = false;
        _distanceLab.text = [self handleDistance:model.distance];
    } else {
        _distanceLab.hidden = true;
    }
    
    
    model.address = model.address.length ? model.address : model.name;
    
    _nameLab.attributedText = [self handeText:[model.searchStr lowercaseString] total:[model.name lowercaseString] defaultFont:kFont(14) first:true];
    
    _addressLab.attributedText = [self handeText:[model.searchStr lowercaseString] total:[model.address lowercaseString] defaultFont:kFont(12) first:false];
    
    
    
    // update Frame
    CGFloat padding = adaptY(5);
    
    _nameLab.width = kScreenWidth-2*kDefaultPadding-adaptX(60);
    CGFloat nameH = [SDKAboutAttributedText calculateTextHeight:_nameLab.attributedText maxWidth:_nameLab.width];
    nameH = nameH < adaptY(30) ? adaptY(30) : nameH + padding;
    _nameLab.height = nameH;
    
    _addressLab.y = CGRectGetMaxY(_nameLab.frame);
    
    _addressLab.width = kScreenWidth-2*kDefaultPadding-adaptX(60);
    CGFloat addressH  = [SDKAboutAttributedText calculateTextHeight:_addressLab.attributedText maxWidth:_addressLab.width];
    addressH =  addressH < adaptY(20) ? adaptY(20) : addressH + padding;
    _addressLab.height = addressH;
    

    _distanceLab.centerY = CGRectGetMaxY(_addressLab.frame) *0.5;
}

+ (CGFloat)searchCellHeightWith:(SDKPoiModel *)model {
    NearbyListCell *cell = [[NearbyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
    [cell colorfulWithModel:model];
    
    [cell layoutIfNeeded];
    
    CGRect frame = cell.addressLab.frame;
    return frame.origin.y + frame.size.height + adaptY(5);
}

- (NSAttributedString *)handeText:(NSString *)str total:(NSString *)total defaultFont:(UIFont *)defaultFont first:(BOOL)first {

    NSRange mn_range = {0, total.length};
    
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:total];
    
    [attr addAttribute:NSForegroundColorAttributeName value:first ? commonBlackColor : commonGrayColor range:mn_range];
    [attr addAttribute:NSFontAttributeName value:defaultFont range:mn_range];
    
    
    NSError * error;
    NSRegularExpression * express = [NSRegularExpression regularExpressionWithPattern:str options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *> * result = [express matchesInString:total options:0 range:mn_range];
    for (NSTextCheckingResult * match in result) {
        NSRange range = [match range];
        [attr addAttribute:NSForegroundColorAttributeName value:kOrangeColor range:range];
    }
    NSAttributedString *attrString = [attr copy];
    
    
    return attrString;
}

@end
