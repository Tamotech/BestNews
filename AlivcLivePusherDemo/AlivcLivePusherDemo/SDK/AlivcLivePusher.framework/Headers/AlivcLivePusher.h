//
//  AlivcLivePusher.h
//  AlivcLiveCaptureLib
//
//  Created by TripleL on 17/7/13.
//  Copyright © 2017年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlivcLivePushConfig.h"
#import "AlivcLivePushStatsInfo.h"
#import "AlivcLivePushError.h"


/**
 错误回调, 网络回调, 状态回调
 */
@protocol AlivcLivePusherErrorDelegate, AlivcLivePusherNetworkDelegate, AlivcLivePusherInfoDelegate;



/**
 推流类
 */
@interface AlivcLivePusher : NSObject


/**
 init

 @param config 推流配置
 @return self:success  nil:failure
 */
- (instancetype)initWithConfig:(AlivcLivePushConfig *)config;


/**
 设置推流错误监听回调

 @param delegate AlivcLivePusherErrorDelegate
 */
- (void)setErrorDelegate:(id<AlivcLivePusherErrorDelegate>)delegate;


/**
 设置推流状态监听回调

 @param delegate AlivcLivePusherInfoDelegate
 */
- (void)setInfoDelegate:(id<AlivcLivePusherInfoDelegate>)delegate;


/**
 设置推流网络监听回调

 @param delegate AlivcLivePusherNetworkDelegate
 */
- (void)setNetworkDelegate:(id<AlivcLivePusherNetworkDelegate>)delegate;


/**
 开始预览 同步接口

 @param previewView 预览view
 @return 0:success  非0:failure
 */
- (int)startPreview:(UIView *)previewView;


/**
 停止预览

 @return 0:success  非0:failure
 */
- (int)stopPreview;


/**
 开始推流 同步接口

 @param pushURL 推流URL
 @return 0:success  非0:failure
 */
- (int)startPushWithURL:(NSString *)pushURL;


/**
 停止推流
 
 @return 0:success  非0:failure
 */
- (int)stopPush;


/**
 重新推流 同步接口

 @return 0:success  非0:failure
 */
- (int)restartPush;


/**
 暂停推流
 
 @return 0:success  非0:failure
 */
- (int)pause;



/**
 恢复推流 同步接口

 @return 0:success  非0:failure
 */
- (int)resume;


/**
 重连 异步接口

 @return 0:success  非0:failure
 */
- (int)reconnectPushAsync;


/**
 销毁推流
 */
- (void)destory;



/* ***********************异步接口*********************** */
/**
 开始预览 异步接口
 
 @param preview 预览view
 @return 0:success  非0:failure
 */
- (int)startPreviewAsync:(UIView *)preview;


/**
 开始推流 异步接口
 
 @param pushURL 推流URL
 @return 0:success  非0:failure
 */
- (int)startPushWithURLAsync:(NSString *)pushURL;


/**
 重新推流 异步接口
 
 @return 0:success  非0:failure
 */
- (int)restartPushAsync;


/**
 恢复推流 异步接口
 
 @return 0:success  非0:failure
 */
- (int)resumeAsync;

/* ****************************************************** */



/**
 旋转摄像头
 
 @return 0:success  非0:failure
 */
- (int)switchCamera;


/**
 设置自动对焦
 
 @param autoFocus true:自动对焦 false:手动对焦
 @return 0:success  非0:failure
 */
- (int)setAutoFocus:(bool)autoFocus;


/**
 对焦
 
 @param point 对焦的点
 @param autoFocus 是否自动对焦
 @return 0:success  非0:failure
 */
- (int)focusCameraAtAdjustedPoint:(CGPoint)point autoFocus:(bool)autoFocus;


/**
 缩放
 
 @param zoom 缩放值[0:MaxZoom]
 @return 0:success  非0:failure
 */
- (int)setZoom:(float)zoom;


/**
 获取支持的最大变焦值
 
 @return 最大变焦值
 */
- (float)getMaxZoom;


/**
 获取当前变焦值
 
 @return 当前变焦值
 */
- (int)getCurrentZoom;


/**
 闪光灯开关
 
 @param flash true:打开闪光灯 false:关闭闪光灯
 @return 0:success  非0:failure
 */
- (int)setFlash:(bool)flash;


/**
 设置曝光度
 
 @param value 曝光度
 @return 0:success  非0:failure
 */
- (int)setExposureValue:(float)value;


/**
 推流镜像开关
 
 @param mirror true:打开推流镜像 false:关闭推流镜像
 */
- (void)setPushMirror:(bool)mirror;


/**
 预览镜像开关
 
 @param mirror true:打开预览镜像 false:关闭预览镜像
 */
