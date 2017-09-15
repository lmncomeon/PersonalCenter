
//
//  SDKFormatJudge.h
//  supplier
//
//  Created by joke on 16/5/28.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SDKFormatJudge : NSObject
/**
 *  时间转换
 */
+ (NSString *)stringWithdateFrom1970:(long long)date withFormat:(NSString *)formatString;
/**
 *  验证姓名
 */
+ (BOOL)isValidateRealName:(NSString *)realName;
/**
 *  验证身份证号码
 */
+ (BOOL)isValidateIDCardNumber:(NSString *)value;
/**
 *  手机号格式判断
 */
+ (BOOL)isValidateMobile:(NSString *)mobile;
/**
 *  密码格式判断
 */
+ (BOOL)isValidatePassword:(NSString *)password;
/**
 *  Email格式判断
 */
+ (BOOL)isValidateEmail:(NSString *)email;

#pragma mark - 数组转json
+ (NSString *)arrayBecomeJsonWithArray:(NSArray *)tmpArray;

#pragma mark - 字典转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

// 清除首尾空格
+ (NSString *)deleteWhitespace:(NSString *)str;


@end
