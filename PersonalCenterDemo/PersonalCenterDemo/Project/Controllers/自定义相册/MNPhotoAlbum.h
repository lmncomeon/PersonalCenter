//
//  MNPhotoAlbum.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MNPhotoAlbum : NSObject

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *num;
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) NSInteger age;

@end
