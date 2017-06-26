//
//  IntroViewController.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/26.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseViewController.h"

@interface IntroViewController : SDKBaseViewController

@property (nonatomic, copy) void (^scrollDerictionEvent)(BOOL up);

@end
