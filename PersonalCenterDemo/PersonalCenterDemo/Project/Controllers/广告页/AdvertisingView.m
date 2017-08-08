//
//  AdvertisingView.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/8/8.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "AdvertisingView.h"
#import "SDKCustomRoundedButton.h"
#import "SDKProjectHeader.h"
#import <AVFoundation/AVFoundation.h>

#define defaultValue 5

@interface AdvertisingView ()

@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *avPlayerItem;
@property (nonatomic,strong) AVPlayerLayer *avPlayerLayer;

@property (nonatomic, strong) SDKCustomRoundedButton *closeBtn;
@property (nonatomic, strong) SDKCustomRoundedButton *timeBtn;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger currentValue;
@property (nonatomic, assign) NSInteger recordDuration;

@end

@implementation AdvertisingView

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSString *)videoUrl duration:(NSInteger)duration
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor orangeColor];

        self.currentValue = 0;
        self.recordDuration = duration;
        
        
        self.avPlayerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoUrl]];
        
        self.player = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
        
        self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.avPlayerLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height-30);
        [self.layer addSublayer:self.avPlayerLayer];
   
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayerItem];
        
        
        [self.player play];
        
        // 时间层
        _closeBtn = [SDKCustomRoundedButton roundedBtnWithTitle:@"关闭" font:kFont(14) titleColor:[UIColor whiteColor] backgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        _closeBtn.frame = CGRectMake(frame.size.width-adaptX(120), 10, adaptX(50), adaptY(20));
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        
        // 倒计时
        _timeBtn = [SDKCustomRoundedButton roundedBtnWithTitle:[NSString stringWithFormat:@"%lds", (long)duration] font:kFont(14) titleColor:[UIColor whiteColor] backgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        _timeBtn.frame = CGRectMake(CGRectGetMaxX(_closeBtn.frame) + adaptX(10), 10, adaptX(50), adaptY(20));
        [self addSubview:_timeBtn];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:true];
         [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        // default
        _closeBtn.hidden = true;
    }
    return self;
}

- (void)closeAction {
    
    [self endPlayer];
}

- (void)playEnd {
    [self endPlayer];
}

- (void)changeTime {
    [self handleCloseBtnMethod];
    
    [self handleCountDownShowMethod];
}

- (void)handleCloseBtnMethod {
    self.currentValue ++;
    if (self.currentValue >= defaultValue) {
        self.closeBtn.hidden = false;
    }
}

- (void)handleCountDownShowMethod {
    self.recordDuration--;
    
    if (self.recordDuration <= 0) {
        [self endPlayer];
        return;
    }
    
    [_timeBtn setTitle:[NSString stringWithFormat:@"%lds", (long)self.recordDuration] forState:UIControlStateNormal];
}

/** 结束播放 */
- (void)endPlayer {
    [[NSNotificationCenter defaultCenter] removeObserver:self.avPlayerItem];
    
    self.player = nil;
    self.avPlayerLayer = nil;
    self.avPlayerItem  = nil;
    
    [self removeFromSuperview];
    
    [_timer invalidate];
    _timer = nil;
    
    self.currentValue = 0;
    
}



@end
