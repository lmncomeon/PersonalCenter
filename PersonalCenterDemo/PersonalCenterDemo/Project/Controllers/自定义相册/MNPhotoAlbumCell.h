//
//  MNPhotoAlbumCell.h
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNPhotoAlbum;

@interface MNPhotoAlbumCell : UICollectionViewCell

@property (nonatomic, strong) MNPhotoAlbum *model;

@property (nonatomic, copy) dispatch_block_t clickEvent;

@end
