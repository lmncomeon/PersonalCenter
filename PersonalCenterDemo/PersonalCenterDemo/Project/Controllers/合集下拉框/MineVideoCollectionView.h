//
//  MineVideoCollectionView.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineVideoCollectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame list:(NSArray <NSString *> *)list;

- (void)collectionShow;

@property (nonatomic, copy) dispatch_block_t shareEvent; // 分享
@property (nonatomic, copy) dispatch_block_t createEvent; // 新建集合


@property (nonatomic, copy) void (^otherEvent)(NSString *value);

- (void)collectionHide;

//- (void)reloadDataViewWithValue:(NSString *)value;

@end
