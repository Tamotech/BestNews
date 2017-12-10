//
//  AliyunPlaySDKDemoFullScreenScrollCollectionViewCell.h
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/8/16.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>
@interface AliyunPlaySDKDemoFullScreenScrollCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)AliyunVodPlayer *aliPlayer;
@property (nonatomic, assign)BOOL isStart;
- (void)prepare;
- (void)startPlay;
- (void)pausePlay;
- (void)resumePlay;
- (void)stopPlay;
- (void)releasePlayer;

@end
