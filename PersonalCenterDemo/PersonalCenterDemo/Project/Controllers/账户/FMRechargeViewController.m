//
//  FMRechargeViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/13.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "FMRechargeViewController.h"
#import "FMRechargeCell.h"
#import "SDKAboutText.h"

@interface FMRechargeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIView *customHeader;
@property (nonatomic, strong) SDKCustomLabel *coinCountLab;
@property (nonatomic, strong) SDKCustomUnderlineButton *minuteIDBtn;

@property (nonatomic, strong) SDKCustomLabel *bottomLab;

@end

static NSString *const cellID = @"FMRechargeCellID";

@implementation FMRechargeViewController

- (UIView *)customHeader {
    if (!_customHeader) {
        _customHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(130))];
        _customHeader.backgroundColor = [UIColor whiteColor];
     
        _coinCountLab = [SDKCustomLabel setLabelTitle:@"0" setLabelFrame:CGRectMake(0, adaptY(30), kScreenWidth, adaptY(42)) setLabelColor:UIColorFromRGB(0x333333) setLabelFont:kFont(30) setAlignment:1];
        [_customHeader addSubview:_coinCountLab];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@" 分钟币余额" attributes:@{NSFontAttributeName : kFont(13), NSForegroundColorAttributeName : UIColorFromRGB(0x666666)}];
        
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"live_gift_icon_coin"];
        attach.bounds = CGRectMake(0, 0, adaptX(15), adaptX(15));
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        [attr insertAttributedString:attachString atIndex:0];
        
        
        SDKCustomLabel *lab = [SDKCustomLabel setLabelAttrTitle:attr setLabelFrame:CGRectMake(0, CGRectGetMaxY(_coinCountLab.frame) + adaptY(10), kScreenWidth, adaptY(18.5)) setAlignment:1];
        [_customHeader addSubview:lab];
    }
    
    return _customHeader;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight - 64)-adaptY(20)) style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _mainTableView.dataSource      = self;
        _mainTableView.delegate  = self;
        _mainTableView.tableHeaderView = self.customHeader;
        _mainTableView.rowHeight = adaptY(57.5);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setupButton];
    
    NSString *str = @"或者复制分钟号ID，关注微信公众号“两三分钟”也可以进行充值";
    NSString *checkStr = @"“两三分钟”";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str attributes:
                                       @{NSFontAttributeName : kFont(11), NSForegroundColorAttributeName : [UIColor grayColor]}];
    [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFA5A5A) range:[str rangeOfString:checkStr]];
    
    _bottomLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(0, CGRectGetMaxY(self.mainTableView.frame), kScreenWidth, adaptY(20)) setLabelColor:commonWhiteColor setLabelFont:kFont(10) setAlignment:1];
    _bottomLab.attributedText = attr;
    [self.view addSubview:_bottomLab];

}

- (void)setupButton {
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(0, 0, 100, 20);
    [detailBtn setTitle:@"充值明细" forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(rechargeDetailAction) forControlEvents:UIControlEventTouchUpInside];
    detailBtn.titleLabel.font = kFont(15);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailBtn];
}

// 查看充值明细
- (void)rechargeDetailAction {

}

- (void)minteIDAction {
    
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMRechargeCell *cell = [FMRechargeCell cellWithTableView:tableView identifier:cellID];

    cell.priceEvent = ^ () {
        
    };
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return adaptY(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return adaptY(80);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(50))];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, adaptY(10), kScreenWidth, header.height-adaptY(10))];
    container.backgroundColor = commonWhiteColor;
    [header addSubview:container];
    
    SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:@"选择充值金额" setLabelFrame:CGRectMake(kDefaultPadding, 0, kScreenWidth-2*kDefaultPadding, container.height) setLabelColor:UIColorFromRGB(0x666666) setLabelFont:kFont(13.5)];
    [container addSubview:lab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, container.height-1, kScreenWidth, 1)];
    line.backgroundColor = cuttingLineColor;
    [container addSubview:line];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(80))];
    
    SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:@"分钟号ID:" setLabelFrame:CGRectMake((kScreenWidth - adaptX(107))*0.5, adaptY(15), 0, adaptY(15)) setLabelColor:[UIColor grayColor] setLabelFont:kFont(11)];
    lab.width = [SDKAboutText calcaulateTextWidth:lab.text height:lab.height font:lab.font] + adaptX(5);
    [footer addSubview:lab];
    
    _minuteIDBtn = [SDKCustomUnderlineButton underlinebuttonWithTitle:@"" font:kFont(11) titleColor:UIColorFromRGB(0xFA5A5A) addTaget:self action:@selector(minteIDAction)];
    _minuteIDBtn.frame = CGRectMake(CGRectGetMaxX(lab.frame), adaptY(15), adaptX(200), adaptY(15));
    [footer addSubview:_minuteIDBtn];
    
    
    NSString *title = @"12312312";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSFontAttributeName value:kFont(11) range:NSMakeRange(0, title.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFA5A5A) range:NSMakeRange(0, title.length)];
    [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, title.length)];
    _minuteIDBtn.titleLabel.textAlignment = 0;
    [_minuteIDBtn setAttributedTitle:attrString forState:UIControlStateNormal];
    _minuteIDBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    return footer;
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    CGFloat sub = scrollView.contentSize.height- self.mainTableView.height;
    if (offsetY >= sub) {
        _bottomLab.y = CGRectGetMaxY(self.mainTableView.frame) - (offsetY-sub);
    }
}

@end
