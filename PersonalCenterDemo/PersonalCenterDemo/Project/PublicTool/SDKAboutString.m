//
//  SDKAboutString.m
//  handheldCredit
//
//  Created by 栾美娜 on 2017/8/21.
//  Copyright © 2017年 liguiwen. All rights reserved.
//

#import "SDKAboutString.h"

@implementation SDKAboutString

// 汉字转拼音
+ (NSString *)transform:(NSString *)chinese {
    if (!chinese || chinese.length == 0) { return @""; }
    
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    
    return [pinyin uppercaseString];
}


// 汉字转拼音
+ (NSString *)transformMandarinToLatin:(NSString *)string
{
    if (!string || string.length == 0) { return @""; }
    
    /*复制出一个可变的对象*/
    NSMutableString *preString = [string mutableCopy];
    /*转换成成带音 调的拼音*/
    CFStringTransform((CFMutableStringRef)preString, NULL, kCFStringTransformMandarinLatin, NO);
    /*去掉音调*/
    CFStringTransform((CFMutableStringRef)preString, NULL, kCFStringTransformStripDiacritics, NO);
    
    /*多音字处理*/
    if ([[(NSString *)string substringToIndex:1] compare:@"长"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"沈"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"厦"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"地"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"di"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"重"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    return preString;
}

@end
