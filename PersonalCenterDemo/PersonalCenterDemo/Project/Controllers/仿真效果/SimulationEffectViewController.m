//
//  SimulationEffectViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/7/5.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SimulationEffectViewController.h"
#import "WLBallView.h"
#import "WLBallTool.h"

@interface SimulationEffectViewController ()

@property (nonatomic, strong) NSArray * array;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) UIView *purpleView;

@end

@implementation SimulationEffectViewController

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [UIDynamicAnimator new];
    }
    return _animator;
}

- (UIView *)purpleView {
    if (!_purpleView) {
        _purpleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, adaptX(100), adaptX(100))];
        _purpleView.backgroundColor = [UIColor purpleColor];
        _purpleView.layer.masksToBounds = true;
        _purpleView.layer.cornerRadius = adaptX(50);
        _purpleView.center = self.view.center;
        [self.view addSubview:_purpleView];
    }
    return _purpleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ballsCollision];
    
    [self purpleView];
}

- (void)ballsCollision {
    self.array = @[@"大师球",@"高级球",@"超级球",@"精灵球"];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(100))];
    [self.view addSubview:container];
    
    for (int i = 0; i < 8; i++) {
        int row = i / 4;
        int col = i % 4;
        WLBallView * ballView = [[WLBallView alloc] initWithFrame:CGRectMake(col*50, row*50, 50, 50) AndImageName:self.array[arc4random_uniform(4)]];
        [container addSubview:ballView];
        [ballView starMotion];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    [self showAttach:touch];
//    [self showSnap:touch];
    
    
}

- (void)showAttach:(UITouch *)touch {
    CGPoint po = [touch locationInView:touch.view];
    
    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc]initWithItem:self.purpleView offsetFromCenter:UIOffsetMake(10, 10) attachedToAnchor:po];
    attachment.length = 10;
    attachment.damping = 0.1;
    attachment.frequency = 6;
    
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:attachment];
}

- (void)showSnap:(UITouch *)touch {
    
    CGPoint point = [touch locationInView:self.view];
    UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:self.purpleView snapToPoint:point];
    snap.damping = 0.5;
    
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:snap];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[WLBallTool shareBallTool] stopMotionUpdates];
    
}
@end
