//
//  FlowModel.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/27.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) BOOL isLast;

+ (instancetype)modelWithTitle:(NSString *)title content:(NSString *)content num:(NSInteger)num isLast:(BOOL)isLast;

@end
