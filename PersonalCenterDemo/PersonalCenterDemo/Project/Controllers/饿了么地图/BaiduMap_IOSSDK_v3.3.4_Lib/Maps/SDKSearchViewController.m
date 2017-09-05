//
//  SDKSearchViewController.m
//  AllDemo
//
//  Created by 美娜栾 on 2017/8/19.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKSearchViewController.h"
#import "SDKResultTableViewController.h"
#import "SDKPoiModel.h"
@interface SDKSearchViewController () <UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, BMKPoiSearchDelegate>
{
    BMKPoiSearch *_searcher;
//    BMKCitySearchOption *_option;
    BMKNearbySearchOption *_option;
    
    int curPage;
}
@property (nonatomic, strong) UISearchController *searchVC;

@property (nonatomic, copy) void (^Resultblock)();

@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation SDKSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    curPage = 0;
    
    [self initSearchVC];
    
    [self initPoiSearch];
    
    self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(backAction) target:self];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _searcher.delegate = self;
    
    [_searchVC.searchBar becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _searcher.delegate = nil;
}

- (void)initSearchVC {
    SDKResultTableViewController *resultVC = [[SDKResultTableViewController alloc] init];
    
    _searchVC =  [[UISearchController alloc] initWithSearchResultsController:resultVC];
    _searchVC.searchBar.frame = CGRectMake(50, 0, kScreenWidth-100, adaptY(40));
    _searchVC.searchBar.placeholder=@"查找小区/大厦等";
    [_searchVC.searchBar setImage:[UIImage imageNamed:@"map_find"]
                  forSearchBarIcon:UISearchBarIconSearch
                             state:UIControlStateNormal];
    
    // 圆角
    UIView* backgroundView = [self subViewOfClassName:@"_UISearchBarSearchFieldBackgroundView" target:_searchVC.searchBar];
    backgroundView.layer.cornerRadius = 14;
    backgroundView.clipsToBounds = YES;
    
    UITextField *searchField = [_searchVC.searchBar valueForKey:@"_searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1.0f];
    searchField.font = kFont(12);
    _searchVC.delegate = self;
    _searchVC.searchResultsUpdater = self;
    _searchVC.searchBar.delegate = self;
    
    // 搜索时 背景色变暗 默认是yes
    _searchVC.dimsBackgroundDuringPresentation = YES;
//        [_searchVC.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];

    // 这句话一定要添加否则点击搜索的时候回导致导航栏向上移动消失
    _searchVC.hidesNavigationBarDuringPresentation = NO;
    // 这个属性也必须要设置否则会出现展现结果控制器无法返回
    self.definesPresentationContext = YES;
    
    self.navigationItem.titleView = _searchVC.searchBar;
    
}

- (void)initPoiSearch {
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    
    /*
    _option = [[BMKCitySearchOption alloc]init];
    _option.city = self.citySting;
    _option.pageIndex    = 0;
    _option.pageCapacity = 50;
    */
    
    _option = [[BMKNearbySearchOption alloc]init];
    _option.radius       = 5000;
    _option.pageIndex    = 0;
    _option.pageCapacity = 50;
    _option.sortType = 1; // 搜索结果排序

}

#pragma mark UISearchResultsUpdating 搜索框控制器的代理方法 是常用的方法 用来处理数据和逻辑的 该代理方法是必须实现的
//更新搜索结果时会调用的方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // 修改取消按钮字号
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for(id sousuo in [_searchVC.searchBar subviews]) {
            for (id view in [sousuo subviews]) {
                if([view isKindOfClass:[UIButton class]]){
                    UIButton *btn = (UIButton *)view;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                    btn.titleLabel.font = kFont(12);
                }
            }
        }
    });
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSString *contentStr = searchController.searchBar.text;
    
    
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:5];
   
    // 开始周边检索
