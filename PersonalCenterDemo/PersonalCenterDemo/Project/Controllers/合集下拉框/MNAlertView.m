//
//  MNAlertView.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "MNAlertView.h"
#import "SDKProjectHeader.h"
#import "UIView+CustomView.h"

#import "SDKCustomLabel.h"
#import "SDKAboutAttributedText.h"

@interface MNAlertView ()

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) SDKCustomLabel *titleLab;
@property (nonatomic, strong) SDKCustomLabel *contentLab;

@property (nonatomic, assign) id<MNAlertViewDelegate> delegate;

@end

@implementation MNAlertView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content buttons:(NSArray <NSString *> *)buttons delegate:(id<MNAlertViewDelegate>)delegate {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        CGFloat padding = adaptX(50);
        CGFloat margin  = adaptX(10);
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(padding, 0, kScreenWidth-2*padding, 0)];
        _container.layer.masksToBounds = true;
        _container.layer.cornerRadius = adaptX(5);
        _container.backgroundColor = UIColorFromRGB(0xf1f1f1);
        [self addSubview:_container];

        if (title) {
            NSAttributedString *attr = [self createAttrWithText:title attrDic:@{NSFontAttributeName : kWeightFont(14, 2)}];
            
            _titleLab = [SDKCustomLabel setLabelAttrTitle:attr setLabelFrame:CGRectMake(margin, margin, _container.width-2*margin, 0) setAlignment:1];
            _titleLab.numberOfLines = 0;
            _titleLab.height = [SDKAboutAttributedText calculateTextHeight:attr maxWidth:_titleLab.width];
            [_container addSubview:_titleLab];

        }
        
        if (content) {
            NSAttributedString *attr = [self createAttrWithText:content attrDic:@{NSFontAttributeName : kFont(12)}];
            
            _contentLab = [SDKCustomLabel setLabelAttrTitle:attr setLabelFrame:CGRectMake(margin, CGRectGetMaxY(_titleLab.frame) + margin, _container.width-2*margin, 0) setAlignment:1];
            _contentLab.numberOfLines = 0;
            _contentLab.height = [SDKAboutAttributedText calculateTextHeight:attr maxWidth:_contentLab.width];
            [_container addSubview:_contentLab];
        }
        
        if (buttons) {
            UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentLab.frame) + adaptY(15), _container.width, 0.5f)];
            horizontalLine.backgroundColor = UIColorFromRGB(0xafafaf);
            [_container addSubview:horizontalLine];
            
            if (buttons.count < 2)
            {
            
                for (int i = 0; i < buttons.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(i*(_container.width/buttons.count), CGRectGetMaxY(horizontalLine.frame), _container.width/buttons.count, adaptY(35));
                    [btn setTitle:buttons[i] forState:UIControlStateNormal];
                    [btn setTitleColor:commonBlackColor forState:UIControlStateNormal];
                    btn.tag = 1000 + i;//tag;
                    btn.titleLabel.textAlignment = 1;
                    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [_container addSubview:btn];
                    
                    
                }
            }

        }
        
        _container.height = CGRectGetMaxY(_container.subviews.lastObject.frame);
        _container.center = CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5);
        
    }
    return self;
}

- (void)buttonAction:(UIButton *)sender {
    [self alertHide];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(MNAlertView:clickedButtonAtIndex:)]) {
        [self.delegate MNAlertView:self clickedButtonAtIndex:sender.tag-1000];
    }
}

- (void)alertShow {
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_container.layer addAnimation:animation forKey:nil];
}

- (void)alertHide {
    [self removeFromSuperview];
}

- (NSMutableAttributedString *)createAttrWithText:(NSString *)text attrDic:(NSDictionary *)attrDic {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text attributes:attrDic];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 2;
    
    [attr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, text.length)];
    
    return attr;
}

@end
