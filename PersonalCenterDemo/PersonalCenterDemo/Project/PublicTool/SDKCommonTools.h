//
//  SDKCommonTools.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKCommonTools : NSObject

/** 解析json文件 */
+ (NSDictionary *)dicFromJsonFileName:(NSString *)fileName;

/** 编码转换 */
+ (NSString *)replaceUnicode:(NSString*)aUnicodeString;

@end
