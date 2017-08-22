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

@end
