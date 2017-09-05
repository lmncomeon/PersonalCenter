//
//  MNPrettyAvatar.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/1.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "MNPrettyAvatar.h"

@interface MNPrettyAvatar ()

@property (nonatomic, weak) CALayer *shadowLayer;

@end

@implementation MNPrettyAvatar

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName {
    self = [super initWithFrame:frame];
    if (self) {
        CALayer *shadowLayer = [CALayer layer];
        shadowLayer.frame = self.bounds;
        shadowLayer.shadowOpacity = 1;
        shadowLayer.shadowOffset  = CGSizeMake(2, 2);
        shadowLayer.shadowColor   = [UIColor grayColor].CGColor;
        shadowLayer.cornerRadius  = frame.size.width*0.5;
        shadowLayer.borderWidth   = 2;
        shadowLayer.borderColor   = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:shadowLayer];
        self.shadowLayer = shadowLayer;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:shadowLayer.bounds];
        icon.image = [UIImage imageNamed:imageName];
        icon.layer.masksToBounds = true;
        icon.layer.cornerRadius  = frame.size.width*0.5;
        [shadowLayer addSublayer:icon.layer];
    }
    return self;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    
    self.shadowLayer.borderColor = borderColor.CGColor;
}

@end
