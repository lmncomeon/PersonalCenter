//
//  ControllerModel.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/26.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControllerModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *className;

+ (instancetype)modelWithTitle:(NSString *)title className:(NSString *)className;

@end
