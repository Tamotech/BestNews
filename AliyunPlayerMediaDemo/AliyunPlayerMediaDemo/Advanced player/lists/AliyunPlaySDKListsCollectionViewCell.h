//
//  AliyunPlaySDKListsCollectionViewCell.h
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/8/16.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>

@interface AliyunPlaySDKListsCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)AliyunVodPlayer *aliPlayer;

- (void)startPlay;
- (void)startPlayWithUrl:(NSURL *)url;

- (void)pausePlay;
- (void)resumePlay;
- (void)releasePlayer;

@end
