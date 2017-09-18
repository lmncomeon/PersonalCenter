//
//  MNPhotoAlbumViewController.m
//  PersonalCenterDemo
//
//  Created by 栾美娜 on 2017/9/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "MNPhotoAlbumViewController.h"
#import "MNPhotoAlbumCell.h"
#import "MNPhotoAlbum.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface MNPhotoAlbumViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    ALAssetsLibrary *library;
}
@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) NSMutableArray <MNPhotoAlbum *> *dataList;
@property (nonatomic, strong) NSMutableArray <MNPhotoAlbum *> *container;

@end

static NSString *const cellID = @"MNPhotoAlbumCellID";

@implementation MNPhotoAlbumViewController

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        CGFloat padding = 1;
        CGFloat itemWH = (kScreenWidth - (4-1)*padding)/4;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth-64) collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = commonWhiteColor;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate   = self;
        [self.view addSubview:_mainCollectionView];
        
        [_mainCollectionView registerClass:[MNPhotoAlbumCell class] forCellWithReuseIdentifier:cellID];
    }
    return _mainCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBarbuttonItem];

    [self mainCollectionView];
    
    for (int i = 0; i < 40; i++) {
        MNPhotoAlbum *model = [MNPhotoAlbum new];

        model.imgUrl = (i % 2 == 0) ?
        @"http://img.ivsky.com/img/tupian/t/201708/05/haokandexinxingwupintupian-006.jpg" :
        @"http://img.ivsky.com/img/tupian/t/201708/05/haokandexinxingwupintupian-010.jpg" ;
        [self.dataList addObject:model];
    }

//    [self getPhotos];
    
    [self.mainCollectionView reloadData];
    
}

- (void)getPhotos {
    //创建资源库,用于访问相册资源
    library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //如果存在相册,再遍历
        if (group) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                [result thumbnail];
                
                //获取到缩略图
                CGImageRef cimg = [result thumbnail];
                //转换为UIImage
                UIImage *img = [UIImage imageWithCGImage:cimg];
                
                MNPhotoAlbum *model = [MNPhotoAlbum new];
                model.image = img;
                [self.dataList addObject:model];
            }];
        }
        
        [self.mainCollectionView reloadData];
    } failureBlock:^(NSError *error) {
         NSLog(@"访问失败");
    }];
}

- (void)setupBarbuttonItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(nextAction)];
    
    self.navigationItem.rightBarButtonItem.enabled = false;
}

// 下一步
- (void)nextAction {
    
}

#pragma mark - dataSource & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MNPhotoAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    
    HXWeak_self
    HXWeak_(cell)
    cell.clickEvent = ^ () {
        HXStrong_self
        
        MNPhotoAlbum *currentM = self.dataList[indexPath.row];
        if (currentM.selected) {
            [self.container addObject:currentM];
            
            HXStrong_(cell)
            currentM.num = [NSString stringWithFormat:@"%ld", [self.container indexOfObject:currentM]+1];
            cell.model = currentM;
            
        } else {
            [self.container removeObject:currentM];
            
            currentM.num = @"";
            for (int i = 0; i < self.container.count; i++) {
                self.container[i].num = [NSString stringWithFormat:@"%d", i+1];
            }
            
            [self.mainCollectionView reloadData];
        }
        
        self.navigationItem.rightBarButtonItem.enabled = self.container.count;

        
//        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:5];
//        for (MNPhotoAlbum *model in self.dataList) {
//            if (model.selected) { [tmp addObject:model]; }
//        }
//        
//        self.navigationItem.rightBarButtonItem.enabled = tmp.count;
    };

    return cell;
}

#pragma mark - lazy load
- (NSMutableArray <MNPhotoAlbum *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithCapacity:5];
    }
    return _dataList;
}

- (NSMutableArray <MNPhotoAlbum *> *)container {
    if (!_container) {
        _container = [NSMutableArray array];
    }
    return _container;
}

@end
