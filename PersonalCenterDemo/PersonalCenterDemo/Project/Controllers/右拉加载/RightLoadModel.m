//
//  RightLoadModel.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/27.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "RightLoadModel.h"

@implementation RightLoadModel

+ (instancetype)loadWithTitle:(NSString *)title imageName:(NSString *)imageName {
    RightLoadModel *model = [RightLoadModel new];
    model.title = title;
    model.imageName = imageName;
    
    return model;
}

@end
