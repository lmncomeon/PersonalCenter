//
//  VideoListViewController.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/26.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseViewController.h"

@interface VideoListViewController : SDKBaseViewController

@property (nonatomic, copy) void (^scrollDerictionEvent)(BOOL up);

@end
