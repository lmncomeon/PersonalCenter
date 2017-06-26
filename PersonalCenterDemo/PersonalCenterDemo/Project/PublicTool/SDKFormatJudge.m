//
//  SDKFormatJudge.m
//  supplier
//
//  Created by joke on 16/5/28.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import "SDKFormatJudge.h"
#import "SDKProjectHeader.h"
#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

@implementation SDKFormatJudge

+ (NSString *)stringWithdateFrom1970:(long long)date withFormat:(NSString *)formatString {
    NSDate *dateInfo = [NSDate date];
    if ([NSString stringWithFormat:@"%lld", date].length == 13) {
        dateInfo = [NSDate dateWithTimeIntervalSince1970:date/1000];
    }else if ([NSString stringWithFormat:@"%lld", date].length == 10) {
        dateInfo = [NSDate dateWithTimeIntervalSince1970:date];
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    NSString *dateString = [formatter stringFromDate:dateInfo];
    return dateString;
}

#pragma mark - 验证姓名
+ (BOOL)isValidateRealName:(NSString *)realName {
    NSString *regex = @"^[A-Za-z·\\u4e00-\\u9fa5]+$";
    NSPredicate *realNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [realNamePredicate evaluateWithObject:realName];
}
#pragma mark - 验证身份证号码
+ (BOOL)isValidateIDCardNumber:(NSString *)holdCard {
    BOOL rest = false;
    if (nil == holdCard || holdCard.length != 18) return rest;
    
    NSArray *powers = @[@7, @9, @10, @5, @8, @4, @2, @1, @6, @3, @7, @9, @10, @5, @8, @4, @2];
    
    NSArray *parityBit = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6",
                           @"5", @"4", @"3", @"2"];
    
    NSString *num = [holdCard substringWithRange:NSMakeRange(0, 17)];
    
    NSString *last = [holdCard substringFromIndex:holdCard.length-1];
    int power = 0;
    for (int i = 0; i < 17; i++) {
        if ([num characterAtIndex:i] < '0' || [num characterAtIndex:i] > '9') {
            return false;
        } else {
            unichar s = [num characterAtIndex:i];
            power += s * [powers[i] intValue];
        }
    }
    
    int mod = power % 11;
    NSString * modString = parityBit[mod];
    if ([modString caseInsensitiveCompare:last]) {
        rest = true;
    }
    return rest;
}
#pragma mark - 验证手机号码
+ (BOOL)isValidateMobile:(NSString *)mobile {
    NSString * phoneRegex = @"^1\\d{10}$";
    NSPredicate * phoneText= [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneText evaluateWithObject:mobile];
};
#pragma mark - 验证密码各式
+ (BOOL)isValidatePassword:(NSString *)password {
    //判断是否包含数字
    NSString *regex1 = @".*[0-9]+.*";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    BOOL isMatch1 = [pred1 evaluateWithObject:password];
    //判断是否包含小写字母
    NSString *regex2 = @".*[a-zA-Z]+.*";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    BOOL isMatch2 = [pred2 evaluateWithObject:password];
    if (isMatch1 == 1 && isMatch2 == 1) {
        return YES;
    }else {
        return NO;
    }
}
#pragma mark - Email格式验证
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString * emailRegex = @"^(\\w-*\\.*)+@(\\w-?)+(\\.\\w{2,})+$";
    NSPredicate * emailText= [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailText evaluateWithObject:email];
}

#pragma mark - 数据转json
/**
 *  数据数组转换为String格式
 *
 *  @param tmpArray 要处理的数组
 *
 *  @return 格式化之后的字符串
 */
+ (NSString *)arrayBecomeJsonWithArray:(NSArray *)tmpArray {
    if (tmpArray == nil) {
        return nil;
    }
    NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tmpArray options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        DLog(@"Successfully serialized the dictionary into data.");
        //NSData转换为String
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}
#pragma mark - 设置默认提示文字
+ (NSMutableAttributedString *)setTipTextWithString:(NSString *)string {
    NSMutableAttributedString *placeHolderString = [[NSMutableAttributedString alloc] initWithString:string];
    [placeHolderString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xccd1d6)} range:NSMakeRange(0, [string length])];
    return placeHolderString;
}

//显示图标
+ (UIImage *)stringWithBankCodeImage:(NSString *)bankCode{
    UIImage *result = nil;
    if ([bankCode isEqualToString:@"ICBC"]) {//工商
        result = [UIImage imageNamed:@"bankCode-ICBC"];
    }else if ([bankCode isEqualToString:@"CCB"]) {//建设
        result = [UIImage imageNamed:@"bankCode-CCB"];
    }else if ([bankCode isEqualToString:@"ABC"]) {//农业
        result = [UIImage imageNamed:@"bankCode-ABC"];
    }else if ([bankCode isEqualToString:@"BOC"]) {//中国
        result = [UIImage imageNamed:@"bankCode-BOC"];
    }else if ([bankCode isEqualToString:@"GZCB"]) {//广州
        result = [UIImage imageNamed:@"bankCode-GZCB"];
    }else if ([bankCode isEqualToString:@"GDB"]) {//广发
        result = [UIImage imageNamed:@"bankCode-GDB"];
    }else if ([bankCode isEqualToString:@"SPDB"]) {//浦发
        result = [UIImage imageNamed:@"bankCode-SPDB"];
    }else if ([bankCode isEqualToString:@"CMBC"]) {//民生
        result =[UIImage imageNamed:@"bankCode-CMBC"];
    }else if ([bankCode isEqualToString:@"ECITIC"]) {//中信
        result =[UIImage imageNamed:@"bankCode-ECITIC"];
    }else if ([bankCode isEqualToString:@"SZPA"]) {//平安
        result = [UIImage imageNamed:@"bankCode-SZPA"];
    }else if ([bankCode isEqualToString:@"HXB"]) {//华夏
        result = [UIImage imageNamed:@"bankCode-HXB"];
    }else if ([bankCode isEqualToString:@"CEB"]) {//光大
        result = [UIImage imageNamed:@"bankCode-CEB"];
    }else if ([bankCode isEqualToString:@"CIB"]) {//兴业
        result = [UIImage imageNamed:@"bankCode-CIB"];
    }else if ([bankCode isEqualToString:@"PSBC"]) {//邮政储蓄
        result =[UIImage imageNamed:@"bankCode-PSBC"];
    }else if ([bankCode isEqualToString:@"CMBCHINA"]) {//招商
        result = [UIImage imageNamed:@"bankCode-CMBCHINA"];
    }else if ([bankCode isEqualToString:@"BOCO"]) {//交通
        result = [UIImage imageNamed:@"bankCode-BOCO"];
    }else {
        //        result = [UIImage imageNamed:@"bankCode-BOC"];
    }
    return result;
}

@end
