//
//  AlivcLivePushConfig.h
//  AlivcLiveCaptureLib
//
//  Created by TripleL on 2017/9/26.
//  Copyright © 2017年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlivcLivePushConstants.h"


/**
 推流配置类
 */
@interface AlivcLivePushConfig : NSObject


/**
 分辨率
 * 默认 : AlivcLivePushDefinition540P
 */
@property (nonatomic, assign) AlivcLivePushResolution resolution;


/**
 视频采集帧率
 * 默认 : AlivcLivePushFPS15
 * 单位 : Frames per Second
 */
@property (nonatomic, assign) AlivcLivePushFPS fps;


/**
 最小视频采集帧率
 * 默认 : AlivcLivePushFPS8
 * 单位 : Frames per Second
 * 不可大于 视频采集帧率fps
 */
@property (nonatomic, assign) AlivcLivePushFPS minFps;


/**
 目标视频编码码率
 * 默认 : 800
 * 范围 : [100,1500]
 * 单位 : Kbps
 */
@property (nonatomic, assign) int targetVideoBitrate;


/**
 最小视频编码码率
 * 默认 : 200
 * 范围 : [100,1500]
 * 单位 : Kbps
 */
@property (nonatomic, assign) int minVideoBitrate;


/**
 初始视频编码码率
 * 默认 : 800
 * 范围 : [100,1500]
 * 单位 : Kbps
 */
@property (nonatomic, assign) int initialVideoBitrate;


/**
 音频采样率
 * 默认 : AlivcLivePushAudioSampleRate32000
 */
@property (nonatomic, assign) AlivcLivePushAudioSampleRate audioSampleRate;


/**
 声道数
 * 默认 : AlivcLivePushAudioChannel_2 单声道
 */
@property (nonatomic, assign) AlivcLivePushAudioChannel audioChannel;


/**
 关键帧间隔
 * 默认 : AlivcLivePushVideoEncodeGOP_2
 * 单位 : s
 */
@property (nonatomic, assign) AlivcLivePushVideoEncodeGOP videoEncodeGop;


/**
 重连次数
 * 默认 : 5
 * 范围 : [0,100]
 */
@property (nonatomic, assign) int connectRetryCount;


/**
 重连时长
 * 默认 : 1000
 * 范围 : (0,10000]
 * 单位 : ms
 */
@property (nonatomic, assign) float connectRetryInterval;


/**
 推流方向 : 竖屏、90度横屏、270度横屏
 * 默认 : AlivcLivePushOrientationPortrait
 */
@property (nonatomic, assign) AlivcLivePushOrientation orientation;


/**
 摄像头类型
 * 默认 : AlivcLivePushCameraTypeFront
 */
@property (nonatomic, assign)AlivcLivePushCameraType cameraType;


/**
 推流镜像
 * 默认 : false 关闭镜像
 */
@property (nonatomic, assign) bool pushMirror;


/**
 预览镜像
 * 默认 : false 关闭镜像
 */
@property (nonatomic, assign) bool previewMirror;


/**
 纯音频推流
 * 默认 : false
 */
@property (nonatomic, assign) bool audioOnly;


/**
 自动聚焦
 * 默认 : true
 */
@property (nonatomic, assign) bool autoFocus;


/**
 是否打开美颜
 * 默认 : true
 */
@property (nonatomic, assign) bool beautyOn;


/**
 美颜 美白参数
 * 默认 : 50
 * 范围 : [0,100]
 */
@property (nonatomic, assign) int beautyWhite;


/**
 美颜 磨皮参数
 * 默认 : 50
 * 范围 : [0,100]
 */
@property (nonatomic, assign) int beautyBuffing;


/**
 美颜 亮度参数
 * 默认 : 50
 * 范围 : [0,100]
 */
@property (nonatomic, assign) int beautyBrightness;


/**
 美颜 红润参数
 * 默认 : 20
 * 范围 : [0,100]
 */
@property (nonatomic, assign) int beautyRuddy;


/**
 美颜 饱和度参数
 * 默认 : 0
 * 范围 : [0,100]
 */
@property (nonatomic, assign) int beautySaturation;


/**
 是否开启闪光灯
 * 默认 : false
 */
@property (nonatomic, assign) bool flash;


/**
 视频编码模式
 * 默认 : AlivcLivePushVideoEncoderModeHard
 */
@property (nonatomic, assign) AlivcLivePushVideoEncoderMode videoEncoderMode;



/**
 init 分辨率 其余值为默认值
 
 @param resolution 推流分辨率
 @return self
 */
- (instancetype)initWithResolution:(AlivcLivePushResolution)resolution;


/**
 添加水印 最多支持3个水印

 @param path 水印路径
 @param coordX 水印左上顶点x的相对坐标 [0,1]
 @param coordY 水印左上顶点y的相对坐标 [0,1]
 @param width 水印的相对宽度 (水印会根据水印图片实际大小和水印宽度等比缩放) (0,1]
 */
- (void)addWatermarkWithPath:(NSString *)path
             watermarkCoordX:(CGFloat)coordX
             watermarkCoordY:(CGFloat)coordY
              watermarkWidth:(CGFloat)width;


/**
 获取全部水印

 * key:watermarkPath value:水印图片路径
 * key:watermarkCoordX value:x值
 * key:watermarkCoordY value:y值
 * key:watermarkWidth value:width值
 @return 全部水印配置数组
 */
- (NSArray<NSDictionary *> *)getAllWatermarks;


/**
 获取推流宽高具体数值

 @return 推流宽高Rect
 */
- (CGSize)getPushResolution;

@end
