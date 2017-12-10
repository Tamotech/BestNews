//
//  AliyunPlaySDKDemoFullScreenScrollCollectionViewCell.m
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/8/16.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import "AliyunPlaySDKDemoFullScreenScrollCollectionViewCell.h"
#import "UIView+Layout.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface AliyunPlaySDKDemoFullScreenScrollCollectionViewCell()
@property (nonatomic, strong)UIView *playerView;
@end
@implementation AliyunPlaySDKDemoFullScreenScrollCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.isStart = NO;
        [self setContentView];
    }
    return self;
}

-(AliyunVodPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliyunVodPlayer alloc] init];
    }
    return _aliPlayer;
}

- (void)setContentView{
    self.playerView = [[UIView alloc] init];
    self.playerView = self.aliPlayer.playerView;
    [self.contentView addSubview:self.playerView];
    self.playerView.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.aliPlayer setAutoPlay:YES];
    
    
}

- (void)prepare{
    [self.aliPlayer prepareWithURL:[NSURL URLWithString:@"http://cloud.video.taobao.com/play/u/2712925557/p/1/e/6/t/1/40050769.mp4"]];
}

- (void)startPlay{
    [self.aliPlayer start];
    self.isStart = YES;
}

- (void)pausePlay{
    [self.aliPlayer pause];
}

- (void)resumePlay{
    [self.aliPlayer resume];
}

- (void)stopPlay{
    [self.aliPlayer stop];
}

- (void)releasePlayer{
    [self.aliPlayer releasePlayer];
    self.isStart = NO;
}

@end
