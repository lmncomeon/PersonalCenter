//
//  SDKCommonTools.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKCommonTools.h"

@implementation SDKCommonTools

/** 解析json文件 */
+ (NSDictionary *)dicFromJsonFileName:(NSString *)fileName {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (!error) {
        return dic;
    } else {
        NSLog(@"json解析失败");
    }
    
    return nil;
}

/** 编码转换 */
+ (NSString *)replaceUnicode:(NSString*)aUnicodeString
{
    NSError *error = nil;
    
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData  *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:0 format:NULL error:&error];

    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

@end
