//
//  SDKCityListViewController.h
//  handheldCredit
//
//  Created by 栾美娜 on 2017/8/21.
//  Copyright © 2017年 liguiwen. All rights reserved.
//

#import "SDKBaseViewController.h"

@interface SDKCityListViewController : SDKBaseViewController

@property (nonatomic, copy) NSString *currentString;

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray *indexArray;

@property (nonatomic, copy) void (^sendValue)(NSString *str);

@end
