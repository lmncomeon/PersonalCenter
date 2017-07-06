//
//  FoldModel.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/5.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FoldModel.h"

@implementation FoldModel

+ (instancetype)modelWithTitle:(NSString *)title content:(NSString *)content {
    FoldModel *model = [FoldModel new];
    model.title   = title;
    model.content = content;
    
    return model;
}

@end
