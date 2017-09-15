//
//  FMDetailModel.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/14.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FMDetailModel.h"

@implementation FMDetailModel

@end



@implementation FMDetailGroupModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [FMDetailModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"dateString" : @"date"};
}

@end
