//
//  AliyunPlayerMediaUIDemoViewController.m
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/8/21.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import "AliyunPlayerMediaUIDemoViewController.h"
#import <AliyunVodPlayerViewSDK/AliyunVodPlayerViewSDK.h>
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

@interface AliyunPlayerMediaUIDemoViewController ()<AliyunVodPlayerViewDelegate>
@property (nonatomic,strong)AliyunVodPlayerView *playerView;
@property (nonatomic,copy)NSString *tempPlayauth;
@property (nonatomic, assign)BOOL isLock;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)BOOL isStatusHidden;

@end

@implementation AliyunPlayerMediaUIDemoViewController
-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGFloat width = 0;
    CGFloat height = 0;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ) {
        width = SCREEN_WIDTH;
        height = SCREEN_WIDTH * 9 / 16.0;
    }else{
        width = SCREEN_HEIGHT;
        height = SCREEN_HEIGHT * 9 / 16.0;
    }
    
    /****************UI播放器集成内容**********************/
    self.playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,44, width, height) andSkin:AliyunVodPlayerViewSkinRed];
    
    //测试封面地址，请使用https 地址。
//    self.playerView.coverUrl = [NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4046104436,1338839104&fm=27&gp=0.jpg"];
//    [self.playerView setTitle:@"1234567890"];
    self.playerView.circlePlay = YES;
    [self.playerView setDelegate:self];
//    [self.playerView setAutoPlay:YES];
    
    /*
     *备注：isLockScreen 会锁定，播放器界面尺寸。
           isLockPortrait yes：竖屏全屏；no：横屏全屏;
           isLockScreen对isLockPortrait无效。
         - (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView lockScreen:(BOOL)isLockScreen此方法在isLockPortrait==yes时，返回的islockscreen总是yes；
          isLockScreen和isLockPortrait，因为播放器时UIView，是否旋转需要配合UIViewController来控制物理旋转。
         假设：支持竖屏全屏
             self.playerView.isLockPortrait = YES;
             self.playerView.isLockScreen = NO;
             self.isLock = self.playerView.isLockScreen||self.playerView.isLockPortrait?YES:NO;
     
             支持横屏全屏
             self.playerView.isLockPortrait = NO;
             self.playerView.isLockScreen = NO;
             self.isLock = self.playerView.isLockScreen||self.playerView.isLockPortrait?YES:NO;
     
             锁定屏幕
             self.playerView.isLockPortrait = NO;
             self.playerView.isLockScreen = YES;
             self.isLock = self.playerView.isLockScreen||self.playerView.isLockPortrait?YES:NO;
     
             self.isLock时来判定UIViewController 是否支持物理旋转。如果viewcontroller在navigationcontroller中，需要添加子类重写navigationgController中的 以下方法，根据实际情况做判定 。
     */
    self.playerView.isLockScreen = NO;
    self.playerView.isLockPortrait = 1;
    self.isLock = self.playerView.isLockScreen||self.playerView.isLockPortrait?YES:NO;
    
    
    //播放本地视频
    NSString *path = [[NSBundle mainBundle] pathForResource:@"set.mp4" ofType:nil];
//    [self.playerView playViewPrepareWithURL:[NSURL fileURLWithPath:path]];
    //播放器播放方式
    [self.playerView playViewPrepareWithVid:self.videoId accessKeyId:self.accessKeyId accessKeySecret:self.accessKeySecret securityToken:self.securityToken];
    
    NSLog(@"%@",[self.playerView getSDKVersion]);
    [self.view addSubview:self.playerView];
    /**************************************/
    
    //边下边播缓存沙箱位置
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [pathArray objectAtIndex:0];
    //maxsize:单位 mb    maxDuration:单位秒
    [self.playerView setPlayingCache:NO saveDir:docDir maxSize:300 maxDuration:10000];
    
    //查看缓存文件时打开。
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerun) userInfo:nil repeats:YES];
}

