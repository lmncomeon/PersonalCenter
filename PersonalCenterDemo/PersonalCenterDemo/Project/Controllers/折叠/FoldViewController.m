//
//  FoldViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/5.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FoldViewController.h"
#import "MNFoldView.h"
#import "FoldModel.h"

@interface FoldViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray <MNFoldView *> *cellsArray;

@end

@implementation FoldViewController

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _mainScrollView.alwaysBounceVertical=true;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mainScrollView];
 
   
    FoldModel *model1 = [FoldModel modelWithTitle:@"娜娜的世界哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈" content:@"捏哦热闹捏哦热闹捏哦热闹捏哦热闹捏哦热闹捏哦热闹捏哦热闹"];
    FoldModel *model2 = [FoldModel modelWithTitle:@"娜娜的世界哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈" content:@"捏哦热闹捏哦热闹捏哦热闹捏哦热闹捏哦热闹捏哦热闹捏哦热闹"];
    FoldModel *model3 = [FoldModel modelWithTitle:@"娜娜的世界哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈" content:@"捏哦热闹捏哦热闹捏哦热闹捏哦热闹捏哦热闹捏哦热闹捏哦热闹"];
    FoldModel *model4 = [FoldModel modelWithTitle:@"娜娜的世界哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈" content:@"捏哦热闹捏哦热闹捏哦热闹捏哦热闹捏哦热闹捏哦热闹捏哦热闹"];
    
    NSArray *tmp = @[model1, model2, model3, model4];
    
    CGFloat cellY = 100;
    for (int i = 0; i < tmp.count; i++) {
        MNFoldView *cellView = [[MNFoldView alloc] initWithFrame:CGRectMake(0, cellY, kScreenWidth, 0) model:tmp[i] spread:false];
        cellView.backgroundColor = krandomColor;
        [self.mainScrollView addSubview:cellView];
        [self.cellsArray addObject:cellView];
        
        HXWeak_self
        cellView.updateHeight = ^{
            HXStrong_self
            
            [self closeOtherCell:i];
            
            [self updateUIHeight];
        };
        
        cellY += cellView.height;
    }
    
}

- (void)updateUIHeight {
   __block  CGFloat cellY = 100;
    [UIView animateWithDuration:0.5 animations:^{
    for (MNFoldView *cell in self.cellsArray) {
        
            cell.y = cellY;
        
        
        cellY += cell.height;
    }
    
    self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.mainScrollView.subviews.lastObject.frame));
        
        }];
}

- (void)closeOtherCell:(int)index {
    
    for (int i = 0; i < self.cellsArray.count; i++) {
        if (i == index) continue;
        
        self.cellsArray[i].spread = false;
    }
}

- (NSMutableArray <MNFoldView *> *)cellsArray {
    if (!_cellsArray) {
        _cellsArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _cellsArray;
}

@end
