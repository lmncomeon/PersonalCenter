//
//  QQGroupModel.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/6.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QQCellModel;

@interface QQGroupModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL spread;
@property (nonatomic, strong) NSArray <QQCellModel *> *list;

@end





@interface QQCellModel : NSObject

@property (nonatomic, copy) NSString *content;

@end