//适配iphone x 界面问题，没有在 viewSafeAreaInsetsDidChange 这里做处理 ，主要 旋转监听在 它之后获取。
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    UIDevice *device = [UIDevice currentDevice] ;
    switch (device.orientation) {//device.orientation
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortraitUpsideDown:{
            if (self.isStatusHidden) {
                CGRect frame = self.playerView.frame;
                frame.origin.x = VIEWSAFEAREAINSETS(self.view).left;
                frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
                frame.size.width = SCREEN_WIDTH-VIEWSAFEAREAINSETS(self.view).left*2;
                frame.size.height = SCREEN_HEIGHT-VIEWSAFEAREAINSETS(self.view).bottom-VIEWSAFEAREAINSETS(self.view).top;
                self.playerView.frame = frame;
            }else{
                CGRect frame = self.playerView.frame;
                frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
                //竖屏全屏时 isStatusHidden 来自是否 旋转回调。
                if (self.playerView.isLockPortrait&&self.isStatusHidden) {
                    frame.size.height = SCREEN_HEIGHT- VIEWSAFEAREAINSETS(self.view).top- VIEWSAFEAREAINSETS(self.view).bottom;
                }
                self.playerView.frame = frame;
            }
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            //
            CGRect frame = self.playerView.frame;
            frame.origin.x = VIEWSAFEAREAINSETS(self.view).left;
            frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
            frame.size.width = SCREEN_WIDTH-VIEWSAFEAREAINSETS(self.view).left*2;
            frame.size.height = SCREEN_HEIGHT-VIEWSAFEAREAINSETS(self.view).bottom;
            self.playerView.frame = frame;
        }
            
            break;
        case UIDeviceOrientationPortrait:
        {
            //
            CGRect frame = self.playerView.frame;
            frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
            //竖屏全屏时 isStatusHidden 来自是否 旋转回调。
            if (self.playerView.isLockPortrait&&self.isStatusHidden) {
                frame.size.height = SCREEN_HEIGHT- VIEWSAFEAREAINSETS(self.view).top- VIEWSAFEAREAINSETS(self.view).bottom;
            }
            self.playerView.frame = frame;
            
        }
            
            break;
        default:
            
            break;
    }

#else
#endif
    
    
}


#pragma mark - AliyunVodPlayerViewDelegate
- (void)onBackViewClickWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView{
    if (self.playerView != nil) {
        [self.playerView stop];
        [self.playerView releasePlayer];
        [self.playerView removeFromSuperview];
        self.playerView = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onPause:(NSTimeInterval)currentPlayTime{
    
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onResume:(NSTimeInterval)currentPlayTime{
    
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onStop:(NSTimeInterval)currentPlayTime{
    
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onSeekDone:(NSTimeInterval)seekDoneTime{
    
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView lockScreen:(BOOL)isLockScreen{
    self.isLock = isLockScreen;
}


- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onVideoQualityChanged:(AliyunVodPlayerVideoQuality)quality{
    
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView fullScreen:(BOOL)isFullScreen{
    NSLog(@"isfullScreen --%d",isFullScreen);

    self.isStatusHidden = isFullScreen  ;
    [self setNeedsStatusBarAppearanceUpdate];
   
}

/**
 * 功能：获取媒体信息
 */
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView mediaInfo:(AliyunVodPlayerVideo*)mediaInfo{
    
}

-(void)timerun{
    [self fileSize];
}

-(void)fileSize{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [pathArray objectAtIndex:0];
    NSString *filePath = docDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:docDir isDirectory:nil]){
        NSArray *subpaths = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
        for (NSString *subpath in subpaths) {
            
            NSString *fullSubpath = [filePath stringByAppendingPathComponent:subpath];
            if ([subpath hasSuffix:@".mp4"]) {
                long long fileSize =  [fileManager attributesOfItemAtPath:fullSubpath error:nil].fileSize;
                NSLog(@"fileSie ---- %lld",fileSize);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 锁屏功能
/**
 * 说明：播放器父类是UIView。
 屏幕锁屏方案需要用户根据实际情况，进行开发工作；
 如果viewcontroller在navigationcontroller中，需要添加子类重写navigationgController中的 以下方法，根据实际情况做判定 。
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    if (self.isLock) {
        return toInterfaceOrientation = UIInterfaceOrientationPortrait;
    }else{
        return YES;
    }
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    return !self.isLock;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (self.isLock) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
    }
}

-(BOOL)prefersStatusBarHidden
{
    return self.isStatusHidden;

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
