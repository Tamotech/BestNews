//
//  AlivcPublisherViewController.m
//  AlivcLiveCaptureDev
//
//  Created by TripleL on 17/7/10.
//  Copyright © 2017年 Alivc. All rights reserved.
//

#import "AlivcLivePusherViewController.h"
#import "AlivcPublisherView.h"
#import "PrefixHeader.pch"

#import <AlivcLivePusher/AlivcLivePusherHeader.h>

#define kAlivcLivePusherVCAlertTag 89976
#define kAlivcLivePusherDebugTimerInterval 2.0
#define kAlivcLivePusherNoticeTimerInterval 5.0



@interface AlivcLivePusherViewController () <AlivcPublisherViewDelegate, AlivcLivePusherInfoDelegate, AlivcLivePusherErrorDelegate, AlivcLivePusherNetworkDelegate, UIAlertViewDelegate>

// UI
@property (nonatomic, strong) AlivcPublisherView *publisherView;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) NSTimer *noticeTimer;
@property (nonatomic, strong) NSTimer *debugTimer;

// flags
@property (nonatomic, assign) BOOL isDebugChart;
@property (nonatomic, assign) BOOL isDebugText;
@property (nonatomic, assign) BOOL isAutoFocus;

// SDK
@property (nonatomic, strong) AlivcLivePusher *livePusher;

@end

@implementation AlivcLivePusherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self setupDefaultValues];
    
    [self setupDebugTimer];

    int ret = [self setupPusher];
    
    if (ret != 0) {
        [self showAlertViewWithErrorCode:ret
                                errorStr:nil
                                     tag:kAlivcLivePusherVCAlertTag+31
                                   title:NSLocalizedString(@"dialog_title", nil)
                                 message:@"Init AlivcLivePusher Error"
                                delegate:self
                             cancelTitle:NSLocalizedString(@"exit", nil)
                       otherButtonTitles:nil];
        return;
    }
    
    ret = [self startPreview];
    
    if (ret != 0) {
        [self showAlertViewWithErrorCode:ret
                                errorStr:nil
                                     tag:kAlivcLivePusherVCAlertTag+32
                                   title:NSLocalizedString(@"dialog_title", nil)
                                 message:@"StartPreview Error"
                                delegate:self
                             cancelTitle:NSLocalizedString(@"exit", nil)
                       otherButtonTitles:nil];
        return;
    }
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if (self.pushConfig.orientation == AlivcLivePushOrientationLandscapeLeft) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    } else if (self.pushConfig.orientation == AlivcLivePushOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}


#pragma mark - SDK

/**
 创建推流
 */
- (int)setupPusher {
    
    self.livePusher = [[AlivcLivePusher alloc] initWithConfig:self.pushConfig];
//    [self.livePusher setLogLevel:(AlivcLivePushLogLevelDebug)];
    if (!self.livePusher) {
        return -1;
    }
    [self.livePusher setInfoDelegate:self];
    [self.livePusher setErrorDelegate:self];
    [self.livePusher setNetworkDelegate:self];
    return 0;
}


/**
 销毁推流
 */
- (void)destoryPusher {
    
    if (self.livePusher) {
        [self.livePusher destory];
    }
    
    self.livePusher = nil;
}


/**
 开始预览
 */
- (int)startPreview {
    
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = 0;
    if (self.isUseAsyncInterface) {
        // 使用异步接口
        ret = [self.livePusher startPreviewAsync:self.previewView];
        
    } else {
        // 使用同步接口
        ret = [self.livePusher startPreview:self.previewView];
    }
    return ret;
}


/**
 停止预览
 */
- (int)stopPreview {
    
    if (!self.livePusher) {
        return -1;
    }
    int ret = [self.livePusher stopPreview];
    return ret;
}


/**
 开始推流
 */
- (int)startPush {
    
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = 0;
    if (self.isUseAsyncInterface) {
        // 使用异步接口
        ret = [self.livePusher startPushWithURLAsync:self.pushURL];
    
    } else {
        // 使用同步接口
        ret = [self.livePusher startPushWithURL:self.pushURL];
    }
    return ret;
}


/**
 停止推流
 */
- (int)stopPush {
    
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = [self.livePusher stopPush];
    return ret;
}


/**
 暂停推流
 */
- (int)pausePush {
    
    if (!self.livePusher) {
        return -1;
    }

    int ret = [self.livePusher pause];
    return ret;
}


/**
 恢复推流
 */
