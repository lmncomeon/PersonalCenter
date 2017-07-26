//
//  RSAViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/14.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "RSAViewController.h"
#import "RSAEncryptor.h"

@interface RSAViewController ()

@end

@implementation RSAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //原始数据
    NSString *originalString = @"这是一段将要使用'.der'文件加密的字符串!";
    //使用.der和.p12中的公钥私钥加密解密
    NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"rsa_public_key.der" ofType:nil];
    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"rsa_private_key.p12" ofType:nil];
    NSString *encryptStr = [RSAEncryptor encryptString:originalString publicKeyWithContentsOfFile:public_key_path];
    
     NSLog(@"加密前:%@", originalString);
     NSLog(@"加密后:%@", encryptStr);
    
    
    NSLog(@"解密后:%@", [RSAEncryptor decryptString:encryptStr privateKeyWithContentsOfFile:private_key_path password:@"000000"]);
    
    
}

- (NSString *)decryptWithString:(NSString *)encryptStr {
   
    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"rsa_private_key.p12" ofType:nil];
    return [RSAEncryptor decryptString:encryptStr privateKeyWithContentsOfFile:private_key_path password:@"000000"];
    
}

- (NSString *)encryptWithString:(NSString *)originalString {
    NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"rsa_public_key.der" ofType:nil];
    return [RSAEncryptor encryptString:originalString publicKeyWithContentsOfFile:public_key_path];
}

@end
