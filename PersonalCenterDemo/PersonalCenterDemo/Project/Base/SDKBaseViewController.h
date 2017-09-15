//
//  SDKBaseViewController.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKProjectHeader.h"
#import "SDKCommonService.h"
#import "NSArray+Log.h"
#import "Header.h"

#import "SDKnetwork.h"
#import "SDKNetworkState.h"
#import "SDKNavigationController.h"

// tool
#import "SDKJWTextField.h"
#import "SDKCustomLabel.h"
#import "SDKAboutText.h"
#import "SDKCustomRoundedButton.h"
#import "SDKLineView.h"
#import "UIView+CustomView.h"
#import "UIImage+ColorImage.h"
#import "SDKFormatJudge.h"
#import "SDKJWAlertView.h"
#import "SDKCommonTools.h"


// 三方
#import "UIViewController+KeyboardCorver.h"
#import "MBProgressHUD.h"
#import "customHUD.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "Masonry.h"


// ****************** 百度地图 *********************
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件


typedef NS_ENUM(NSInteger, BaseBtnTypeStyle) {
    BaseBtnRightType,
    BaseBtnLeftType
};

@interface SDKBaseViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) customHUD *hud;

#pragma mark  - 失败处理
- (void)errorDispose:(NSInteger)errorCode judgeMent:(NSString *)judgement;
#pragma mark  - 无网络的统一处理
- (void)errorRemind:(NSString *)judgement;

- (void)createTitleBarButtonItemStyle:(BaseBtnTypeStyle)btnStyle title:(NSString *)title TapEvent:(void(^)(void))event;

- (void)createImageBarButtonItemStyle:(BaseBtnTypeStyle)btnStyle Image:(NSString *)image TapEvent:(void(^)(void))event;

- (void)setupNavWithTitle:(NSString *)title;

- (UIBarButtonItem *)createBackButton:(SEL)action target:(id)target;


// 字典转json
- (NSString*)dictionaryToJson:(NSDictionary *)dic;





@end













