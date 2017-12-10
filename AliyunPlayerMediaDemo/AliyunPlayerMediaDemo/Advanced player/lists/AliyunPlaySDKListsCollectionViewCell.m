//
//  AliyunPlaySDKListsCollectionViewCell.m
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/8/16.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import "AliyunPlaySDKListsCollectionViewCell.h"

@interface AliyunPlaySDKListsCollectionViewCell()
@property (nonatomic, strong)UIView *playerView;
@end
@implementation AliyunPlaySDKListsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
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
    [self addSubview:self.playerView];
    self.playerView.frame= CGRectMake(10, 10, self.contentView.frame.size.width-20, (self.contentView.frame.size.width-20) * 9 / 16.0);
    [self.aliPlayer setAutoPlay:YES];
    [self.aliPlayer prepareWithURL:[NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"]];
}

- (void)startPlay{
    [self.aliPlayer start];
}

- (void)startPlayWithUrl:(NSURL *)url{
    [self.aliPlayer prepareWithURL:url];
    [self.aliPlayer start];
}

- (void)pausePlay{
    [self.aliPlayer pause];
}

- (void)resumePlay{
    [self.aliPlayer resume];
}

- (void)releasePlayer{
    [self.aliPlayer releasePlayer];
}

@end
