//
//  AdvertisementView.m
//  SubscriptionDemo
//
//  Created by 栾美娜 on 2017/6/19.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "AdvertisementView.h"
#import "SDKProjectHeader.h"
#import "UIView+CustomView.h"
#import "SDKCustomLabel.h"

@interface AdvertisementView ()

@property (nonatomic, strong) SDKCustomLabel *oneLab;
@property (nonatomic, strong) SDKCustomLabel *twoLab;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentIndex;

@end

static CGFloat const animationDuration = 1;

@implementation AdvertisementView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _oneLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(kDefaultPadding, -self.frame.size.height, self.frame.size.width-2*kDefaultPadding, self.frame.size.height) setLabelColor:[UIColor blackColor] setLabelFont:kFont(12)];
        [self addSubview:_oneLab];
        
        _twoLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(kDefaultPadding, 0, self.frame.size.width-2*kDefaultPadding, self.frame.size.height) setLabelColor:[UIColor blackColor] setLabelFont:kFont(12)];
        [self addSubview:_twoLab];

        // default
        _currentIndex = 0;
        self.layer.masksToBounds = true;
    }
    return self;
}

- (void)setContentList:(NSArray<NSString *> *)contentList {
    _contentList = contentList;
    
    if (!contentList || contentList.count == 0) return;
    
    [self stopAutoPlay];
    [self startTimer];
    
    
    if (contentList.count == 1) {
        _oneLab.text = contentList[0];
        _twoLab.text = contentList[0];
    } else {
        _twoLab.text = contentList[_currentIndex];
        
        [self increaseIndex];
        _oneLab.text = contentList[_currentIndex];
    }
 
}

- (void)increaseIndex {
    _currentIndex++;
    
    if (_currentIndex > self.contentList.count-1) {
        _currentIndex = 0;
    }
}

- (void)startAction {
    [UIView animateWithDuration:animationDuration animations:^{
        _oneLab.y += self.frame.size.height;
        _twoLab.y += self.frame.size.height;
    } completion:^(BOOL finished) {
        _twoLab.y -= 2*self.frame.size.height;
        
        [self increaseIndex];
        _twoLab.text = self.contentList[_currentIndex];
    }];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:animationDuration animations:^{
            _twoLab.y += self.frame.size.height;
            _oneLab.y += self.frame.size.height;
        } completion:^(BOOL finished) {
            _oneLab.y -= 2*self.frame.size.height;
            
            [self increaseIndex];
            _oneLab.text = self.contentList[_currentIndex];
        }];
    });
}

- (void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:2*animationDuration target:self selector:@selector(startAction) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopAutoPlay {
    [_timer invalidate];
    _timer = nil;
}

@end
