//
//  PWDView.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/6/27.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "PWDView.h"
#import "UIView+CustomView.h"
#import "SDKProjectHeader.h"
#import "SDKJWTextField.h"

@interface PWDView ()

@property (nonatomic, strong) NSMutableArray <UITextField *> *array;
@property (nonatomic, strong) SDKJWTextField *bigTextField;

@end

@implementation PWDView

- (instancetype)initWithFrame:(CGRect)frame inputCount:(NSInteger)inputCount
{
    self = [super initWithFrame:frame];
    if (self) {
        self.array = [NSMutableArray arrayWithCapacity:10];
        
        CGFloat margin  = adaptX(15);
        CGFloat padding = adaptX(10);
        CGFloat fieldWH = (kScreenWidth-2*margin-(inputCount-1)*padding)/inputCount;
        for (int i = 0; i < inputCount; i++) {
            SDKJWTextField *field = [[SDKJWTextField alloc] initWithFrame:CGRectMake(margin+i*(padding+fieldWH), padding, fieldWH, fieldWH)];
            field.userInteractionEnabled = false;
            field.textAlignment = 1;
//            field.secureTextEntry = YES;
            field.borderStyle = UITextBorderStyleRoundedRect;
            [self addSubview:field];
            [self.array addObject:field];
        }
        
        _bigTextField = [[SDKJWTextField alloc] initWithFrame:CGRectMake(margin, padding, kScreenWidth-2*padding, fieldWH)];
        _bigTextField.tintColor = [UIColor clearColor];
        _bigTextField.textColor = [UIColor clearColor];
        _bigTextField.importStyle = TextFieldImportStyleNumberTwo;
        HXWeak_self
        _bigTextField.importBackString = ^ (NSString *value) {
            HXStrong_self
            
            if (value.length == inputCount) {
                
                [self.bigTextField endEditing:YES];
                self.bigTextField.text = value;
            }
            
            for (int i = 0; i < inputCount; i++) {
                
                if (i+1 > value.length) {
                    self.array[i].text = @"";
                } else {
                    NSString *str = [value substringWithRange:NSMakeRange(i, 1)];
                    self.array[i].text = str;
                }
                
            }
            
            
        };
        [self addSubview:_bigTextField];
        
        self.height = CGRectGetMaxY(self.subviews.lastObject.frame) + padding;
        
    }
    return self;
}

- (NSString *)getPWD {
    NSMutableString *str = [NSMutableString string];
    
    for (UITextField *field in self.array) {
        [str appendString:field.text];
    }

    return str.copy;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    
    for (UITextField *field in self.array) {
        field.layer.borderColor = borderColor.CGColor;
        field.layer.borderWidth = 1;
        field.layer.masksToBounds = true;
        field.layer.cornerRadius  = 5;
    }
}


@end
