//
//  SDKAboutString.h
//  handheldCredit
//
//  Created by 栾美娜 on 2017/8/21.
//  Copyright © 2017年 liguiwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKAboutString : NSObject

// 汉字转拼音
+ (NSString *)transform:(NSString *)chinese;

// 汉字转拼音
+ (NSString *)transformMandarinToLatin:(NSString *)string;

@end