//    [self startCitySearchWithOption:_option keyword:contentStr];
    [self startNearbySearchWithLocation:self.searchLocation option:_option keyword:contentStr];
    
    __weak typeof (self)weakSelf = self;
    _Resultblock = ^() {
        
        [tmp removeAllObjects];
        
        for (SDKPoiModel *info in weakSelf.resultArray) {
            
            /* 注释精确搜索
            if([[info.name lowercaseString] rangeOfString:[searchController.searchBar.text lowercaseString]].location != NSNotFound ||
               [[info.address lowercaseString] rangeOfString:[searchController.searchBar.text lowercaseString]].location != NSNotFound)
            {
                NSLog(@"结果 name:%@ address:%@ value:%@", info.name, info.address, searchController.searchBar.text);
                
                
                info.searchStr = searchController.searchBar.text;
                [tmp addObject:info];
            }
            */
            
            info.searchStr = searchController.searchBar.text;
            [tmp addObject:info];
            
        }
        
        SDKResultTableViewController *tableVC=(SDKResultTableViewController*)searchController.searchResultsController;
        tableVC.resultArray= tmp.copy;
        [tableVC.tableView reloadData];
        
        tableVC.canSendMapDataBlock = ^{
            [weakSelf.navigationController popToViewController:weakSelf.navigationController.childViewControllers[weakSelf.navigationController.childViewControllers.count-3] animated:false];
        };
        
        // cancel
        tableVC.cancelBlock = ^{
            [weakSelf.searchVC.searchBar endEditing:true];
        };
        
    };
    
    
    
    
}
#pragma mark - 周边检索
- (void)startNearbySearchWithLocation:(CLLocationCoordinate2D)location option:(BMKNearbySearchOption *)option keyword:(NSString *)keyword {
    
    option.location  = location;
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

#pragma mark - 城市检索
- (void)startCitySearchWithOption:(BMKCitySearchOption *)option keyword:(NSString *)keyword {

    option.keyword = keyword;
    
    BOOL flag = [_searcher poiSearchInCity:option];
    
    if(flag)
    {
        NSLog(@"城市检索发送成功");
    }
    else
    {
        NSLog(@"城市检索发送失败");
    }
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        
//        NSLog(@"地址--> %@",result.poiAddressInfoList);
//        

        // 转换模型
        NSMutableArray *tmp = [NSMutableArray array];
        for (BMKPoiInfo *info in result.poiInfoList) {
            
            NSLog(@"_name = %@, _address = %@, _city = %@",info.name,info.address,info.city);
            NSLog(@"lon:%.2f la:%.2f", info.pt.longitude, info.pt.latitude);
            
            SDKPoiModel *poiM = [SDKPoiModel new];
            poiM.name = info.name;
            poiM.address = info.address;
            poiM.city = info.city;
            poiM.coordinate2D = info.pt;
            
            
            BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(info.pt.latitude, info.pt.longitude));
            BMKMapPoint point2 = BMKMapPointForCoordinate(self.searchLocation);
            CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
            
            poiM.distance = distance;
            
            [tmp addObject:poiM];
        }
        
        
        // 排序
        NSArray *sortedArr = [tmp sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           
            SDKPoiModel *p1 = (SDKPoiModel *)obj1;
            SDKPoiModel *p2 = (SDKPoiModel *)obj2;
            

            return [@(p1.distance) compare:@(p2.distance)];
        }];
        
        
        [self.resultArray removeAllObjects];
        [self.resultArray addObjectsFromArray:sortedArr];
        

    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
        
        [self.resultArray removeAllObjects];
    } else {
        NSLog(@"其他情况 error:%u", error);
        
        [self.resultArray removeAllObjects];
    }
    
    if (_Resultblock) {
        _Resultblock();
    }
}

#pragma mark - other method
- (UIView*)subViewOfClassName:(NSString*)className target:(UIView *)target {
    for (UIView *subView in target.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className])
        { return subView; }
        
        UIView *resultFound = [self subViewOfClassName:className target:subView];
        if (resultFound) { return resultFound; }
    }
    return nil;
}

#pragma mark - back
- (void)backAction {
    [self.navigationController popViewControllerAnimated:false];
}

#pragma mark - lazy load
- (NSMutableArray *)resultArray {
    if (!_resultArray) {
        _resultArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _resultArray;
}

@end
