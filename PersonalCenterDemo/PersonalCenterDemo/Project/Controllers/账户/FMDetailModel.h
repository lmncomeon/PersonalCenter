//
//  FMDetailModel.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/14.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDetailModel : NSObject

@property (nonatomic, copy) NSString *sended;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *giftName;
@property (nonatomic, copy) NSString *giftCount;

@property (nonatomic, copy) NSString *type; // 收益:0 消费:1

@end




@interface FMDetailGroupModel : NSObject

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, strong) NSArray <FMDetailModel *> *list;

@end
