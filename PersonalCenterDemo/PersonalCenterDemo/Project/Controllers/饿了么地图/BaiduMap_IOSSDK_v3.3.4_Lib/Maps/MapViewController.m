//
//  MapViewController.m
//  AllDemo
//
//  Created by 美娜栾 on 2017/8/19.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "MapViewController.h"
#import "SDKCustomLabel.h"
#import "NearbyListCell.h"
#import "SDKPoiModel.h"
#import "SDKAboutString.h"
#import "SDKCityListViewController.h"
#import "SDKSearchViewController.h"

@interface MapViewController () <UITextFieldDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, UITableViewDataSource, UITableViewDelegate, BMKPoiSearchDelegate, BMKGeoCodeSearchDelegate>
{
    CLGeocoder   *_geocoder;
    
    BMKPoiSearch *_searcher;
    BMKNearbySearchOption *_option;
    int curPage;
    
    // 编码&反编码
    BMKGeoCodeSearch        *_codeSearch;
    BMKGeoCodeSearchOption  *_geoCodeSearchOption;
    BMKReverseGeoCodeOption *_reverseGeoCodeSearchOption;
    
}
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) SDKCustomLabel *locationLab;
@property (nonatomic, copy) NSString *userCurrentString;
@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UITextField *searchView;


@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKUserLocation *userLocation;

@property (nonatomic, strong) UIImageView *centerMark;


@property (nonatomic, strong) UITableView *mainTableView;


//@property (nonatomic, assign) BOOL isClickSearch;

@property (nonatomic, strong) NSMutableArray *dataList;


// 反编码 & 编码
@property (nonatomic, copy) void (^geoReverseBlock)(BMKAddressComponent *component);
@property (nonatomic, copy) void (^geoCodeBlock)(CLLocationCoordinate2D mn_coordinate);


@property (nonatomic, strong) SDKCityListViewController *cityListVC;
@property (nonatomic, assign) BOOL showListView;
@property (nonatomic, strong) NSMutableArray *citysArray;
@property (nonatomic, strong) NSMutableArray *indexArray;


@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;

@property (nonatomic, assign) CLLocationCoordinate2D mapCenterCoordinate;

@end

static NSString *const NearbyListCellID = @"NearbyListCell";

static NSString *defaultKeyWord = @"楼盘";
static int mapPageCapacity = 10;
static int searchRadius    = 5000;

@implementation MapViewController

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(40))];
        [self.view addSubview:_topView];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(adaptX(16), (_topView.height - adaptY(11))*0.5, adaptX(9), adaptY(11))]; // 1.5X
        icon.image = [UIImage imageNamed:@"map_location_icon"];
        [_topView addSubview:icon];
        
        _locationLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(CGRectGetMaxX(icon.frame)+ adaptX(5), 0, adaptX(80), _topView.height) setLabelColor:titleTextColor setLabelFont:kFont(12)];
        [_topView addSubview:_locationLab];
        
        _arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_locationLab.frame) + adaptX(5), (_topView.height - adaptY(5.25)) *0.5, adaptX(9), adaptY(5.25))]; // 1.5X
        _arrowImg.image = [UIImage imageNamed:@"map_bottom_arrow_bottom"];
        [_topView addSubview:_arrowImg];
        
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearBtn.frame = CGRectMake(0, 0, CGRectGetMaxX(_arrowImg.frame), _topView.height);
        [_clearBtn addTarget:self action:@selector(handleListAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_clearBtn];
        
        _searchView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_clearBtn.frame) + adaptX(5), adaptY(7), kScreenWidth- CGRectGetMaxX(_clearBtn.frame)-adaptX(16)-adaptX(5), _topView.height-adaptY(14))];
        _searchView.font = kFont(12);
        
        NSAttributedString *placeAttr = [[NSAttributedString alloc] initWithString:@"查找小区/大厦等" attributes:@{NSFontAttributeName : kFont(12), NSForegroundColorAttributeName : [UIColor colorWithRed:176/255.0f green:176/255.0f blue:179/255.0f alpha:1.0f]}];
        _searchView.attributedPlaceholder = placeAttr;
        _searchView.delegate = self;
        _searchView.layer.masksToBounds = true;
        _searchView.layer.cornerRadius = _searchView.height*0.5;
        
        _searchView.leftView = ({
            
            UIButton *glass = [UIButton buttonWithType:UIButtonTypeCustom];
            glass.frame = CGRectMake(0, 0, _searchView.height, _searchView.height);
            [glass setImage:[UIImage imageNamed:@"map_find"] forState:UIControlStateNormal];
            
            glass;
        });
        _searchView.leftViewMode = UITextFieldViewModeAlways;
        _searchView.backgroundColor = [UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1.0f];
        [_topView addSubview:_searchView];
        
    }
    return _topView;
}

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth, adaptY(200))];
        [_mapView setMapType:BMKMapTypeStandard];
        [_mapView setZoomLevel:17];
        _mapView.minZoomLevel = 8;  // 10
        _mapView.maxZoomLevel = 19; // 19
        _mapView.showMapScaleBar = true;
        _mapView.mapScaleBarPosition = CGPointMake(adaptX(10), adaptY(160));
        _mapView.ChangeWithTouchPointCenterEnabled = true;
        [self.view addSubview:_mapView];
        
        CGFloat btnWH = adaptX(39);
        UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        locationBtn.frame = CGRectMake(0, _mapView.height - btnWH-adaptX(33), btnWH, btnWH);
        [locationBtn setImage:[UIImage imageNamed:@"locationBtn"] forState:UIControlStateNormal];
        [locationBtn addTarget:self action:@selector(loactionAction) forControlEvents:UIControlEventTouchUpInside];
        [_mapView addSubview:locationBtn];
    }
    return _mapView;
}

