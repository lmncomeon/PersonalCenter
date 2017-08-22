//
//  MapViewController.h
//  AllDemo
//
//  Created by 美娜栾 on 2017/8/19.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseViewController.h"

@interface MapViewController : SDKBaseViewController

@property (nonatomic, copy) void (^mapValueBlock)(NSString *provinces, NSString *address);


@end
