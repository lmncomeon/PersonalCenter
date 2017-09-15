//
//  FMIncomeOrConsumptionDetailViewController.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/14.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseViewController.h"

typedef NS_ENUM(NSInteger, FMViewControllerType) {
    FMViewControllerTypeIncome,     // 收益
    FMViewControllerTypeConsumption // 消费
};

@interface FMIncomeOrConsumptionDetailViewController : SDKBaseViewController

@property (nonatomic, assign) FMViewControllerType displayType;

@end
