//
//  SDKAboutAttributedText.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SDKAboutAttributedText : NSObject

+ (CGFloat)calculateTextHeight:(NSAttributedString *)attrText maxWidth:(CGFloat)maxWidth;

+ (CGFloat)calcaulateTextWidth:(NSAttributedString *)attrText height:(CGFloat)height;

@end
