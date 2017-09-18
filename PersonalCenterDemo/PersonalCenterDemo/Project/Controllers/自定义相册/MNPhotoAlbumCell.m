//
//  MNPhotoAlbumCell.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "MNPhotoAlbumCell.h"
#import "SDKProjectHeader.h"
#import "UIView+CustomView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ColorImage.h"
#import "MNPhotoAlbum.h"

@interface MNPhotoAlbumCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation MNPhotoAlbumCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = true;
        [self.contentView addSubview:_imgView];
        
        CGFloat padding = adaptX(4);
        CGFloat btnWH   = adaptX(20);
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(frame.size.width-padding-btnWH, padding, btnWH, btnWH);
        _btn.layer.masksToBounds = true;
        _btn.layer.cornerRadius = btnWH*0.5;
        _btn.backgroundColor = UIColorFromRGB(0xFA5A5A);
        [_btn setTitle:@"" forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn];
        
    }
    return self;
}

- (void)btnAction:(UIButton *)sender {
    self.model.selected = !self.model.selected;
    
    sender.backgroundColor = self.model.selected ? [UIColor greenColor] : UIColorFromRGB(0xFA5A5A);

    if (self.model.selected) {
        [self addSpringAnimationWithTarget:(UIView *)sender];
    }
    
    !_clickEvent ? : _clickEvent();
}

- (void)setModel:(MNPhotoAlbum *)model {
    _model = model;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageWithColor:[UIColor grayColor]]];
//    _imgView.image = model.image;
    _btn.backgroundColor = model.selected ? [UIColor greenColor] : UIColorFromRGB(0xFA5A5A);
    [_btn setTitle:model.num forState:0];
}

- (void)addSpringAnimationWithTarget:(UIView *)target {
    target.transform = CGAffineTransformIdentity;
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            target.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        
        
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            target.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        
        
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            target.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        
        
    } completion:nil];
}

@end
