//
//  AlivcPushConfigViewController.m
//  AlivcLiveCaptureDev
//
//  Created by lyz on 2017/9/20.
//  Copyright © 2017年 Alivc. All rights reserved.
//

#import "AlivcLivePushConfigViewController.h"
#import "AlivcParamTableViewCell.h"
#import "AlivcParamModel.h"
#import "AlivcWatermarkSettingView.h"
#import "AlivcLivePusherViewController.h"
#import "AlivcQRCodeViewController.h"
#import "PrefixHeader.pch"

#import <AlivcLivePusher/AlivcLivePusherHeader.h>

@interface AlivcLivePushConfigViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *publisherURLTextField;
@property (nonatomic, strong) UIButton *QRCodeButton;
@property (nonatomic, strong) UITableView *paramTableView;
@property (nonatomic, strong) UIButton *publisherButton;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) AlivcWatermarkSettingView *waterSettingView;

@property (nonatomic, assign) BOOL isUseAsync; // 是否使用异步接口
@property (nonatomic, assign) BOOL isUseWatermark; // 是否使用水印

@property (nonatomic, strong) AlivcLivePushConfig *pushConfig;

@end

@implementation AlivcLivePushConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupParamData];
    [self setupSubviews];
    
    self.pushConfig = [[AlivcLivePushConfig alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)setupSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"pusher_setting", nil);

    CGFloat retractX = 10;
    CGFloat viewWidth = AlivcScreenWidth - retractX * 2;
    
    self.publisherURLTextField = [[UITextField alloc] init];
    self.publisherURLTextField.frame = CGRectMake(retractX, 70, viewWidth - 100, AlivcSizeHeight(40));
    self.publisherURLTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.publisherURLTextField.placeholder = NSLocalizedString(@"input_tips", nil);
    self.publisherURLTextField.font = [UIFont systemFontOfSize:14.f];
    self.publisherURLTextField.clearsOnBeginEditing = NO;
    self.publisherURLTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.publisherURLTextField.text = AlivcTextPushURL;
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.frame = CGRectMake(retractX,
                                   CGRectGetMaxY(self.publisherURLTextField.frame) + 2,
                                   CGRectGetWidth(self.view.frame),
                                   AlivcSizeHeight(10));
    noticeLabel.textAlignment = NSTextAlignmentLeft;
    noticeLabel.font = [UIFont systemFontOfSize:12.f];
    noticeLabel.textColor = AlivcRGB(175, 175, 175);
    noticeLabel.numberOfLines = 0;
    noticeLabel.text = NSLocalizedString(@"push_url_notice_text", nil);
    
    self.QRCodeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.QRCodeButton.frame = CGRectMake(CGRectGetMaxX(self.publisherURLTextField.frame)+5,
                                         CGRectGetMinY(self.publisherURLTextField.frame),
                                         95,
                                         CGRectGetHeight(self.publisherURLTextField.frame));
    [self.QRCodeButton setImage:[UIImage imageNamed:@"QR"] forState:(UIControlStateNormal)];
    self.QRCodeButton.layer.masksToBounds = YES;
    self.QRCodeButton.layer.cornerRadius = 10;
    [self.QRCodeButton addTarget:self action:@selector(QRCodeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.publisherButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.publisherButton.frame = CGRectMake(0, 0, 150, 50);
    self.publisherButton.center = CGPointMake(AlivcScreenWidth / 2, AlivcScreenHeight - 30);
    self.publisherButton.backgroundColor = [UIColor blueColor];
    [self.publisherButton setTitle:NSLocalizedString(@"start_button", nil) forState:(UIControlStateNormal)];
    self.publisherButton.layer.masksToBounds = YES;
    self.publisherButton.layer.cornerRadius = 10;
    [self.publisherButton addTarget:self action:@selector(publiherButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.paramTableView = [[UITableView alloc] init];
    self.paramTableView.frame = CGRectMake(retractX,
                                           CGRectGetMaxY(noticeLabel.frame) + 5,
                                           viewWidth,
                                           CGRectGetMinY(self.publisherButton.frame) - CGRectGetMaxY(noticeLabel.frame) - 10);
    self.paramTableView.delegate = (id)self;
    self.paramTableView.dataSource = (id)self;
    self.paramTableView.separatorStyle = NO;
    [self.paramTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:nil];
    
    self.waterSettingView = [[AlivcWatermarkSettingView alloc] initWithFrame:(CGRectMake(0, AlivcScreenHeight - AlivcSizeHeight(330), AlivcScreenWidth, AlivcSizeHeight(330)))];
    
    [self.view addSubview:self.publisherURLTextField];
    [self.view addSubview:noticeLabel];
    [self.view addSubview:self.QRCodeButton];
    [self.view addSubview:self.publisherButton];
    [self.view addSubview:self.paramTableView];
    
}



#pragma mark - Data
- (void)setupParamData {
    self.isUseWatermark = YES;
    self.isUseAsync = YES;
    
    AlivcParamModel *model1 = [[AlivcParamModel alloc] init];
    model1.title = NSLocalizedString(@"resolution_label", nil);
    model1.placeHolder = @"540P";
    model1.infoText = @"540P";
    model1.defaultValue = 4.0/6.0;
    model1.reuseId = AlivcParamModelReuseCellSlider;
    model1.sliderBlock = ^(int value){
        self.pushConfig.resolution = value;
    };
    
    AlivcParamModel *model2 = [[AlivcParamModel alloc] init];
    model2.title = NSLocalizedString(@"target_bitrate", nil);
    model2.placeHolder = @"800";
    model2.infoText = @"Kbps";
    model2.reuseId = AlivcParamModelReuseCellInput;
    model2.valueBlock = ^(int value) {
        self.pushConfig.targetVideoBitrate = value;
    };
    
    AlivcParamModel *model3 = [[AlivcParamModel alloc] init];
    model3.title = NSLocalizedString(@"min_bitrate", nil);
    model3.placeHolder = @"200";
    model3.infoText = @"Kbps";
    model3.reuseId = AlivcParamModelReuseCellInput;
    model3.valueBlock = ^(int value) {
        self.pushConfig.minVideoBitrate = value;
    };
    
    AlivcParamModel *model4 = [[AlivcParamModel alloc] init];
    model4.title = NSLocalizedString(@"initial_bitrate", nil);
    model4.placeHolder = @"800";
    model4.infoText = @"Kbps";
    model4.reuseId = AlivcParamModelReuseCellInput;
    model4.valueBlock = ^(int value) {
        self.pushConfig.initialVideoBitrate = value;
    };
    
    AlivcParamModel *model5 = [[AlivcParamModel alloc] init];
    model5.title = NSLocalizedString(@"audio_sampling_rate", nil);
    model5.placeHolder = @"32kHz";
    model5.infoText = @"32kHz";
    model5.defaultValue = 1.0/2.0;
    model5.reuseId = AlivcParamModelReuseCellSlider;
    model5.sliderBlock = ^(int value) {
        self.pushConfig.audioSampleRate = value;
    };
    
    AlivcParamModel *model6 = [[AlivcParamModel alloc] init];
    model6.title = NSLocalizedString(@"captrue_fps", nil);
    model6.segmentTitleArray = @[@"8",@"10",@"12",@"15",@"20",@"25",@"30"];
    model6.defaultValue = 3;
    model6.reuseId = AlivcParamModelReuseCellSegment;
    model6.segmentBlock = ^(int value) {
        self.pushConfig.fps = value;
    };
    
    AlivcParamModel *model7 = [[AlivcParamModel alloc] init];
    model7.title = NSLocalizedString(@"min_fps", nil);
    model7.segmentTitleArray = @[@"8",@"10",@"12",@"15",@"20",@"25",@"30"];
    model7.defaultValue = 0;
    model7.reuseId = AlivcParamModelReuseCellSegment;
    model7.segmentBlock = ^(int value) {
        self.pushConfig.minFps = value;
    };
    
    AlivcParamModel *model8 = [[AlivcParamModel alloc] init];
    model8.title = NSLocalizedString(@"keyframe_interval", nil);
    model8.segmentTitleArray = @[@"1s",@"2s",@"3s",@"4s",@"5s"];
    model8.defaultValue = 1.0;
    model8.reuseId = AlivcParamModelReuseCellSegment;
    model8.segmentBlock = ^(int value) {
        self.pushConfig.videoEncodeGop = value;
    };

    AlivcParamModel *model9 = [[AlivcParamModel alloc] init];
    model9.title = NSLocalizedString(@"reconnect_duration", nil);
    model9.placeHolder = @"1000";
    model9.infoText = @"ms";
    model9.reuseId = AlivcParamModelReuseCellInput;
    model9.valueBlock = ^(int value) {
        self.pushConfig.connectRetryInterval = value;
    };
    
    AlivcParamModel *model10 = [[AlivcParamModel alloc] init];
    model10.title = NSLocalizedString(@"reconnect_times", nil);
    model10.placeHolder = @"5";
    model10.infoText = @"次";
    model10.reuseId = AlivcParamModelReuseCellInput;
    model10.valueBlock = ^(int value) {
        self.pushConfig.connectRetryCount = value;
    };

    AlivcParamModel *model11 = [[AlivcParamModel alloc] init];
    model11.title = NSLocalizedString(@"landscape_model", nil);
    model11.segmentTitleArray = @[@"Portrait",@"HomeLeft",@"HomeRight"];
    model11.defaultValue = 0;
    model11.reuseId = AlivcParamModelReuseCellSegment;
    model11.segmentBlock = ^(int value) {
        self.pushConfig.orientation = value;
    };
    
    AlivcParamModel *model12 = [[AlivcParamModel alloc] init];
    model12.title = NSLocalizedString(@"sound_track", nil);
    model12.segmentTitleArray = @[NSLocalizedString(@"single_track", nil),NSLocalizedString(@"dual_track", nil)];
    model12.defaultValue = 1.0;
    model12.reuseId = AlivcParamModelReuseCellSegment;
    model12.segmentBlock = ^(int value) {
        self.pushConfig.audioChannel = value;
    };

    AlivcParamModel *model13 = [[AlivcParamModel alloc] init];
    model13.title = NSLocalizedString(@"push_mirror", nil);
    model13.defaultValue = 0;
    model13.titleAppose = NSLocalizedString(@"preview_mirror", nil);
    model13.defaultValueAppose = 0;
    model13.reuseId = AlivcParamModelReuseCellSwitch;
    model13.switchBlock = ^(int index, BOOL open) {
        if (index == 0) {
            self.pushConfig.pushMirror = open?true:false;
        } else {
            self.pushConfig.previewMirror = open?true:false;
        }
    };

    
    AlivcParamModel *model14 = [[AlivcParamModel alloc] init];
    model14.title = NSLocalizedString(@"audio_only_push_streaming", nil);
    model14.defaultValue = 0;
    model14.titleAppose = NSLocalizedString(@"hardware_encode", nil);
    model14.defaultValueAppose = 1.0;
    model14.reuseId = AlivcParamModelReuseCellSwitch;
    model14.switchBlock = ^(int index, BOOL open) {
        if (index == 0) {
            self.pushConfig.audioOnly = open?true:false;
        } else {
            self.pushConfig.videoEncoderMode = open?AlivcLivePushVideoEncoderModeHard:AlivcLivePushVideoEncoderModeSoft;
        }
    };
    
    AlivcParamModel *model15 = [[AlivcParamModel alloc] init];
    model15.title = NSLocalizedString(@"auto_focus", nil);
    model15.defaultValue = 1.0;
    model15.titleAppose = NSLocalizedString(@"flash", nil);
    model15.defaultValueAppose = 0;
    model15.reuseId = AlivcParamModelReuseCellSwitch;
    model15.switchBlock = ^(int index, BOOL open) {
        if (index == 0) {
            self.pushConfig.autoFocus = open?true:false;
        } else {
            self.pushConfig.flash = open?true:false;
        }
    };
    
    AlivcParamModel *model16 = [[AlivcParamModel alloc] init];
    model16.title = NSLocalizedString(@"beauty_button", nil);
    model16.defaultValue = 1.0;
    model16.titleAppose = NSLocalizedString(@"front_camera", nil);
    model16.defaultValueAppose = 1.0;
    model16.reuseId = AlivcParamModelReuseCellSwitch;
    model16.switchBlock = ^(int index, BOOL open) {
        if (index == 0) {
            self.pushConfig.beautyOn = open?true:false;
        } else {
            self.pushConfig.cameraType = open?AlivcLivePushCameraTypeFront:AlivcLivePushCameraTypeBack;
        }
    };
    
    AlivcParamModel *model17 = [[AlivcParamModel alloc] init];
    model17.title = NSLocalizedString(@"asynchronous_interface", nil);
    model17.reuseId = AlivcParamModelReuseCellSwitch;
    model17.defaultValue = 1.0;
    model17.switchBlock = ^(int index, BOOL open) {
        if (index == 0) {
            self.isUseAsync = open;
        }
    };

    AlivcParamModel *model18 = [[AlivcParamModel alloc] init];
    model18.title = NSLocalizedString(@"watermark", nil);
    model18.reuseId = AlivcParamModelReuseCellSwitchButton;
    model18.defaultValue = 1.0;
    model18.infoText = NSLocalizedString(@"watermark_setting", nil);
    model18.switchBlock = ^(int index, BOOL open) {
        self.isUseWatermark = open;
    };
    model18.switchButtonBlock = ^(){
        [self.view addSubview:self.waterSettingView];
    };
    
    AlivcParamModel *model23 = [[AlivcParamModel alloc] init];
    model23.title = NSLocalizedString(@"beauty_white", nil);
    model23.placeHolder = @"50";
    model23.infoText = @"50";
    model23.defaultValue = 0.5;
    model23.reuseId = AlivcParamModelReuseCellSlider;
    model23.sliderBlock = ^(int value){
        self.pushConfig.beautyWhite = value;
    };
    
    AlivcParamModel *model24 = [[AlivcParamModel alloc] init];
    model24.title = NSLocalizedString(@"beauty_skin_smooth", nil);
    model24.placeHolder = @"50";
    model24.infoText = @"50";
    model24.defaultValue = 0.5;
    model24.reuseId = AlivcParamModelReuseCellSlider;
    model24.sliderBlock = ^(int value){
        self.pushConfig.beautyBuffing = value;
    };

    
    AlivcParamModel *model25 = [[AlivcParamModel alloc] init];
    model25.title = NSLocalizedString(@"beaut_brightness", nil);
    model25.placeHolder = @"50";
    model25.infoText = @"50";
    model25.defaultValue = 0.5;
    model25.reuseId = AlivcParamModelReuseCellSlider;
    model25.sliderBlock = ^(int value){
        self.pushConfig.beautyBrightness = value;
    };

    
    AlivcParamModel *model26 = [[AlivcParamModel alloc] init];
    model26.title = NSLocalizedString(@"beauty_ruddy", nil);
    model26.placeHolder = @"20";
    model26.infoText = @"20";
    model26.defaultValue = 0.2;
    model26.reuseId = AlivcParamModelReuseCellSlider;
    model26.sliderBlock = ^(int value){
        self.pushConfig.beautyRuddy = value;
    };

    AlivcParamModel *model27 = [[AlivcParamModel alloc] init];
    model27.title = NSLocalizedString(@"beauty_saturation", nil);
    model27.placeHolder = @"0";
    model27.infoText = @"0";
    model27.defaultValue = 0;
    model27.reuseId = AlivcParamModelReuseCellSlider;
    model27.sliderBlock = ^(int value){
        self.pushConfig.beautySaturation = value;
    };
    

    self.dataArray = [NSArray arrayWithObjects:model1, model2, model3, model4, model5, model6, model7, model8, model9, model10, model11, model12, model13, model14, model15, model16, model17, model18, model23, model24, model25, model26, model27, nil];
}

- (NSString *)getWatermarkPathWithIndex:(NSInteger)index {
    
    NSString *watermarkBundlePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"watermark"] ofType:@"png"];
    
    return watermarkBundlePath;
}

#pragma mark - TableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlivcParamModel *model = self.dataArray[indexPath.row];
    if (model) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"AlivcLivePushTableViewIdentifier%ld", (long)indexPath.row];
        AlivcParamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[AlivcParamTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell configureCellModel:model];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.waterSettingView isEditing]) {
        [self.waterSettingView removeFromSuperview];
    }
    [self.view endEditing:YES];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark - TO PublisherVC