- (void)setPreviewMirror:(bool)mirror;


/**
 静音推流
 
 @param mute true:静音推流 false:正常推流
 */
- (void)setMute:(bool)mute;


/**
 设置美颜开关

 @param beautyOn true:打开美颜 false:关闭美颜
 */
- (void)setBeautyOn:(bool)beautyOn;


/**
 设置美颜美白度

 @param value 美白度[0  100]
 @return 0:success  非0:failure
 */
- (int)setBeautyWhite:(int)value;


/**
 设置美颜磨皮度

 @param value 磨皮度[0  100]
 @return 0:success  非0:failure
 */
- (int)setBeautyBuffing:(int)value;


/**
 设置美颜亮度
 
 @param value 亮度[0  100]
 @return 0:success  非0:failure
 */
- (int)setBeautyBrightness:(int)value;


/**
 设置美颜红润度
 
 @param value 红润度[0  100]
 @return 0:success  非0:failure
 */
- (int)setBeautyRuddy:(int)value;


/**
 设置美颜饱和度
 
 @param value 饱和度[0  100]
 @return 0:success  非0:failure
 */
- (int)setBeautySaturation:(int)value;


/**
 设置目标码率

 @param targetBitrate 目标码率 [100  5000](Kbps)
 @return 0:success  非0:failure
 */
- (int)setTargetVideoBitrate:(int)targetBitrate;


/**
 设置最小码率

 @param minBitrate 最小码率 [100  5000](Kbps)
 @return 0:success  非0:failure
 */
- (int)setMinVideoBitrate:(int)minBitrate;


/**
 获取是否正在推流

 @return YES:正在推流 NO:未推流
 */
- (BOOL)isPushing;


/**
 获取当前推流URL

 @return 推流URL
 */
- (NSString *)getPushURL;


/**
 获取推流数据统计

 @return 推流数据
 */
- (AlivcLivePushStatsInfo *)getLivePushStatusInfo;



/**
 设置Log开关

 @param open Log开关 default:true
 @return 0:success  非0:failure
 */
- (int)setLog:(bool)open;


/**
 设置Log级别

 @param level Log级别 default:AlivcLivePushLogLevelDebug
 @return 0:success  非0:failure
 */
- (int)setLogLevel:(AlivcLivePushLogLevel)level;

/**
 获取SDK版本号

 @return 版本号
 */
- (NSString *)getSDKVersion;

@end



@protocol AlivcLivePusherErrorDelegate <NSObject>

@required

/**
 系统错误回调

 @param pusher 推流AlivcLivePusher
 @param error error
 */
- (void)onSystemError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error;


/**
 SDK错误回调

 @param pusher 推流AlivcLivePusher
 @param error error
 */
- (void)onSDKError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error;

@end



@protocol AlivcLivePusherNetworkDelegate <NSObject>

@required

/**
 网络差回调

 @param pusher 推流AlivcLivePusher
 */
- (void)onNetworkPoor:(AlivcLivePusher *)pusher;


/**
 推流链接失败

 @param pusher 推流AlivcLivePusher
 @param error error
 */
- (void)onConnectFail:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error;


/**
 网络恢复

 @param pusher 推流AlivcLivePusher
 */
- (void)onConnectRecovery:(AlivcLivePusher *)pusher;


/**
 重连开始回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onReconnectStart:(AlivcLivePusher *)pusher;


/**
 重连成功回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onReconnectSuccess:(AlivcLivePusher *)pusher;


/**
 重连失败回调

 @param pusher 推流AlivcLivePusher
 @param error error
 */
- (void)onReconnectError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error;


/**
 发送数据超时
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onSendDataTimeout:(AlivcLivePusher *)pusher;

@end




@protocol AlivcLivePusherInfoDelegate <NSObject>

@optional

/**
 开始预览回调
 */
- (void)onPreviewStarted:(AlivcLivePusher *)pusher;


/**
 停止预览回调
 */
- (void)onPreviewStoped:(AlivcLivePusher *)pusher;


/**
 渲染第一帧回调

 @param pusher 推流AlivcLivePusher
 */
- (void)onFirstFramePreviewed:(AlivcLivePusher *)pusher;


/**
 推流开始回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onPushStarted:(AlivcLivePusher *)pusher;


/**
 推流暂停回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onPushPauesed:(AlivcLivePusher *)pusher;


/**
 推流恢复回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onPushResumed:(AlivcLivePusher *)pusher;


/**
 重新推流回调

 @param pusher 推流AlivcLivePusher
 */
- (void)onPushRestart:(AlivcLivePusher *)pusher;


/**
 推流停止回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onPushStoped:(AlivcLivePusher *)pusher;

@end
