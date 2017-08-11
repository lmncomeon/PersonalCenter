//
//  AdvertisingView.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/8/8.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "AdvertisingView.h"
#import "SDKCustomRoundedButton.h"
#import "SDKCustomLabel.h"
#import "SDKProjectHeader.h"
#import "Masonry.h"


#define defaultValue 5

@interface AdvertisingView ()

@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *avPlayerItem;


@property (nonatomic, strong) SDKCustomLabel *loadingLab;

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
        
        self.loadingLab = [SDKCustomLabel setLabelTitle:@"加载中，请稍后......" setLabelFrame:CGRectMake(0, (frame.size.height-adaptY(20)) * 0.5, frame.size.width, adaptY(20)) setLabelColor:[UIColor whiteColor] setLabelFont:kWeightFont(12, 2) setAlignment:1];
        self.loadingLab.backgroundColor = [UIColor redColor];
        [self addSubview:self.loadingLab];
        

        self.currentValue = 0;
        self.recordDuration = duration;
        
        
        self.avPlayerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoUrl]];
        
        self.player = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
        
        self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        [self.layer addSublayer:self.avPlayerLayer];
   
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayerItem];
        
        
        [self.avPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        
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
        
        
        // mas
        [self.loadingLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.center.equalTo(self.loadingLab.superview);
            
        }];
        
        [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(50, 20));
            make.right.mas_equalTo(-10);
        }];
        
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(_timeBtn.mas_left).offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 20));
            
        }];
        
        
        
        // default
        _timeBtn.hidden = _closeBtn.hidden = true;
        _loadingLab.hidden = false;
        
    }
    return self;
}

// 点击关闭
- (void)closeAction {
    [self endPlayer];
}

// 播放结束
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


// 监听status
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"])
    {
        if ([self.avPlayerItem status] == AVPlayerItemStatusReadyToPlay) {
            _timeBtn.hidden = false;
            _loadingLab.hidden = true;
            
            [self startTimer];
        }
            
    }
}

- (void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/** 结束播放 */
- (void)endPlayer {
    
    [self handleEndActionWithPostBool:true];

}

- (void)dealloc {
    
    [self handleEndActionWithPostBool:false];
}

- (void)handleEndActionWithPostBool:(BOOL)postBool {
    [self.player pause];
    
    // notification
    [[NSNotificationCenter defaultCenter] removeObserver:self.avPlayerItem];
    [self.avPlayerItem removeObserver:self forKeyPath:@"status" context:nil];
    
    
    // player
    self.player = nil;
    self.avPlayerLayer = nil;
    self.avPlayerItem  = nil;
    
    
    // timer
    [_timer invalidate];
    _timer = nil;
    
    // 重置
    self.currentValue = 0;
    
    if (postBool)
    {
        !_playEndBlock ? : _playEndBlock();
    }
    
    [self removeFromSuperview];
}

@end
