//
//  SDKResultTableViewController.h
//  AllDemo
//
//  Created by 美娜栾 on 2017/8/19.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDKResultTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *resultArray;

@property (nonatomic, copy) dispatch_block_t canSendMapDataBlock;

@property (nonatomic, copy) dispatch_block_t cancelBlock;

@end