- (int)resumePush {
   
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = 0;

    if (self.isUseAsyncInterface) {
        // 使用异步接口
       ret = [self.livePusher resumeAsync];
        
    } else {
        // 使用同步接口
        ret = [self.livePusher resume];
    }
    return ret;
}



/**
 重新推流
 */
- (int)restartPush {
    
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = 0;
    if (self.isUseAsyncInterface) {
        // 使用异步接口
        ret = [self.livePusher restartPushAsync];
        
    } else {
        // 使用同步接口
        ret = [self.livePusher restartPush];
    }
    return ret;
}


- (void)reconnectPush {
    
    if (!self.livePusher) {
        return;
    }
    
    [self.livePusher reconnectPushAsync];
}

#pragma mark - AlivcLivePusherErrorDelegate

- (void)onSystemError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showAlertViewWithErrorCode:error.errorCode
                                errorStr:error.errorDescription
                                     tag:kAlivcLivePusherVCAlertTag+11
                                   title:NSLocalizedString(@"dialog_title", nil)
                                 message:NSLocalizedString(@"system_error", nil)
                                delegate:self
                             cancelTitle:NSLocalizedString(@"exit", nil)
                       otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
    });
}


- (void)onSDKError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertViewWithErrorCode:error.errorCode
                                errorStr:error.errorDescription
                                     tag:kAlivcLivePusherVCAlertTag+12
                                   title:NSLocalizedString(@"dialog_title", nil)
                                 message:NSLocalizedString(@"sdk_error", nil)
                                delegate:self
                             cancelTitle:NSLocalizedString(@"exit", nil)
                       otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
    });
}



#pragma mark - AlivcLivePusherNetworkDelegate

- (void)onConnectFail:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error {
    
    [self showAlertViewWithErrorCode:error.errorCode
                            errorStr:error.errorDescription
                                 tag:kAlivcLivePusherVCAlertTag+23
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:NSLocalizedString(@"connect_fail", nil)
                            delegate:self
                         cancelTitle:NSLocalizedString(@"reconnect_button", nil)
                   otherButtonTitles:NSLocalizedString(@"exit", nil), nil];

}


- (void)onSendDataTimeout:(AlivcLivePusher *)pusher {
    
    [self showAlertViewWithErrorCode:0
                            errorStr:nil
                                 tag:0
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:NSLocalizedString(@"senddata_timeout", nil)
                            delegate:nil
                         cancelTitle:NSLocalizedString(@"ok", nil)
                   otherButtonTitles:nil];
}


- (void)onConnectRecovery:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"connectRecovery_log", nil)];
}


- (void)onNetworkPoor:(AlivcLivePusher *)pusher {
    
    [self showAlertViewWithErrorCode:0 errorStr:nil tag:0 title:NSLocalizedString(@"dialog_title", nil) message:@"当前网速较慢，请检查网络状态" delegate:nil cancelTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
}


- (void)onReconnectStart:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"reconnect_start", nil)];
}


- (void)onReconnectSuccess:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"reconnect_success", nil)];
}


- (void)onReconnectError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error {
    
    [self showAlertViewWithErrorCode:error.errorCode
                            errorStr:error.errorDescription
                                 tag:kAlivcLivePusherVCAlertTag+22
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:NSLocalizedString(@"reconnect_fail", nil)
                            delegate:self
                         cancelTitle:NSLocalizedString(@"reconnect_button", nil)
                   otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
}


#pragma mark - AlivcLivePusherInfoDelegate

- (void)onPreviewStarted:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"start_preview_log", nil)];
}


- (void)onPreviewStoped:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"stop_preview_log", nil)];
}

- (void)onPushStarted:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"start_push_log", nil)];
}


- (void)onPushPauesed:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"pause_push_log", nil)];
}


- (void)onPushResumed:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"resume_push_log", nil)];
}


- (void)onPushStoped:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"stop_push_log", nil)];
}


- (void)onFirstFramePreviewed:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"first_frame_log", nil)];
}


- (void)onPushRestart:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"restart_push_log", nil)];
}


#pragma mark - AlivcPublisherViewDelegate

