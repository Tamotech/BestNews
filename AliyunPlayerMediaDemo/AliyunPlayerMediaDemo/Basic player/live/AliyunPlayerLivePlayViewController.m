//
//  AliyunPlayerLivePlayerViewController.m
//  AliyunPlayerDemo
//
//  Created by 王凯 on 2017/9/21.
//  Copyright © 2017年 shiping chen. All rights reserved.
//

#import "AliyunPlayerLivePlayViewController.h"
#import "AliyunPlayMessageShowView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AliyunPlayerSDK/AliyunPlayerSDK.h>
#import "Reachability.h"

#define LIVE_URL  @"http://videolive.xhfmedia.com/AppName/StreamName.m3u8?auth_key=1512393968-0-0-eb9eea1bea4d0a8f400d1e0755ab94cb" //m3u8



@interface AliyunPlayerLivePlayViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UITextField *dropBufferDurationTextField;
@property (weak, nonatomic) IBOutlet UISwitch *muteSwitch;
@property (weak, nonatomic) IBOutlet UISlider *volmeSlider;
@property (weak, nonatomic) IBOutlet UISlider *brightSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scaleSegmentContrl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong)UIActivityIndicatorView *indicationrView;
@property (nonatomic, assign)BOOL isPause;

@property (nonatomic, strong) AliVcMediaPlayer* mediaPlayer;
@property (nonatomic, strong) AliyunPlayMessageShowView *showMessageView;

@end

@implementation AliyunPlayerLivePlayViewController
#pragma mark - 展示log界面
-(AliyunPlayMessageShowView *)showMessageView{
    if (!_showMessageView){
        _showMessageView = [[AliyunPlayMessageShowView alloc] init];
        _showMessageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
        _showMessageView.alpha = 1;
    }
    return _showMessageView;
}

#pragma mark - naviBar
- (void)InitNaviBar{
    NSString *backString = NSLocalizedString(@"Back", nil);
    NSString *logString = NSLocalizedString(@"Log", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:backString style:UIBarButtonItemStylePlain target:self action:@selector(returnButtonItemCliceked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:logString style:UIBarButtonItemStylePlain target:self action:@selector(LogButtonItemCliceked:)];
}

- (void)returnButtonItemCliceked:(UIBarButtonItem*)sender{
    [self.mediaPlayer stop];
    [self.mediaPlayer destroy];
    self.mediaPlayer = nil;
    [self.dropBufferDurationTextField resignFirstResponder];
    [self removePlayerObserver];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)LogButtonItemCliceked:(UIBarButtonItem*)sender{
    self.showMessageView.hidden = NO;
}

#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self InitNaviBar];
    self.indicationrView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicationrView.frame = CGRectMake(0, 0, 100, 100);
    self.indicationrView.center = self.mediaPlayer.view.center;
    self.indicationrView.color = [UIColor clearColor];
    //将这个控件加到父容器中。
    [self.view addSubview:self.indicationrView];
    
    /***************集成部分*******************/
    self.mediaPlayer = [[AliVcMediaPlayer alloc] init];
    [self.mediaPlayer create:self.contentView];
    
    self.mediaPlayer.mediaType = MediaType_AUTO;
    self.mediaPlayer.timeout = 10000;//毫秒
    self.mediaPlayer.dropBufferDuration = [self.dropBufferDurationTextField.text intValue];
    /****************************************/
    
    
    //通知
    [self addPlayerObserver];
    self.startButton.enabled = YES;
    self.stopButton.enabled = NO;
    self.volmeSlider.value = self.mediaPlayer.volume;
    self.brightSlider.value = self.mediaPlayer.brightness;
    self.mediaPlayer.scalingMode = self.scaleSegmentContrl.selectedSegmentIndex;
    self.dropBufferDurationTextField.delegate = self;
    
    self.showMessageView.hidden = YES;
    [self.view addSubview:self.showMessageView];
    // Do any additional setup after loading the view.
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.indicationrView.center = self.mediaPlayer.view.center;
    self.showMessageView.frame = self.view.bounds;
}


- (void)networkStateChange{
    if(!self.mediaPlayer) return;
    [self networkChangePop:YES];
}

