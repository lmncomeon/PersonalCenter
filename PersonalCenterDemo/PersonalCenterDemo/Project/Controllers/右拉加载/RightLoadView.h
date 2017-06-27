//
//  RightLoadView.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/27.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RightLoadModel;
@interface RightLoadView : UIScrollView

@property (nonatomic, strong) NSArray <RightLoadModel *> *dataList;

@property (nonatomic, copy) dispatch_block_t loadMore;

@end
