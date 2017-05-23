//
//  FlyHallViewController.m
//  ccc
//
//  Created by walg on 2017/5/23.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyHallViewController.h"
#import "FlyShowOldViewController.h"
#import "FlyList.h"
#import "FlyHallCell.h"
@interface FlyHallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation FlyHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全国彩列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGRect frame = CGRectMake((self.view.bounds.size.width-280)/2.0, 0, 280, self.view.bounds.size.height);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[FlyHallCell class] forCellWithReuseIdentifier:@"HALLCELL"];
    }
    return _collectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return countryList().allKeys.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FlyHallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HALLCELL" forIndexPath:indexPath];
    if (indexPath.row<countryList().allKeys.count) {
        NSString *key = countryList().allKeys[indexPath.row];
        cell.title = countryList()[key];
        cell.kind = key;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 80);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1,1,1,1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = countryList().allKeys[indexPath.row];
    
    FlyShowOldViewController *oldVC = [[FlyShowOldViewController alloc] init];
    oldVC.urlStr = key;
    oldVC.showTitle =countryList()[key];
    
    [self.navigationController pushViewController:oldVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
