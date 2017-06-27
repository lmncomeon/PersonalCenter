//
//  FlowModel.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/27.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FlowModel.h"

@implementation FlowModel

+ (instancetype)modelWithTitle:(NSString *)title content:(NSString *)content num:(NSInteger)num isLast:(BOOL)isLast {
    FlowModel *model = [FlowModel new];
    model.title = title;
    model.content = content;
    model.num = num;
    model.isLast = isLast;
    
    return model;
}

@end
