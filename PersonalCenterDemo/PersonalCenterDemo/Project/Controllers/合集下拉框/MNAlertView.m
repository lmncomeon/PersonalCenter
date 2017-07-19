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
#import "SDKAboutText.h"
#import "SDKAboutAttributedText.h"

#define maxContainerH   (kScreenHeight-adaptX(200))
#define maxbuttonsViewH adaptY(35)*6

@interface MNAlertView ()

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) SDKCustomLabel *titleLab; // 标题
@property (nonatomic, strong) UITextView *contentTextView; // 内容
@property (nonatomic, strong) NSMutableArray <UIButton *> *btnsArray;

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
            NSAttributedString *attr = [self createAttrWithText:title attrDic:@{NSFontAttributeName : kWeightFont(16, 2)}];
            
            _titleLab = [SDKCustomLabel setLabelAttrTitle:attr setLabelFrame:CGRectMake(margin, margin, _container.width-2*margin, 0) setAlignment:1];
            _titleLab.numberOfLines = 0;
            _titleLab.height = [SDKAboutAttributedText calculateTextHeight:attr maxWidth:_titleLab.width];
            [_container addSubview:_titleLab];

        }
        
        if (content) {
            NSAttributedString *attr = [self createAttrWithText:content attrDic:@{NSFontAttributeName : kFont(12)}];
            
            CGFloat contentH =  [SDKAboutAttributedText calculateTextHeight:attr maxWidth:_container.width] + adaptY(30);
            
            contentH = contentH > maxContainerH ? maxContainerH : contentH;
            
            _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(_titleLab.frame) + margin, _container.width-2*margin, contentH)];
            _contentTextView.attributedText = attr;
            _contentTextView.textAlignment = 1;
            _contentTextView.editable = NO;
            _contentTextView.backgroundColor = UIColorFromRGB(0xf1f1f1);
            [_container addSubview:_contentTextView];
        }
        
        
        if (buttons) {
            UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentTextView.frame) + adaptY(15), _container.width, 0.5f)];
            horizontalLine.backgroundColor = UIColorFromRGB(0xafafaf);
            [_container addSubview:horizontalLine];
            
            CGFloat btnHeight = adaptY(35);
            
            if (buttons.count <= 2)
            { // 水平布局
            
                for (int i = 0; i < buttons.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(i*(_container.width/buttons.count), CGRectGetMaxY(horizontalLine.frame), _container.width/buttons.count, btnHeight);
                    [btn setTitle:buttons[i] forState:UIControlStateNormal];
                    [btn setTitleColor:commonBlackColor forState:UIControlStateNormal];
                    btn.tag = 1000 + i;//tag;
                    btn.titleLabel.font = kFont(14);
                    btn.titleLabel.textAlignment = 1;
                    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [_container addSubview:btn];
                    [self.btnsArray addObject:btn];
                    
                    if (i != buttons.count-1) {
                        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), btn.y, 0.5f, btn.height)];
                        line.backgroundColor = UIColorFromRGB(0xafafaf);
                        [_container addSubview:line];
                    }
                }
            }
            else
            { // 垂直布局
                UIScrollView *buttonsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(horizontalLine.frame), _container.width, 0)];
                [_container addSubview:buttonsView];
                
                
                for (int j = 0; j < buttons.count; j++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(0, j*btnHeight, _container.width, btnHeight);
                    [btn setTitle:buttons[j] forState:UIControlStateNormal];
                    [btn setTitleColor:commonBlackColor forState:UIControlStateNormal];
                    btn.tag = 1000 + j;//tag;
                    btn.titleLabel.textAlignment = 1;
                    btn.titleLabel.font = kFont(14);
                    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [buttonsView addSubview:btn];
                    [self.btnsArray addObject:btn];
                    
                    if (j != buttons.count-1) {
                        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame), _container.width, 0.5f)];
                        line.backgroundColor = UIColorFromRGB(0xafafaf);
                        [buttonsView addSubview:line];
                    }
                }
                
                CGFloat buttonsViewH = CGRectGetMaxY(buttonsView.subviews.lastObject.frame);
                
                buttonsView.contentSize = CGSizeMake(0, buttonsViewH);
                buttonsViewH = buttonsViewH > maxbuttonsViewH ?  maxbuttonsViewH : buttonsViewH;
                buttonsView.height = buttonsViewH;
            }

        }
        
        if (!buttons) {
            HXWeak_self
            [self addSingleTapEvent:^{
                HXStrong_self
                
                [self alertHide];
            }];
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

// ******************** 设置按钮颜色 ****************
- (void)settingButtonTextColor:(UIColor *)textColor index:(NSInteger)index {
    [self.btnsArray[index] setTitleColor:textColor forState:UIControlStateNormal];
}

// ******************** 设置按钮字号 ****************************
- (void)settingButtonFont:(UIFont *)font index:(NSInteger)index {
    self.btnsArray[index].titleLabel.font = font;
}

- (NSMutableAttributedString *)createAttrWithText:(NSString *)text attrDic:(NSDictionary *)attrDic {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text attributes:attrDic];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 2;
    
    [attr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, text.length)];
    
    return attr;
}

#pragma mark - lazy load
- (NSMutableArray <UIButton *> *)btnsArray {
    if (!_btnsArray) {
        _btnsArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _btnsArray;
}

@end