- (void)publisherOnClickedBackButton {
    
    [self cancelTimer];
    [self destoryPusher];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)publisherOnClickedPreviewButton:(BOOL)isPreview button:(UIButton *)sender {
    
    if (isPreview) {
        int ret = [self startPreview];
        if (ret != 0) {
            
            [self showAlertViewWithErrorCode:ret
                                    errorStr:nil
                                         tag:kAlivcLivePusherVCAlertTag+33
                                       title:NSLocalizedString(@"dialog_title", nil)
                                     message:@"Start Preview Error"
                                    delegate:self
                                 cancelTitle:NSLocalizedString(@"ok", nil)
                           otherButtonTitles:nil];
            [sender setSelected:!sender.selected];
        }
    } else {
        int ret = [self stopPreview];
        if (ret != 0) {
            
            [self showAlertViewWithErrorCode:ret
                                    errorStr:nil
                                         tag:0
                                       title:NSLocalizedString(@"dialog_title", nil)
                                     message:@"Stop Preview Error"
                                    delegate:nil
                                 cancelTitle:NSLocalizedString(@"ok", nil)
                           otherButtonTitles:nil];
            [sender setSelected:!sender.selected];
        }
    }
}

- (BOOL)publisherOnClickedPushButton:(BOOL)isPush button:(UIButton *)sender {
    
    if (isPush) {
        // 开始推流
        int ret = [self startPush];
        if (ret != 0) {
            
            [self showAlertViewWithErrorCode:ret
                                    errorStr:nil
                                         tag:0
                                       title:NSLocalizedString(@"dialog_title", nil)
                                     message:@"Start Push Error"
                                    delegate:nil
                                 cancelTitle:NSLocalizedString(@"ok", nil)
                           otherButtonTitles:nil];
            [sender setSelected:!sender.selected];
            return NO;
        }
        return YES;
    } else {
        // 停止推流
        int ret = [self stopPush];
        
        if (ret != 0) {
            
            [self showAlertViewWithErrorCode:ret
                                    errorStr:nil
                                         tag:0
                                       title:NSLocalizedString(@"dialog_title", nil)
                                     message:@"Stop Push Error"
                                    delegate:nil
                                 cancelTitle:NSLocalizedString(@"ok", nil)
                           otherButtonTitles:nil];
            [sender setSelected:!sender.selected];
            return NO;
        }
        return YES;
    }
}

- (void)publisherOnClickedPauseButton:(BOOL)isPause button:(UIButton *)sender {
    
    if (isPause) {
        int ret = [self pausePush];
        if (ret != 0) {
            
            [self showAlertViewWithErrorCode:ret
                                    errorStr:nil
                                         tag:0
                                       title:NSLocalizedString(@"dialog_title", nil)
                                     message:@"Pause Error"
                                    delegate:nil
                                 cancelTitle:NSLocalizedString(@"ok", nil)
                           otherButtonTitles:nil];
            [sender setSelected:!sender.selected];
        }

    } else {
        int ret = [self resumePush];
        if (ret != 0) {
            
            [self showAlertViewWithErrorCode:ret
                                    errorStr:nil
                                         tag:0
                                       title:NSLocalizedString(@"dialog_title", nil)
                                     message:@"Resume Error"
                                    delegate:nil
                                 cancelTitle:NSLocalizedString(@"ok", nil)
                           otherButtonTitles:nil];
            [sender setSelected:!sender.selected];
        }
    }
}


- (void)publisherOnClickedRestartButton {
    
    int ret = [self restartPush];
    if (ret != 0) {
        
        [self showAlertViewWithErrorCode:ret
                                errorStr:nil
                                     tag:0
                                   title:NSLocalizedString(@"dialog_title", nil)
                                 message:@"Restart Error"
                                delegate:nil
                             cancelTitle:NSLocalizedString(@"ok", nil)
                       otherButtonTitles:nil];
    }
}

- (void)publisherOnClickedPushVideoButton:(BOOL)isMute button:(UIButton *)sender {
    
    if (self.livePusher) {
        [self.livePusher setMute:isMute?true:false];
    }
}

- (void)publisherOnClickedSwitchCameraButton {
    
    if (self.livePusher) {
        [self.livePusher switchCamera];
    }
}

- (void)publisherOnClickedFlashButton:(BOOL)flash button:(UIButton *)sender {
    
    if (self.livePusher) {
        [self.livePusher setFlash:flash?true:false];
    }
}

- (void)publisherOnClickedBeautyButton:(BOOL)beautyOn {
    
    if (self.livePusher) {
        [self.livePusher setBeautyOn:beautyOn?true:false];
    }
}

- (void)publisherOnClickedZoom:(CGFloat)zoom {
    
    if (self.livePusher) {
        CGFloat max = [_livePusher getMaxZoom];
        [self.livePusher setZoom:MIN(zoom, max)];
    }
}


