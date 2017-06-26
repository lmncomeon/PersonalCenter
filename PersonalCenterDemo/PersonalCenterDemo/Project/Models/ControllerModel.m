//
//  ControllerModel.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/26.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "ControllerModel.h"

@implementation ControllerModel

+ (instancetype)modelWithTitle:(NSString *)title className:(NSString *)className {
    ControllerModel *model = [ControllerModel new];
    model.title = title;
    model.className = className;
    
    return model;
}

@end