-(BOOL) networkChangePop:(BOOL)isShow{
    BOOL ret = NO;
    switch ([self.reachability currentReachabilityStatus]) {
        case NotReachable:
        {
            ret = YES;
            [self stop];
            if (isShow) {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"notreachable", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"clicked_ok", nil), nil];
                [av show];
            }
        }
            break;
        case ReachableViaWiFi:
            
            break;
        case ReachableViaWWAN:
        {
            [self stop];
            ret = YES;
            if (isShow) {
               UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"network", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"alert_show_title_cancel",nil) otherButtonTitles:NSLocalizedString(@"clicked_ok",nil), nil];
                [av show];
            }
        }
            break;
        default:
            break;
    }
    
    NSLog(@"reachability -- %ld",(long)[self.reachability currentReachabilityStatus]);
    return ret;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1://ok
        {
            if(self.mediaPlayer) {
                [self start];
            }
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)becomeActive{
    
    if ([self networkChangePop:NO]) {
        return;
    }
    if (self.isPause) {
        [self resume];
    }
}

- (void)resignActive{
    
    if ([self networkChangePop:NO]) {
        return;
    }
    
    if (self.mediaPlayer){
        if (self.mediaPlayer.isPlaying) {
            [self pause];
        }
        
    }
}
#pragma mark - add NSNotification
-(void)addPlayerObserver
{
    //add network notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnVideoPrepared:)
//                                                 name:AliVcMediaPlayerLoadDidPreparedNotification object:self.mediaPlayer];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnVideoFinish:)
//                                                 name:AliVcMediaPlayerPlaybackDidFinishNotification object:self.mediaPlayer];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnVideoError:)
//                                                 name:AliVcMediaPlayerPlaybackErrorNotification object:self.mediaPlayer];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnSeekDone:)
//                                                 name:AliVcMediaPlayerSeekingDidFinishNotification object:self.mediaPlayer];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnStartCache:)
//                                                 name:AliVcMediaPlayerStartCachingNotification object:self.mediaPlayer];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnEndCache:)
//                                                 name:AliVcMediaPlayerEndCachingNotification object:self.mediaPlayer];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onVideoStop:)
//                                                 name:AliVcMediaPlayerPlaybackStopNotification object:self.mediaPlayer];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onVideoFirstFrame:)
//                                                 name:AliVcMediaPlayerFirstFrameNotification object:self.mediaPlayer];
    
}

#pragma mark - receive
- (void)OnVideoPrepared:(NSNotification *)notification{
    [self.showMessageView addTextString:@"onVideoPrepared"];
}

- (void)onVideoFirstFrame :(NSNotification *)notification{
    [self.indicationrView stopAnimating];
    [self.showMessageView addTextString:@"onVideoFirstFrame"];
    
}
- (void)OnVideoError:(NSNotification *)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSString* errorMsg = [userInfo objectForKey:@"errorMsg"];
    NSNumber* errorCodeNumber = [userInfo objectForKey:@"error"];
    NSLog(@"%@-%@",errorMsg,errorCodeNumber);
    
    [self.showMessageView addTextString:[NSString stringWithFormat:@"OnVideoError:-%@-%@",errorMsg,errorCodeNumber]];
    
}
- (void)OnVideoFinish:(NSNotification *)notification{
    
    [self.showMessageView addTextString:@"OnVideoFinish"];
    
}
- (void)OnSeekDone:(NSNotification *)notification{
    [self.showMessageView addTextString:@"OnSeekDone"];
    
}
- (void)OnStartCache:(NSNotification *)notification{
    [self.showMessageView addTextString:@"OnStartCache"];
    
}
- (void)OnEndCache:(NSNotification *)notification{
    [self.showMessageView addTextString:@"OnEndCache"];
    
}

- (void)onVideoStop:(NSNotification *)notification{
    [self.showMessageView addTextString:@"OnVideoStop"];
    
}