- (void)publisherOnClickedFocus:(CGPoint)focusPoint {
    
    if (self.livePusher) {
        [self.livePusher focusCameraAtAdjustedPoint:focusPoint autoFocus:self.isAutoFocus];
    }
}

- (void)publisherSliderBeautyWhiteValueChanged:(int)value {
    
    if (self.livePusher) {
        [self.livePusher setBeautyWhite:value];
    }
}


- (void)publisherSliderBeautyBuffingValueChanged:(int)value {
 
    if (self.livePusher) {
        [self.livePusher setBeautyBuffing:value];
    }
}

- (void)publisherSliderBeautyBrightnessValueChanged:(int)value{
    
    if (self.livePusher) {
        [self.livePusher setBeautyBrightness:value];
    }
}

- (void)publisherSliderBeautySaturationValueChanged:(int)value{

    if (self.livePusher) {
        [self.livePusher setBeautySaturation:value];
    }
}


- (void)publisherSliderBeautyRubbyValueChanged:(int)value {
    
    if (self.livePusher) {
        [self.livePusher setBeautyRuddy:value];
    }
}


- (void)publisherOnBitrateChangedTargetBitrate:(int)targetBitrate {
    
    if (self.livePusher) {
        
        int ret = [self.livePusher setTargetVideoBitrate:targetBitrate];
        if (ret != 0) {
            
            [self showAlertViewWithErrorCode:ret
                                    errorStr:nil
                                         tag:0
                                       title:NSLocalizedString(@"dialog_title", nil)
                                     message:NSLocalizedString(@"bite_error", nil)
                                    delegate:nil
                                 cancelTitle:NSLocalizedString(@"ok", nil)
                           otherButtonTitles:nil];
        }
    }
}


- (void)publisherOnBitrateChangedMinBitrate:(int)minBitrate {
    
    if (self.livePusher) {
        int ret = [self.livePusher setMinVideoBitrate:minBitrate];
    
        if (ret != 0) {
            [self showAlertViewWithErrorCode:ret
                                    errorStr:nil
                                         tag:0
                                       title:NSLocalizedString(@"dialog_title", nil)
                                     message:NSLocalizedString(@"bite_error", nil)
                                    delegate:nil
                                 cancelTitle:NSLocalizedString(@"ok", nil)
                           otherButtonTitles:nil];
        }
    }
}


- (void)publisherOnClickPushMirrorButton:(BOOL)isPushMirror {
    
    if (self.livePusher) {
        [self.livePusher setPushMirror:isPushMirror?true:false];
    }
}


- (void)publisherOnClickPreviewMirrorButton:(BOOL)isPreviewMorror {
    
    if (self.livePusher) {
        [self.livePusher setPreviewMirror:isPreviewMorror?true:false];
    }
}


- (void)publisherOnClickAutoFocusButton:(BOOL)isAutoFocus {
    
    if (self.livePusher) {
        [self.livePusher setAutoFocus:isAutoFocus?true:false];
        self.isAutoFocus = isAutoFocus;
    }
}


- (void)publisherOnClickSharedButon {
    
    NSLog(@"shared");
}

- (void)publisherOnClickedShowDebugTextInfo:(BOOL)isShow {
    
    // 文字调试
    self.isDebugText = isShow;
    
    if (isShow && self.livePusher) {
        [self.publisherView updateDebugTextData:[self.livePusher getLivePushStatusInfo]];
    }
}

- (void)publisherOnClickedShowDebugChartInfo:(BOOL)isShow {
    
    // 图表调试
    self.isDebugChart = isShow;
    
    if (isShow && self.livePusher) {
        [self.publisherView updateDebugChartData:[self.livePusher getLivePushStatusInfo]];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == kAlivcLivePusherVCAlertTag+11 ||
        alertView.tag == kAlivcLivePusherVCAlertTag+12 ||
        alertView.tag == kAlivcLivePusherVCAlertTag+31 ||
        alertView.tag == kAlivcLivePusherVCAlertTag+32 ||
        alertView.tag == kAlivcLivePusherVCAlertTag+33) {
        
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self publisherOnClickedBackButton];
        }
    }
    
    if (alertView.tag == kAlivcLivePusherVCAlertTag+22 ||
        alertView.tag == kAlivcLivePusherVCAlertTag+23) {
        
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self reconnectPush];
        } else {
            [self publisherOnClickedBackButton];
        }
    }
}