- (void)publiherButtonAction:(UIButton *)sender {
    
    NSString *pushURLString = self.publisherURLTextField.text;
    if (!pushURLString) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入推流地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }

    // 更新水印坐标
    if (self.isUseWatermark) {
        for (int index = 0; index <= 3; index++) {
            AlivcWatermarkSettingStruct watermarkSetting = [self.waterSettingView getWatermarkSettingsWithCount:index];
            NSString *watermarkPath = [self getWatermarkPathWithIndex:index];
            [self.pushConfig addWatermarkWithPath:watermarkPath
                                  watermarkCoordX:watermarkSetting.watermarkX
                                  watermarkCoordY:watermarkSetting.watermarkY
                                   watermarkWidth:watermarkSetting.watermarkWidth];
        }
    }
    
    AlivcLivePusherViewController *publisherVC = [[AlivcLivePusherViewController alloc] init];
    publisherVC.pushURL = self.publisherURLTextField.text;
    publisherVC.pushConfig = self.pushConfig;
    publisherVC.isUseAsyncInterface = self.isUseAsync;
    [self presentViewController:publisherVC animated:YES completion:nil];
    
}


#pragma mark - TO QRCodeVC
- (void)QRCodeButtonAction:(UIButton *)sender {
 
    [self.view endEditing:YES];
    AlivcQRCodeViewController *QRController = [[AlivcQRCodeViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    QRController.backValueBlock = ^(NSString *value) {
      
        if (value) {
            weakSelf.publisherURLTextField.text = value;
        }
    };
    [self.navigationController pushViewController:QRController animated:YES];
}


@end