- (UIImageView *)centerMark {
    if (!_centerMark) {
        _centerMark = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, adaptX(18.5), adaptY(24.5))];
        _centerMark.image = [UIImage imageNamed:@"center_red"];
        _centerMark.center = CGPointMake(_mapView.centerX, _mapView.height*0.5);
        [self.mapView addSubview:_centerMark];
    }
    return _centerMark;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mapView.frame), kScreenWidth, kScreenHeight-CGRectGetMaxY(self.mapView.frame) -64) style:UITableViewStyleGrouped];
        _mainTableView.separatorColor = cuttingLineColor;
        _mainTableView.dataSource = self;
        _mainTableView.delegate   = self;
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavWithTitle:@"请选择您的地址"];
    
    self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(backAction) target:self];

    
    [self mainTableView];
    [self centerMark];
    
    [self configLocation];
    
    [self initPoiSearch];
    
    [self initGeocoder];
    
    [self initCodeSearch];


//    _isClickSearch = NO;
    curPage = 0;
    _showListView = false;
    
    [self handleCitysArray];
    
    // 获取城市列表
    [self loadCityListData];
    
    HXWeak_self
    [self.mainTableView setFooter:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        HXStrong_self
        
        curPage++;
        
        [self startNearbySearchWithLocation:self.mapCenterCoordinate option:_option keyword:defaultKeyWord];
        
    }]];
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    
    _locService.delegate = self;
    
    _searcher.delegate = self;
    
    _codeSearch.delegate = self;
    
//    [_locService startUserLocationService];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    
    _locService.delegate = nil;
    
    _searcher.delegate = nil;
    
    _codeSearch.delegate = nil;
}

- (void)configLocation {
    _locService = [[BMKLocationService alloc]init];
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locService.distanceFilter = 10;
    
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

- (void)initPoiSearch {
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    
    _option = [[BMKNearbySearchOption alloc]init];
    _option.pageCapacity = mapPageCapacity;
    _option.radius       = searchRadius;
    _option.sortType = 1; // 搜索结果排序
}

- (void)initGeocoder {
    _geocoder = [[CLGeocoder alloc] init];
}

- (void)initCodeSearch {
    
    _codeSearch = [[BMKGeoCodeSearch alloc]init];
    
    _geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    
    _reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];

}

