//
//  LiveViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/8/29.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "LiveViewController.h"
#import "FMLivePrettyView.h"
#import "SDKCustomLabel.h"
#import "MNPrettyAvatar.h"

@interface LiveViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *avatorsArray;

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.avatorsArray = [NSMutableArray array];
    
//    FMLivePrettyView *contentView = [[FMLivePrettyView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:contentView];
    
    
    
    CGFloat defaultWH = 100;
    CGFloat defaultX  = 10;
    CGFloat defaultY  = 60;
    CGFloat defaultPadding = 10;
    
    for (int i = 0; i < 3; i++) {
        MNPrettyAvatar *mnAvatar = [[MNPrettyAvatar alloc] initWithFrame:(CGRect){{defaultX, defaultY}, {defaultWH, defaultWH}} imageName:@"timg.jpg"];
        [self.view addSubview:mnAvatar];
        [self.avatorsArray addObject:mnAvatar];
        
        defaultWH += 10;
        defaultX  += mnAvatar.width + defaultPadding;
        defaultY  += mnAvatar.height + defaultPadding;
        
    }

    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:true block:^(NSTimer * _Nonnull timer) {
        
        for (int i = 0; i < self.avatorsArray.count; i++) {
            MNPrettyAvatar *item = self.avatorsArray[i];
          
            [UIView animateWithDuration:1 animations:^{
                item.transform = CGAffineTransformRotate(item.transform, M_PI_4);
            }];
        }
        
    }];

    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    

}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
