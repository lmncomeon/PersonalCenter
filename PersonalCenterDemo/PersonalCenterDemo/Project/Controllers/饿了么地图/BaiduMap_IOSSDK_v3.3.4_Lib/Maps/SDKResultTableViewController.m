//
//  SDKResultTableViewController.m
//  AllDemo
//
//  Created by 美娜栾 on 2017/8/19.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKResultTableViewController.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"
#import "UIView+CustomView.h"

#import "SDKPoiModel.h"
#import "NearbyListCell.h"



@interface SDKResultTableViewController ()
{
    CLGeocoder *_geocoder;
}
@property (nonatomic, strong) UIView *mapEmptyView;

@end

static NSString *const NearbyListCellID = @"NearbyListCellID";

@implementation SDKResultTableViewController

- (UIView *)mapEmptyView {
    if (!_mapEmptyView) {
        _mapEmptyView = [[UIView alloc] initWithFrame:self.view.bounds];
        _mapEmptyView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - adaptX(135))*0.5, adaptY(100)+64, adaptX(135), adaptY(94))];
        icon.image = [UIImage imageNamed:@"map_nodata"];
        [_mapEmptyView addSubview:icon];
        
        SDKCustomLabel *tipLab = [SDKCustomLabel setLabelTitle:@"没找到？在地图上拖动试试" setLabelFrame:CGRectMake(0, CGRectGetMaxY(icon.frame) + adaptY(50), kScreenWidth, adaptY(20)) setLabelColor:[UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1.0f] setLabelFont:kFont(14) setAlignment:1];
        [_mapEmptyView addSubview:tipLab];
        
        HXWeak_self
        [_mapEmptyView addSingleTapEvent:^{
            HXStrong_self
            
            !self.cancelBlock ? : self.cancelBlock();
        }];
    }
    return _mapEmptyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self initGeocoder];
}

- (void)initGeocoder {
    _geocoder = [[CLGeocoder alloc] init];
}

- (void)setResultArray:(NSMutableArray *)resultArray
{
    _resultArray = resultArray;
    [self.tableView reloadData];
    
    [self.mapEmptyView removeFromSuperview];
    
    if (resultArray.count == 0 || !resultArray) { [self.view addSubview:self.mapEmptyView]; }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NearbyListCell *cell = [NearbyListCell cellWithTableView:tableView identifier:NearbyListCellID];
    
    SDKPoiModel *info = self.resultArray[indexPath.row];
    
    [cell colorfulWithModel:info];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NearbyListCell searchCellHeightWith:self.resultArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SDKPoiModel *info = self.resultArray[indexPath.row];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:info.coordinate2D.latitude longitude:info.coordinate2D.longitude];
    
    __weak typeof(self) weakSelf = self;
    
    [self reverseGeocodeLocation:location resultUsingBlock:^(CLPlacemark *placemark) {
        
        NSString *provinces = [NSString stringWithFormat:@"%@ %@ %@", placemark.administrativeArea ? : @"", placemark.locality ? : @"", placemark.subLocality ? : @""];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mapValueNotification" object:nil userInfo:@{@"provinces" : provinces, @"address":(info.address ? : @"")}];
        
        
        if (weakSelf.canSendMapDataBlock) {weakSelf.canSendMapDataBlock(); }
        
    }];
}

// 反编码
- (void)reverseGeocodeLocation:(CLLocation *)location resultUsingBlock:(void (^)(CLPlacemark *placemark))result {
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error) {
        
        CLPlacemark *placemark;
        
        if (array.count > 0) { placemark = [array objectAtIndex:0]; }
        
        if (result) {  result(placemark);  }
        
    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