// 处理城市列表
- (void)handleListAction {
    if (self.citysArray.count == 0) {
        showTip(@"城市列表无数据");
        return;
    }
    
    if (!self.userCurrentString) {
        return;
    }
    
    //[self startRotaionWithTarget:_arrowImg angle:M_PI];
    
    
    // show or hide
    _showListView = !_showListView;
    
    _arrowImg.image = [UIImage imageNamed:(_showListView ? @"map_bottom_arrow_up" : @"map_bottom_arrow_bottom")];
    
    if (_showListView) {
        // add
        _cityListVC.view.frame = CGRectMake(0, adaptY(40), kScreenWidth, kScreenHeight-64-adaptY(40));
        _cityListVC.mainTableView.frame = _cityListVC.view.bounds;
        
        // send data
        _cityListVC.list          = self.citysArray.copy;
        _cityListVC.indexArray    = self.indexArray.copy;
        _cityListVC.currentString = self.userCurrentString;
        [self.view addSubview:_cityListVC.view];
        
        
        HXWeak_self
        _cityListVC.sendValue = ^(NSString *str) {

            HXStrong_self
            self.showListView = false;
//            [self startRotaionWithTarget:_arrowImg angle:M_PI];
            
            self.arrowImg.image = [UIImage imageNamed:@"map_bottom_arrow_bottom"];
            
            [self.cityListVC.view removeFromSuperview];
            
            // 赋值
            [self topSettingValueAndUpdate:str];
            
            // refresh
            [self geocodeAddress:str resultUsingBlock:^(CLPlacemark *placemark) {
                HXStrong_self
                
                self.mapView.centerCoordinate = placemark.location.coordinate;
                
                // 记录
                self.currentCoordinate = placemark.location.coordinate;
                
            }];
            
        };
        
    } else {
        // remove
        [_cityListVC.view removeFromSuperview];
    }
    
}

// 点击定位按钮
- (void)loactionAction {
    _mapView.centerCoordinate = _userLocation.location.coordinate;
    
//    HXWeak_self
//    [self reverseGeocodeLocation:_userLocation.location resultUsingBlock:^(CLPlacemark *placemark) {
//        HXStrong_self
//        
//        self.locationLab.text = placemark.locality ? : @"失败";
//    }];
    
    
    HXWeak_self
    [self BMKGeoReverseLocation:_userLocation.location resultUsingBlock:^(BMKAddressComponent *component) {
        
        HXStrong_self
        self.locationLab.text = component.city ? : @"失败";
    }];

}

#pragma mark - textFiled Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField endEditing:true];
    
    
    [self BMKGeoReverseLocation:[[CLLocation alloc] initWithLatitude:self.currentCoordinate.latitude longitude:self.currentCoordinate.longitude] resultUsingBlock:^(BMKAddressComponent *component) {
         
        // jump
        SDKSearchViewController *sdkSearck = [SDKSearchViewController new];
        sdkSearck.searchLocation = self.currentCoordinate;
        sdkSearck.citySting = component.city;
        [self.navigationController pushViewController:sdkSearck animated:false];
        
    }];
    
    
}

#pragma mark - tableView dataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearbyListCell *cell = [NearbyListCell cellWithTableView:tableView identifier:NearbyListCellID];
    
    cell.model = self.dataList[indexPath.section];
    
    if (indexPath.section == 0) {
        [cell settingTextColor:kOrangeColor];
    } else {
        [cell settingTextColor:commonBlackColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NearbyListCell listCellHeightWith:self.dataList[indexPath.section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SDKPoiModel *poiM = self.dataList[indexPath.section];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:poiM.coordinate2D.latitude longitude:poiM.coordinate2D.longitude];
    
    __weak typeof(self) weakSelf = self;
    
//    [self reverseGeocodeLocation:location resultUsingBlock:^(CLPlacemark *placemark) {
//        
//        NSString *provinces = [NSString stringWithFormat:@"%@ %@ %@", placemark.administrativeArea ? : @"", placemark.locality ? : @"", placemark.subLocality ? : @""];
//
//        !weakSelf.mapValueBlock ? : weakSelf.mapValueBlock(provinces, poiM.address);
//        
//        [weakSelf.navigationController popViewControllerAnimated:true];
//    }];

    
    [self BMKGeoReverseLocation:location resultUsingBlock:^(BMKAddressComponent *component) {
        
        NSString *provinces = [NSString stringWithFormat:@"%@ %@ %@", component.province ? : @"", component.city ?: @"", component.district ?: @""];
        
        !weakSelf.mapValueBlock ? : weakSelf.mapValueBlock(provinces, poiM.address);
        
        [weakSelf.navigationController popViewControllerAnimated:true];
    }];
}

#pragma mark - 定位相关代理
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    // 记录
    _userLocation = userLocation;
    
    self.currentCoordinate = userLocation.location.coordinate;
    self.mapCenterCoordinate = userLocation.location.coordinate;
    
    
    [_mapView updateLocationData:userLocation];
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

    // 记录
    _userLocation = userLocation;
    
    self.currentCoordinate = userLocation.location.coordinate;
    self.mapCenterCoordinate = userLocation.location.coordinate;
    
    
    // 赋值
    HXWeak_self
    [self BMKGeoReverseLocation:userLocation.location resultUsingBlock:^(BMKAddressComponent *component) {
        HXStrong_self
        if (!component) return;
        
        
        [self topSettingValueAndUpdate:component.city];
        
        // 记录
        self.userCurrentString = component.city;
        
    }];
    
    // 开始检索
    [self startNearbySearchWithLocation:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude) option:_option keyword:defaultKeyWord];
    
    
    //更新地图上的位置
    [_mapView updateLocationData:userLocation];
    
    //更新地图中间
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    // 找到了当前位置城市后就关闭服务
    [self.locService stopUserLocationService];
}