#pragma - UI
- (void)setupSubviews {
    
    self.view.backgroundColor = [UIColor blackColor];
    if (self.pushConfig.orientation != AlivcLivePushOrientationPortrait) {
        // 横屏
        self.previewView.frame = CGRectMake(0, 0, AlivcScreenHeight, AlivcScreenWidth);
        self.publisherView.frame = CGRectMake(0, 0, AlivcScreenHeight, AlivcScreenWidth);
    }
    
    [self.view addSubview: self.previewView];
    [self.view addSubview: self.publisherView];
    if (self.pushConfig.audioOnly) {
        [self.publisherView hiddenVideoViews];
    }
}


- (void)setupDefaultValues {
    
    self.isDebugText = NO;
    self.isDebugChart = NO;
    self.isAutoFocus = self.pushConfig.autoFocus;
}

- (void)showAlertViewWithErrorCode:(NSInteger)errorCode errorStr:(NSString *)errorStr tag:(NSInteger)tag title:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelTitle:(NSString *)cancel otherButtonTitles:(NSString *)otherTitles, ... {
    
    if (errorCode == ALIVC_LIVE_PUSHER_PARAM_ERROR) {
        errorStr = @"接口输入参数错误";
    }
    
    if (errorCode == ALIVC_LIVE_PUSHER_SEQUENCE_ERROR) {
        errorStr = @"接口调用顺序错误";
    }
    
    NSString *showMessage = [NSString stringWithFormat:@"%@: code:%lx message:%@", message, errorCode, errorStr];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:showMessage delegate:delegate cancelButtonTitle:cancel otherButtonTitles: otherTitles,nil];
        if (tag) {
            alert.tag = tag;
        }
        [alert show];
    });
}


#pragma mark - Timer

- (void)setupDebugTimer {
    
    self.noticeTimer = [NSTimer scheduledTimerWithTimeInterval:kAlivcLivePusherNoticeTimerInterval target:self selector:@selector(noticeTimerAction:) userInfo:nil repeats:YES];
    self.debugTimer = [NSTimer scheduledTimerWithTimeInterval:kAlivcLivePusherDebugTimerInterval target:self selector:@selector(debugTimerAction:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.noticeTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:self.debugTimer forMode:NSDefaultRunLoopMode];
}

- (void)cancelTimer{
    
    if (self.noticeTimer) {
        [self.noticeTimer invalidate];
        self.noticeTimer = nil;
    }
    
    if (self.debugTimer) {
        [self.debugTimer invalidate];
        self.debugTimer = nil;
    }
}


- (void)noticeTimerAction:(NSTimer *)sender {
    
    if (!self.livePusher) {
        return;
    }

    BOOL isPushing = [self.livePusher isPushing];
    NSString *text = @"";
    if (isPushing) {
        text = [NSString stringWithFormat:@"%@:%@|%@:%@",NSLocalizedString(@"ispushing_log", nil), isPushing?@"YES":@"NO", NSLocalizedString(@"push_url_log", nil), [self.livePusher getPushURL]];
    } else {
        text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"ispushing_log", nil), isPushing?@"YES":@"NO"];
    }

    [self.publisherView updateInfoText:text];
}


- (void)debugTimerAction:(NSTimer *)sender {
    
    if (!self.livePusher) {
        return;
    }

    if (self.isDebugText) {
        [self.publisherView updateDebugTextData:[self.livePusher getLivePushStatusInfo]];
    }

    if (self.isDebugChart) {
        [self.publisherView updateDebugChartData:[self.livePusher getLivePushStatusInfo]];
    }
}



#pragma mark - 懒加载

- (AlivcPublisherView *)publisherView {
    
    if (!_publisherView) {
        CGRect frame = self.view.bounds;
        if (self.pushConfig.orientation != AlivcLivePushOrientationPortrait) {
            CGFloat tem = frame.size.height;
            frame.size.height = frame.size.width;
            frame.size.width = tem;
        }
        _publisherView = [[AlivcPublisherView alloc] initWithFrame:frame config:self.pushConfig];
        _publisherView.delegate  = self;
        _publisherView.backgroundColor = [UIColor clearColor];
    }
    return _publisherView;
}

- (UIView *)previewView {
    if (!_previewView) {
        CGRect frame = self.view.bounds;
        if (self.pushConfig.orientation != AlivcLivePushOrientationPortrait) {
            CGFloat tem = frame.size.height;
            frame.size.height = frame.size.width;
            frame.size.width = tem;
        }
        _previewView = [[UIView alloc] init];
        _previewView.backgroundColor = [UIColor clearColor];
        _previewView.frame = frame;
    }
    return _previewView;
}



@end
