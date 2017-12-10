//
//  AliyunPlaySDKDemoFullScreenScrollViewController.m
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/8/16.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import "AliyunPlaySDKDemoFullScreenScrollViewController.h"
#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>
#import "AliyunPlaySDKDemoFullScreenScrollCollectionViewCell.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface AliyunPlaySDKDemoFullScreenScrollViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;
@end
@implementation AliyunPlaySDKDemoFullScreenScrollViewController
static NSString *cellId = @"customCell";
#pragma mark - naviBar
- (void)naviBar{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemCliceked:)];
}

- (void)leftBarButtonItemCliceked:(UIBarButtonItem*)sender{
    //释放播放器
    NSArray *ary = [self.collectionView visibleCells];
    for (AliyunPlaySDKDemoFullScreenScrollCollectionViewCell *cell in ary) {
        [cell releasePlayer];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self naviBar];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize =  CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    layout.minimumInteritemSpacing=0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor grayColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:self.collectionView];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //开多个分区，没有使用重用机制。
   static NSString *identifier=@"identifier";
    [collectionView registerClass:[AliyunPlaySDKDemoFullScreenScrollCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    AliyunPlaySDKDemoFullScreenScrollCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
                                                               
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    AliyunPlaySDKDemoFullScreenScrollCollectionViewCell *temp =  (AliyunPlaySDKDemoFullScreenScrollCollectionViewCell*)cell;
   [temp prepare];
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    AliyunPlaySDKDemoFullScreenScrollCollectionViewCell *temp =  (AliyunPlaySDKDemoFullScreenScrollCollectionViewCell*)cell;
    [temp stopPlay];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