- (void)topSettingValueAndUpdate:(NSString *)city {
    // 赋值
    self.locationLab.text = city;
    
    // Update Top Frame
    CGFloat locationLabW = [SDKAboutText calcaulateTextWidth:city height:self.locationLab.height font:kFont(14)];
    locationLabW = ((locationLabW >= adaptX(80)) ? adaptX(80) : locationLabW);
    self.locationLab.width = locationLabW;
    
    self.arrowImg.x = CGRectGetMaxX(self.locationLab.frame) + adaptX(5);
    
    self.clearBtn.width = CGRectGetMaxX(self.arrowImg.frame);
    CGFloat searchViewX = CGRectGetMaxX(self.clearBtn.frame) + adaptX(5);
    self.searchView.x   = searchViewX;
    self.searchView.width = kScreenWidth - searchViewX - kDefaultPadding;

}

- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

#pragma mark - MapDelegate
- (void)mapStatusDidChanged:(BMKMapView *)mapView
{
    [_mapView updateLocationData:_userLocation];
    
    // 重置
    curPage = 0;
    self.mapCenterCoordinate = mapView.centerCoordinate;
    
    // 开始检索
    [self startNearbySearchWithLocation:CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude) option:_option keyword:defaultKeyWord];
    
    NSLog(@"mapStatusDidChanged");
}

#pragma mark - 周边检索
- (void)startNearbySearchWithLocation:(CLLocationCoordinate2D)location option:(BMKNearbySearchOption *)option keyword:(NSString *)keyword {

    option.location  = location;
    option.pageIndex = curPage;
    option.keyword   = keyword;
    
    BOOL flag = [_searcher poiSearchNearBy:option];
    
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    [_mapView updateLocationData:_userLocation];
    
    
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR)
    {
        
        
        NSLog(@"地址--> %@",result.poiAddressInfoList);
        
//        if (_isClickSearch == YES)
//        { // 开始点击搜索
//            
//        }
//        else
//        {// 没有点击搜索
        
        if (curPage == 0) {
            [self.dataList removeAllObjects];
        }

        for (BMKPoiInfo *info in result.poiInfoList) {
            
            NSLog(@"_name = %@, _address = %@, _city = %@",info.name,info.address,info.city);
            
            NSLog(@"lon:%.2f la:%.2f", info.pt.longitude, info.pt.latitude);
            
            SDKPoiModel *poiM = [SDKPoiModel new];
            poiM.name = info.name;
            poiM.address = info.address;
            poiM.city = info.city;
            poiM.coordinate2D = info.pt;
            
            [self.dataList addObject:poiM];
            
        }
        
        
//        }
        
        
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        DLog(@"起始点有歧义");
        
        if (curPage == 0) {
            [self.dataList removeAllObjects];
        }
        
    }
    else if (error == BMK_SEARCH_RESULT_NOT_FOUND) {
        DLog(@"没找到");
        
        if (curPage == 0) {
            [self.dataList removeAllObjects];
        }
        
    }
    else {
        DLog(@"各种情况的判断");
        
        if (curPage == 0) {
            [self.dataList removeAllObjects];
        }
    }
    
    [self.mainTableView.footer endRefreshing];
    [self.mainTableView reloadData];
}

#pragma mark searchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    _isClickSearch = YES;
    
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
//    _isClickSearch = NO;
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    _isClickSearch = NO;

}

//#pragma mark - searchControllerDelegate
//- (void)willDismissSearchController:(UISearchController *)searchController {
//    _isClickSearch = NO;
//}
//
//- (void)didDismissSearchController:(UISearchController *)searchController {
//    _isClickSearch = NO;
//}

