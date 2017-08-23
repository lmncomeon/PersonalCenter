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

@interface MapViewController () <UITextFieldDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, UITableViewDataSource, UITableViewDelegate, BMKPoiSearchDelegate>
{
    CLGeocoder   *_geocoder;
    
    BMKPoiSearch *_searcher;
    BMKNearbySearchOption *_option;
    int curPage;
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


@property (nonatomic, strong) SDKCityListViewController *cityListVC;
@property (nonatomic, assign) BOOL showListView;
@property (nonatomic, strong) NSMutableArray *citysArray;
@property (nonatomic, strong) NSMutableArray *indexArray;

@end

static NSString *const NearbyListCellID = @"NearbyListCell";

static NSString *defaultKeyWord = @"大厦";
static int mapPageCapacity = 50;
static int searchRadius    = 1000;

@implementation MapViewController

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(40))];
        [self.view addSubview:_topView];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(adaptX(16), (_topView.height - adaptY(16.5))*0.5, adaptX(13.5), adaptY(16.5))]; // 1.5X
        icon.image = [UIImage imageNamed:@"map_location_icon"];
        [_topView addSubview:icon];
        
        _locationLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(CGRectGetMaxX(icon.frame)+ adaptX(5), 0, adaptX(80), _topView.height) setLabelColor:[UIColor blackColor] setLabelFont:kFont(14)];
        _locationLab.adjustsFontSizeToFitWidth = true;
        [_topView addSubview:_locationLab];
        
        _arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_locationLab.frame), (_topView.height - adaptY(5.25)) *0.5, adaptX(9), adaptY(5.25))]; // 1.5X
        _arrowImg.image = [UIImage imageNamed:@"map_bottom_arrow"];
        [_topView addSubview:_arrowImg];
        
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearBtn.frame = CGRectMake(0, 0, CGRectGetMaxX(_arrowImg.frame), _topView.height);
        [_clearBtn addTarget:self action:@selector(handleListAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_clearBtn];
        
        _searchView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_clearBtn.frame), adaptY(7), kScreenWidth- CGRectGetMaxX(_clearBtn.frame)-adaptX(16), _topView.height-adaptY(14))];
        _searchView.placeholder = @"查找小区/大厦等";
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
        _searchView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_topView addSubview:_searchView];
        
    }
    return _topView;
}

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth, adaptY(200))];
        [_mapView setMapType:BMKMapTypeStandard];
        [_mapView setZoomLevel:17];
        _mapView.minZoomLevel = 10;
        _mapView.maxZoomLevel = 19;
        [self.view addSubview:_mapView];
        
        CGFloat btnWH = adaptX(52);
        UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        locationBtn.frame = CGRectMake(adaptX(5), _mapView.height - btnWH-adaptX(20), btnWH, btnWH);
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
        _mainTableView.dataSource = self;
        _mainTableView.delegate   = self;
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavWithTitle:@"请选择您的地址"];
    
    self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(backAction)];

    
    [self mainTableView];
    [self centerMark];
    
    [self configLocation];
    
    [self initPoiSearch];
    
    [self initGeocoder];


//    _isClickSearch = NO;
    curPage = 0;
    _showListView = false;
    
    [self handleCitysArray];
    
    // 获取城市列表
    [self requestCityListData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    
    _locService.delegate = self;
    
    _searcher.delegate = self;
    
//    [_locService startUserLocationService];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    
    _locService.delegate = nil;
    
    _searcher.delegate = nil;
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
    _option.pageIndex    = curPage;
    _option.pageCapacity = mapPageCapacity;
    _option.radius       = searchRadius;
    _option.sortType = 1; // 搜索结果排序
}

- (void)initGeocoder {
    _geocoder = [[CLGeocoder alloc] init];
}

