//
//  AlivcPublisherView.h
//  AlivcLiveCaptureDev
//
//  Created by TripleL on 17/7/10.
//  Copyright © 2017年 Alivc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlivcLivePushStatsInfo, AlivcLivePushConfig;

@protocol  AlivcPublisherViewDelegate <NSObject>

- (void)publisherOnClickedBackButton;

- (void)publisherOnClickedPreviewButton:(BOOL)isPreview button:(UIButton *)sender;

- (BOOL)publisherOnClickedPushButton:(BOOL)isPush button:(UIButton *)sender;

- (void)publisherOnClickedPauseButton:(BOOL)isPause button:(UIButton *)sender;

- (void)publisherOnClickedRestartButton;

- (void)publisherOnClickedPushVideoButton:(BOOL)isMute button:(UIButton *)sender;

- (void)publisherOnClickedSwitchCameraButton;

- (void)publisherOnClickedFlashButton:(BOOL)flash button:(UIButton *)sender;

- (void)publisherOnClickedBeautyButton:(BOOL)beautyOn;


- (void)publisherOnClickedZoom:(CGFloat)zoom;

- (void)publisherOnClickedFocus:(CGPoint)focusPoint;

- (void)publisherOnClickedShowDebugTextInfo:(BOOL)isShow;

- (void)publisherOnClickedShowDebugChartInfo:(BOOL)isShow;


- (void)publisherSliderBeautyWhiteValueChanged:(int)value;

- (void)publisherSliderBeautyBuffingValueChanged:(int)value;

- (void)publisherSliderBeautyRubbyValueChanged:(int)value;

- (void)publisherSliderBeautyBrightnessValueChanged:(int)value;

- (void)publisherSliderBeautySaturationValueChanged:(int)value;

- (void)publisherOnBitrateChangedTargetBitrate:(int)targetBitrate;

- (void)publisherOnBitrateChangedMinBitrate:(int)minBitrate;


- (void)publisherOnClickSharedButon;

- (void)publisherOnClickAutoFocusButton:(BOOL)isAutoFocus;

- (void)publisherOnClickPreviewMirrorButton:(BOOL)isPreviewMorror;

- (void)publisherOnClickPushMirrorButton:(BOOL)isPushMirror;

@end

@interface AlivcPublisherView : UIView


@property (nonatomic, weak) id<AlivcPublisherViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame config:(AlivcLivePushConfig *)config;

- (void)updateInfoText:(NSString *)text;

- (void)updateDebugChartData:(AlivcLivePushStatsInfo *)info;

- (void)updateDebugTextData:(AlivcLivePushStatsInfo *)info;

- (void)hiddenVideoViews;

@end