#pragma mark - geo反编码
- (void)BMKGeoReverseLocation:(CLLocation *)location resultUsingBlock:(void(^)(BMKAddressComponent *component))result {
    // 记录
    self.geoReverseBlock = result;
    
    //
    CLLocationCoordinate2D pt = location.coordinate;
    _reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    
    BOOL flag = [_codeSearch reverseGeoCode:_reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

// 接收反向地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {

    /*
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = result.location;
    annotation.title = @"当前位置";
    annotation.subtitle = result.address;
    [_mapView addAnnotation:annotation];
    
    //使地图显示该位置
    [_mapView setCenterCoordinate:result.location animated:YES];
    */
    
  if (error == BMK_SEARCH_NO_ERROR)
  {
      if (self.geoReverseBlock) {
          self.geoReverseBlock(result.addressDetail);
      }

  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
    
}

#pragma mark geo正编码
- (void)BMKGeoCodeWithCity:(NSString *)city resultUsingBlock:(void(^)(CLLocationCoordinate2D mn_coordinate))result {

    // 记录
    self.geoCodeBlock = result;
    
    
    //
    _geoCodeSearchOption.city = city;
    
    BOOL flag = [_codeSearch geoCode:_geoCodeSearchOption];
    
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

//接收正向编码结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        if (self.geoCodeBlock) {
            self.geoCodeBlock(result.location);
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - 系统 编码&反编码
// 反编码
- (void)reverseGeocodeLocation:(CLLocation *)location resultUsingBlock:(void (^)(CLPlacemark *placemark))result {
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error) {
        
        CLPlacemark *placemark;
        
        if (array.count > 0) { placemark = [array objectAtIndex:0]; }
        
        if (result) {  result(placemark);  }
        
    }];
    
    
}

// 编码
- (void)geocodeAddress:(NSString *)address resultUsingBlock:(void(^)(CLPlacemark *placemark))result {
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark;
        
        if (placemarks.count > 0) { placemark = [placemarks objectAtIndex:0]; }
        
        if (result) {  result(placemark);  }
    }];
}

//更新搜索结果时会调用的方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

#pragma mark - 获取城市列表
- (void)loadCityListData {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityList" ofType:@"json"]];
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *dataList = dic[@"data"];

    if (error || dataList.count == 0 || !dataList) return;
    
    // 1.快速分类
    for (NSString *str in dataList) {
        // 获取首字母
        NSString *pinyi = [SDKAboutString transformMandarinToLatin:str];
        NSString *firstLetter = [[pinyi uppercaseString] substringToIndex:1];
        
        // 筛选分类
        for (NSMutableDictionary *dic in self.citysArray) {
            if ([firstLetter isEqualToString:[[dic allKeys] firstObject]]) {
                [[[dic allValues] firstObject] addObject:str];
                
                break;
            }
        }
        
    }
    
    
    // 2.删除无用数据
    for (int i = 0; i < self.citysArray.count; i++) {
        NSDictionary *obj = self.citysArray[i];
        
        NSMutableArray *arr = [[obj allValues] firstObject];
        
        if (!arr.count) {
            [self.citysArray removeObject:obj];
            i--;
        }
    }
    
    // 3.创建索引数据
    for (NSMutableDictionary *dic in self.citysArray) {
        NSString *key = [[dic allKeys] firstObject];
        
        [self.indexArray addObject:key];
    }
    
}

#pragma mark - other method
- (void)handleCitysArray {
    [self.citysArray removeAllObjects];
    
    for (char myChar = 'A'; myChar <= 'Z'; myChar++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:5];
        
        NSString *alpha = [NSString stringWithFormat:@"%c", myChar];
        dic[alpha] = [NSMutableArray arrayWithCapacity:5];
        
        [self.citysArray addObject:dic];
    }
    
    _cityListVC = [SDKCityListViewController new];
    [self addChildViewController:_cityListVC];
}

- (void)startRotaionWithTarget:(UIView *)target angle:(CGFloat)angle {
    
    CGAffineTransform transform = CGAffineTransformRotate(target.transform, angle);
    
    [UIView beginAnimations:@"rotate" context:nil ];
    [UIView setAnimationDuration:0.5];
    [target setTransform:transform];
    [UIView commitAnimations];
}

#pragma mark - back
- (void)backAction {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark -  lazy load
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithCapacity:5];
    }
    return _dataList;
}

- (NSMutableArray *)citysArray {
    if (!_citysArray) {
        _citysArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _citysArray;
}

- (NSMutableArray *)indexArray {
    if (!_indexArray) {
        _indexArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _indexArray;
}

@end