// 处理城市列表
- (void)handleListAction {
    [self startRotaionWithTarget:_arrowImg angle:M_PI];
    
    // show or hide
    _showListView = !_showListView;
    
    if (_showListView) {
        // add
        _cityListVC.view.frame = CGRectMake(0, adaptY(40), kScreenWidth, kScreenHeight-64-adaptY(40));
        _cityListVC.mainTableView.frame = _cityListVC.view.bounds;
        [self.view addSubview:_cityListVC.view];
        
        // send data
        _cityListVC.list          = self.citysArray.copy;
        _cityListVC.indexArray    = self.indexArray.copy;
        _cityListVC.currentString = self.userCurrentString;
        
        HXWeak_self
        _cityListVC.sendValue = ^(NSString *str) {
            DLog(@"== 收到 %@", str);
            
            HXStrong_self
            self.showListView = false;
            [self startRotaionWithTarget:self.arrowImg angle:M_PI];
            [self.cityListVC.view removeFromSuperview];
            
            // 赋值
            [self topSettingValueAndUpdate:str];
            
            // refresh
            [self geocodeAddress:str resultUsingBlock:^(CLPlacemark *placemark) {
                HXStrong_self
                
                self.mapView.centerCoordinate = placemark.location.coordinate;
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
    
    HXWeak_self
    [self reverseGeocodeLocation:_userLocation.location resultUsingBlock:^(CLPlacemark *placemark) {
        HXStrong_self
        
        self.locationLab.text = placemark.locality ? : @"失败";
    }];

}

#pragma mark - textFiled Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField endEditing:true];
    
    SDKSearchViewController *sdkSearck = [SDKSearchViewController new];
    sdkSearck.userLocation = _userLocation;
    [self.navigationController pushViewController:sdkSearck animated:false];
}

#pragma mark - tableView dataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearbyListCell *cell = [NearbyListCell cellWithTableView:tableView identifier:NearbyListCellID];
    
    cell.model = self.dataList[indexPath.row];
    
    if (indexPath.row == 0) {
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
    return [NearbyListCell listCellHeightWith:self.dataList[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SDKPoiModel *poiM = self.dataList[indexPath.row];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:poiM.coordinate2D.latitude longitude:poiM.coordinate2D.longitude];
    
    __weak typeof(self) weakSelf = self;
    
    [self reverseGeocodeLocation:location resultUsingBlock:^(CLPlacemark *placemark) {
        
        NSString *provinces = [NSString stringWithFormat:@"%@ %@ %@", placemark.administrativeArea ? : @"", placemark.locality ? : @"", placemark.subLocality ? : @""];

        !weakSelf.mapValueBlock ? : weakSelf.mapValueBlock(provinces, poiM.address);
        
        [weakSelf.navigationController popViewControllerAnimated:true];
    }];

}

#pragma mark - 定位相关代理
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    _userLocation = userLocation;
    [_mapView updateLocationData:userLocation];
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

    _userLocation = userLocation;

    // 开始检索
    [self startPoiSearchWithLocation:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude) option:_option keyword:defaultKeyWord];
    
    //更新地图上的位置
    [_mapView updateLocationData:userLocation];
    
    //更新当前位置到地图中间
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    
    // 赋值
    HXWeak_self
    [self reverseGeocodeLocation:userLocation.location resultUsingBlock:^(CLPlacemark *placemark) {
        HXStrong_self
        
        if (!placemark) return;
        
        NSString *city = placemark.locality;
        
        [self topSettingValueAndUpdate:city];
        
        // 记录
        self.userCurrentString = city;
        
        // 找到了当前位置城市后就关闭服务
        [self.locService stopUserLocationService];
    }];
   

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
    
    // 开始检索
    [self startPoiSearchWithLocation:CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude) option:_option keyword:defaultKeyWord];
    
    NSLog(@"mapStatusDidChanged");
}

#pragma mark - 周边检索
- (void)startPoiSearchWithLocation:(CLLocationCoordinate2D)location option:(BMKNearbySearchOption *)option keyword:(NSString *)keyword {

    option.location = location;
    
    option.keyword = keyword;
    
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
    
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        
        NSLog(@"地址--> %@",result.poiAddressInfoList);
        
//        if (_isClickSearch == YES)
//        { // 开始点击搜索
//            
//        }
//        else
//        {// 没有点击搜索
        
            [self.dataList removeAllObjects];
            
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
        [self.mainTableView reloadData];
            
//        }
        
        
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
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

#pragma mark - BMKGeoCodeSearch 代理方法
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = result.location;
    annotation.title = @"当前位置";
    annotation.subtitle = result.address;
    [_mapView addAnnotation:annotation];
    //使地图显示该位置
    [_mapView setCenterCoordinate:result.location animated:YES];
}


//更新搜索结果时会调用的方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

#pragma mark - 获取城市列表
- (void)requestCityListData {
    [SDKNetworkState WithSuccessBlock:^(BOOL status) {
        if (status == true)
        {
            self.hud = [customHUD new];
            [self.hud showCustomHUDWithView:self.view];
            
            [SDKCommonService getCityListWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self.hud hideCustomHUD];
                
                NSArray *dataList = responseObject;
                
                if (dataList && dataList.count)
                {
                    
                    // 1.快速分类
                    for (NSString *str in dataList) {
                        // 获取首字母
                        NSString *pinyi = [SDKAboutString transform:str];
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
                else
                {
                    showTip(@"城市列表无数据")
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.hud hideCustomHUD];


            }];
            
            
        }
        else
        {
            [self errorRemind:nil];
        }
    }];
}

#pragma mark - other method
- (void)handleCitysArray {
    [self.citysArray removeAllObjects];
    
    for (char myChar = 'A'; myChar < 'Z'; myChar++) {
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
