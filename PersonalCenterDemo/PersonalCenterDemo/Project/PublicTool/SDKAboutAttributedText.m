//
//  SDKAboutAttributedText.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKAboutAttributedText.h"

@implementation SDKAboutAttributedText

+ (CGFloat)calculateTextHeight:(NSAttributedString *)attrText maxWidth:(CGFloat)maxWidth {
    return [attrText boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
}

+ (CGFloat)calcaulateTextWidth:(NSAttributedString *)attrText height:(CGFloat)height {
    return [attrText boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
}


@end