#pragma mark - remove NSNotification
-(void)removePlayerObserver
{
    [self.reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:AliVcMediaPlayerLoadDidPreparedNotification object:self.mediaPlayer];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:AliVcMediaPlayerPlaybackErrorNotification object:self.mediaPlayer];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:AliVcMediaPlayerPlaybackDidFinishNotification object:self.mediaPlayer];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:AliVcMediaPlayerSeekingDidFinishNotification object:self.mediaPlayer];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:AliVcMediaPlayerStartCachingNotification object:self.mediaPlayer];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:AliVcMediaPlayerEndCachingNotification object:self.mediaPlayer];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:AliVcMediaPlayerPlaybackStopNotification object:self.mediaPlayer];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:AliVcMediaPlayerPlaybackStopNotification object:self.mediaPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 201://start
        {
            [self.indicationrView startAnimating];
            
            if ([self networkChangePop:YES]) {
                return;
            }
            
            [self start];
            
            
        }
            break;
        case 202://stop
        {
            [self stop];
        }
            break;
        default:
            break;
    }
}

- (void)start{
    
    AliVcMovieErrorCode err = [self.mediaPlayer prepareToPlay:[NSURL URLWithString:LIVE_URL]];
    if(err != ALIVC_SUCCESS) {
        NSLog(@"play failed,error code is %d",(int)err);
        [self.indicationrView stopAnimating];
        [self.showMessageView addTextString:[NSString stringWithFormat:@"play failed,error code is %d",(int)err]];
        return;
    }
    self.startButton.enabled = NO;
    self.stopButton.enabled = YES;
    [self.mediaPlayer play];
    [self.showMessageView addTextString:NSLocalizedString(@"log_start_play", nil)];
    
}

- (void)pause{
    self.isPause = YES;
    AliVcMovieErrorCode err =[self.mediaPlayer pause];
    if(err != ALIVC_SUCCESS) {
        NSLog(@"pause failed,error code is %d",(int)err);
        [self.showMessageView addTextString:[NSString stringWithFormat:@"pause failed,error code is %d",(int)err]];
        return;
    }
    [self.showMessageView addTextString:NSLocalizedString(@"log_pause_play", nil)];
    
    
}

- (void)resume{
    AliVcMovieErrorCode err = [self.mediaPlayer play];
    if(err != ALIVC_SUCCESS) {
        NSLog(@"resume failed,error code is %d",(int)err);
        [self.showMessageView addTextString:[NSString stringWithFormat:@"resume failed,error code is %d",(int)err]];
        return;
    }
    
    NSString *pauseplay = NSLocalizedString(@"log_resume_play", nil);
    [self.showMessageView addTextString:pauseplay];
    
    
}

- (void)stop{
    
    
    AliVcMovieErrorCode err = [self.mediaPlayer stop];
    if(err != ALIVC_SUCCESS) {
        NSLog(@"stop failed,error code is %d",(int)err);
        [self.showMessageView addTextString:[NSString stringWithFormat:@"stop failed,error code is %d",(int)err]];
        return;
    }
    
    err = [self.mediaPlayer reset];
    if(err != ALIVC_SUCCESS) {
        NSLog(@"reset failed,error code is %d",(int)err);
        [self.showMessageView addTextString:[NSString stringWithFormat:@"reset failed,error code is %d",(int)err]];
        return;
    }
    [self.showMessageView addTextString:NSLocalizedString(@"log_stop_play", nil)];
    self.startButton.enabled = YES;
    self.stopButton.enabled = NO;
    
}


- (IBAction)volumeChanged:(UISlider *)sender {
    self.mediaPlayer.volume = sender.value;
}
- (IBAction)brightChanged:(UISlider *)sender {
    self.mediaPlayer.brightness = sender.value;
}
- (IBAction)muteChanged:(UISwitch *)sender {
    self.mediaPlayer.muteMode = sender.isOn;
}
- (IBAction)displayModeChanged:(UISegmentedControl *)sender {
    self.mediaPlayer.scalingMode = sender.selectedSegmentIndex;
}
- (IBAction)dropBufferDurationTextField:(UITextField *)sender {
    
    
}
- (IBAction)viewTouchControl:(UIControl *)sender {
    
    [self.dropBufferDurationTextField resignFirstResponder];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.scrollView setContentOffset:CGPointMake(0, self.volmeSlider.frame.origin.y) animated:YES];
    self.scrollView.bouncesZoom = NO;//scroll is no
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.mediaPlayer.dropBufferDuration = [self.dropBufferDurationTextField.text intValue];
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
