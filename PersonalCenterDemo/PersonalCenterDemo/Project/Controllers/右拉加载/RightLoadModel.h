//
//  RightLoadModel.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/27.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RightLoadModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *imageName;

+ (instancetype)loadWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end
