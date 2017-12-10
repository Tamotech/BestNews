//
//  AlivcPublisherView.m
//  AlivcLiveCaptureDev
//
//  Created by TripleL on 17/7/10.
//  Copyright © 2017年 Alivc. All rights reserved.
//

#import "AlivcPublisherView.h"
#import "AlivcDebugChartView.h"
#import "AlivcDebugTextView.h"
#import "AlivcGuidePageView.h"
#import "PrefixHeader.pch"

#import <AlivcLivePusher/AlivcLivePusherHeader.h>

#define viewWidth AlivcSizeWidth(58)
#define viewHeight viewWidth/4*3
#define topViewButtonSize AlivcSizeWidth(35)

@interface AlivcPublisherView ()

@property (nonatomic, strong) AlivcGuidePageView *guideView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *muteButton;
@property (nonatomic, strong) UIButton *beautySettingButton;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *pushButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *restartButton;
@property (nonatomic, strong) UIButton *moreSettingButton;

@property (nonatomic, strong) UIView *beautySettingView;

@property (nonatomic, strong) UIView *moreSettingView;

@property (nonatomic, strong) AlivcDebugChartView *debugChartView;
@property (nonatomic, strong) AlivcDebugTextView *debugTextView;

@property (nonatomic, assign) BOOL isBeautySettingShow;
@property (nonatomic, assign) BOOL isMoreSettingShow;
@property (nonatomic, assign) BOOL isKeyboardEdit;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) AlivcLivePushConfig *config;

@end

@implementation AlivcPublisherView


- (instancetype)initWithFrame:(CGRect)frame config:(AlivcLivePushConfig *)config {
    
    self = [super initWithFrame:frame];
    if (self) {
        _config = config;
        [self setupSubviews];
        [self addNotifications];
    }
    return self;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void)setupSubviews {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:AlivcUserDefaultsIndentifierFirst]) {
        [self setupGuideView];
    }
    
    
    [self setupTopViews];
    
    [self setupBottomViews];
    
    [self setupInfoLabel];
    
    [self setupDebugViews];
    
    [self addGesture];
    
    self.currentIndex = 1;
}


- (void)setupGuideView {
    
    self.guideView = [[AlivcGuidePageView alloc] initWithFrame:CGRectMake(20, 0, self.bounds.size.width - 40, self.bounds.size.height/6)];
    self.guideView.center = self.center;
    [self addSubview:self.guideView];
}


- (void)setupTopViews {
    
    self.topView = [[UIView alloc] init];
    self.topView.frame = CGRectMake(0, 20, CGRectGetWidth(self.frame), viewHeight);
    [self addSubview: self.topView];
    
    CGFloat retractX = 5;
    
    self.backButton = [self setupButtonWithFrame:(CGRectMake(retractX, 0, topViewButtonSize, topViewButtonSize))
                                     normalImage:[UIImage imageNamed:@"back"]
                                     selectImage:nil
                                          action:@selector(backButtonAction:)];
    [self.topView addSubview: self.backButton];
    
    self.switchButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetWidth(self.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
                                       normalImage:[UIImage imageNamed:@"camera_id"]
                                       selectImage:nil
                                            action:@selector(switchButtonAction:)];
    [self.topView addSubview:self.switchButton];
    
    self.flashButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetMinX(self.switchButton.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
                                                   normalImage:[UIImage imageNamed:@"camera_flash_close"]
                                                   selectImage:[UIImage imageNamed:@"camera_flash_on"]
                                                   action:@selector(flashButtonAction:)];
    [self.topView addSubview:self.flashButton];
    [self.flashButton setSelected:self.config.flash];
    [self.flashButton setEnabled:self.config.cameraType==AlivcLivePushCameraTypeFront?NO:YES];
    
    self.muteButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetMinX(self.flashButton.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
                                     normalImage:[UIImage imageNamed:@"volume_on"]
                                     selectImage:[UIImage imageNamed:@"volume_off"]
                                          action:@selector(pushVideoButtonAction:)];
    [self.topView addSubview: self.muteButton];
    
    self.beautySettingButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetMinX(self.muteButton.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
                                              normalImage:[UIImage imageNamed:@"record_beauty_on"]
                                              selectImage:nil
                                                   action:@selector(beautySettingButtonAction:)];
    [self.topView addSubview: self.beautySettingButton];
    self.isBeautySettingShow = NO;
}


- (void)setupBottomViews {
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0,
                                       CGRectGetHeight(self.frame) - viewHeight,
                                       CGRectGetWidth(self.frame),
                                       viewHeight);
    [self addSubview: self.bottomView];
    
    CGFloat buttonCount = 5;
    CGFloat retractX = (CGRectGetWidth(self.bottomView.frame) - viewWidth * 5) / (buttonCount + 1);
    
    self.previewButton = [self setupButtonWithFrame:(CGRectMake(retractX, 0, viewWidth, viewHeight))
                                        normalTitle:NSLocalizedString(@"start_preview_button", nil)
                                        selectTitle:NSLocalizedString(@"stop_preview_button", nil)
                                             action:@selector(previewButtonAction:)];
    [self.bottomView addSubview: self.previewButton];
    [self.previewButton setSelected:YES];
    
    self.pushButton = [self setupButtonWithFrame:(CGRectMake(retractX * 2 + viewWidth, 0, viewWidth, viewHeight))
                                     normalTitle:NSLocalizedString(@"start_button", nil)
                                     selectTitle:NSLocalizedString(@"stop_button", nil)
                                          action:@selector(pushButtonAction:)];
    [self.bottomView addSubview: self.pushButton];
    
    self.pauseButton = [self setupButtonWithFrame:(CGRectMake(retractX * 3 + viewWidth * 2, 0, viewWidth, viewHeight))
                                      normalTitle:NSLocalizedString(@"pause_button", nil)
                                      selectTitle:NSLocalizedString(@"resume_button", nil)
                                           action:@selector(pauseButtonAction:)];
    [self.bottomView addSubview:self.pauseButton];
    
    self.restartButton = [self setupButtonWithFrame:(CGRectMake(retractX * 4 + viewWidth * 3, 0, viewWidth, viewHeight))
                                      normalTitle:NSLocalizedString(@"repush_button", nil)
                                      selectTitle:nil
                                           action:@selector(restartButtonAction:)];
    [self.bottomView addSubview:self.restartButton];

    
    self.moreSettingButton = [self setupButtonWithFrame:(CGRectMake(retractX * 5 + viewWidth * 4, 0, viewWidth, viewHeight))
                                              normalTitle:NSLocalizedString(@"more_setting_button", nil)
                                              selectTitle:nil
                                                   action:@selector(moreSettingButtonAction:)];
    [self.bottomView addSubview: self.moreSettingButton];
    
    self.isMoreSettingShow = NO;
    
}


- (void)setupInfoLabel {
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.frame = CGRectMake(20, 100, self.bounds.size.width - 40, 40);
    self.infoLabel.textColor = [UIColor blackColor];
    self.infoLabel.backgroundColor = AlivcRGBA(255, 255, 255, 0.5);
    self.infoLabel.font = [UIFont systemFontOfSize:14.f];
    self.infoLabel.layer.masksToBounds = YES;
    self.infoLabel.layer.cornerRadius = 10;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.infoLabel];
    self.infoLabel.hidden = YES;
}


- (void)setupBeautySettingViews {
    
    CGFloat retractX = 5;
    
    CGFloat height = viewHeight;
    if (self.bounds.size.width > self.bounds.size.height) {
        height = viewWidth/2;
    }
    
    self.beautySettingView = [[UIView alloc] init];
    self.beautySettingView.frame = CGRectMake(retractX,
                                              CGRectGetMaxY(self.frame) - height * 5,
                                              CGRectGetWidth(self.frame) - retractX * 2,
                                              height * 5);
    
    self.beautySettingView.backgroundColor = [UIColor grayColor];
    self.beautySettingView.layer.masksToBounds = YES;
    self.beautySettingView.layer.cornerRadius = 10;
    
    UIButton *beautyButton = [self setupButtonWithFrame:(CGRectMake(0, 0, viewWidth, height))
                                       normalTitle:NSLocalizedString(@"beauty_on", nil)
                                       selectTitle:NSLocalizedString(@"beauty_off", nil)
                                            action:@selector(beautyButtonAction:)];
    beautyButton.center = CGPointMake(retractX + viewWidth / 2, CGRectGetHeight(self.beautySettingView.frame) / 2);
    [beautyButton setSelected:YES];
    [self.beautySettingView addSubview:beautyButton];
    [beautyButton setSelected:self.config.beautyOn];
    
    
    CGFloat labelX = CGRectGetMaxX(beautyButton.frame) + retractX;
    CGFloat labelWidth = viewWidth / 2 + 20;
    CGFloat sliderX = CGRectGetMaxX(beautyButton.frame) + labelWidth + retractX * 2;
    CGFloat sliderWidth = CGRectGetWidth(self.beautySettingView.frame) - sliderX - retractX;
    CGFloat adjustHeight = (CGRectGetHeight(self.beautySettingView.frame) - retractX * 4) / 5;
    
    
    NSArray *labelNameArray = @[NSLocalizedString(@"beauty_skin_smooth", nil),NSLocalizedString(@"beauty_white", nil),NSLocalizedString(@"beaut_brightness", nil),NSLocalizedString(@"beauty_ruddy", nil),NSLocalizedString(@"beauty_saturation", nil)];
    NSArray *sliderActionArray = @[@"buffingValueChange:", @"whiteValueChange:", @"brightnessValueChange:",@"ruddyValueChange:",@"saturationValueChange:"];
    NSArray *beautyDefaultValueArray = @[@(self.config.beautyBuffing), @(self.config.beautyWhite), @(self.config.beautyBrightness), @(self.config.beautyRuddy), @(self.config.beautySaturation)];

    
    for (int index = 0; index < 5; index++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(labelX, retractX * (index + 1) + adjustHeight * index, labelWidth, adjustHeight);
        label.font = [UIFont systemFontOfSize:14.f];
        label.text = labelNameArray[index];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [self.beautySettingView addSubview:label];
        
        UISlider *slider = [[UISlider alloc] init];
        slider.frame = CGRectMake(sliderX, retractX * (index + 1) + adjustHeight * index, sliderWidth, adjustHeight);
        [slider addTarget:self action:NSSelectorFromString(sliderActionArray[index]) forControlEvents:(UIControlEventValueChanged)];
        slider.maximumValue = 100;
        slider.minimumValue = 0;
        slider.value = [beautyDefaultValueArray[index] intValue];
        [self.beautySettingView addSubview:slider];
    }
}


- (void)setupMoreSettingViews {
    
    self.moreSettingView = [[UIView alloc] init];
    
    CGFloat retractX = 5;
    
    CGFloat height = viewHeight;
    if (self.bounds.size.width > self.bounds.size.height) {
        height = 45;
    }

    
    self.moreSettingView.frame = CGRectMake(retractX,
                                              CGRectGetMaxY(self.frame) - height * 4,
                                              CGRectGetWidth(self.frame) - retractX * 2,
                                              height * 4);
    self.moreSettingView.backgroundColor = [UIColor grayColor];
    self.moreSettingView.layer.masksToBounds = YES;
    self.moreSettingView.layer.cornerRadius = 10;

    
    CGFloat buttonY = CGRectGetHeight(self.moreSettingView.frame) - height * 2;
    CGFloat middleX = CGRectGetMidX(self.moreSettingView.frame);
    
    UIButton *sharedButton = [self setupButtonWithFrame:(CGRectMake(retractX, buttonY, viewWidth, height))
                                        normalTitle:NSLocalizedString(@"share_button", nil)
                                        selectTitle:nil
                                             action:@selector(sharedButtonAction:)];
//    [self.moreSettingView addSubview:sharedButton];
    
    UIView *previewMirrorView = [self setupSwitchViewsWithFrame:(CGRectMake(middleX, buttonY, middleX, height)) title:NSLocalizedString(@"preview_mirror", nil) switchOn:self.config.previewMirror switchAction:@selector(previewMirrorSwitchAction:)];
    [self.moreSettingView addSubview:previewMirrorView];
    
    UIView *pushMirrorView = [self setupSwitchViewsWithFrame:(CGRectMake(retractX, buttonY, middleX, height)) title:NSLocalizedString(@"push_mirror", nil) switchOn:self.config.pushMirror switchAction:@selector(pushMirrorSwitchAction:)];
    [self.moreSettingView addSubview:pushMirrorView];
    
    UIView *autoFocusView = [self setupSwitchViewsWithFrame:(CGRectMake(retractX, buttonY+height, middleX, height)) title:NSLocalizedString(@"auto_focus", nil) switchOn:self.config.autoFocus switchAction:@selector(autoFocusSwitchAction:)];
    [self.moreSettingView addSubview:autoFocusView];

    
    int labelCount = 2;
    CGFloat retract = 5;
    CGFloat labelWidth = 30;
    NSArray *nameArray = @[NSLocalizedString(@"target_bitrate", nil),NSLocalizedString(@"min_bitrate", nil)];
    NSArray *textFieldActionArray = @[@"maxBitrateTextFieldValueChanged:", @"minBitrateTextFieldValueChanged:"];
    NSArray *value =@[@(self.config.targetVideoBitrate),@(self.config.minVideoBitrate)];
    
    for (int index = 0; index < labelCount; index++) {
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(retract,
                                     10 +(retract*(index+1))+(labelWidth*index),
                                     labelWidth * 2,
                                     labelWidth);
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.font = [UIFont systemFontOfSize:14.f];
        nameLabel.text = nameArray[index];
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nameLabel.numberOfLines = 0;
        
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame) + retract,
                                     CGRectGetMinY(nameLabel.frame),
                                     CGRectGetWidth(self.moreSettingView.frame) - AlivcSizeWidth(110),
                                     30);
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = [NSString stringWithFormat:@"%@", value[index]];
        textField.text = [NSString stringWithFormat:@"%@", value[index]];
        textField.font = [UIFont systemFontOfSize:14.f];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.clearsOnBeginEditing = YES;
        [textField addTarget:self action:NSSelectorFromString(textFieldActionArray[index]) forControlEvents:(UIControlEventEditingDidEnd)];
        
        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.frame = CGRectMake(CGRectGetMaxX(textField.frame) + retract,
                                     CGRectGetMinY(nameLabel.frame),
                                     labelWidth * 2,
                                     labelWidth);
        unitLabel.textAlignment = NSTextAlignmentLeft;
        unitLabel.font = [UIFont systemFontOfSize:14.f];
        unitLabel.text = @"Kbps";
        
        [self.moreSettingView addSubview:nameLabel];
        [self.moreSettingView addSubview:textField];
        [self.moreSettingView addSubview:unitLabel];

    }
}


- (UIView *)setupSwitchViewsWithFrame:(CGRect)viewFrame title:(NSString *)labelTitle switchOn:(BOOL)switchOn switchAction:(SEL)switchAction {
    
    UIView *view = [[UIView alloc] initWithFrame:viewFrame];
    
    UILabel *viewLabel = [[UILabel alloc] init];
    viewLabel.frame = CGRectMake(0, 0, CGRectGetWidth(viewFrame)/2, CGRectGetHeight(viewFrame));
    viewLabel.text = labelTitle;
    viewLabel.font = [UIFont systemFontOfSize:14.f];
    viewLabel.numberOfLines = 0;
    [viewLabel sizeToFit];
    viewLabel.center = CGPointMake(viewLabel.center.x, viewFrame.size.height/2);

    [view addSubview:viewLabel];
    
    UISwitch *viewSwitch = [[UISwitch alloc] init];
    viewSwitch.frame = CGRectMake(CGRectGetMaxX(viewLabel.frame), 0, CGRectGetWidth(viewFrame)/2, CGRectGetHeight(viewFrame));
    viewSwitch.center = CGPointMake(viewSwitch.center.x, viewFrame.size.height/2);
    [viewSwitch setOn:switchOn];
    [viewSwitch addTarget:self action:switchAction forControlEvents:(UIControlEventValueChanged)];

    [view addSubview:viewSwitch];
    
    return view;
}


- (void)setupDebugViews {
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    self.debugChartView = [[AlivcDebugChartView alloc] initWithFrame:(CGRectMake(width, 0, width, height))];
    self.debugChartView.backgroundColor = AlivcRGBA(255, 255, 255, 0.8);
    [self addSubview:self.debugChartView];
    
    
    self.debugTextView = [[AlivcDebugTextView alloc] initWithFrame:(CGRectMake(-width, 0, width, height))];
    self.debugTextView.backgroundColor = AlivcRGBA(255, 255, 255, 0.8);
    [self addSubview:self.debugTextView];
}


- (void)addGesture {
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:pinch];
    [self addGestureRecognizer:gesture];
    [self addGestureRecognizer:leftSwipeGestureRecognizer];
    [self addGestureRecognizer:rightSwipeGestureRecognizer];
}



- (UIButton *)setupButtonWithFrame:(CGRect)rect normalTitle:(NSString *)normal selectTitle:(NSString *)select action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = rect;
    [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    [button setTitle:normal forState:(UIControlStateNormal)];
    [button setTitle:select forState:(UIControlStateSelected)];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:13.f];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = rect.size.height / 5;
    return button;
}


- (UIButton *)setupButtonWithFrame:(CGRect)rect normalImage:(UIImage *)normal selectImage:(UIImage *)select action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = rect;
    [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    [button setImage:normal forState:(UIControlStateNormal)];
    [button setImage:select forState:(UIControlStateSelected)];
    return button;
}


#pragma mark - Button Actions

- (void)backButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickedBackButton];
    }
}


- (void)previewButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    
    if (self.delegate) {
        [self.delegate publisherOnClickedPreviewButton:sender.selected button:sender];
    }
}


- (void)pushButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    if (self.delegate) {
        BOOL ret = [self.delegate publisherOnClickedPushButton:sender.selected button:sender];
        if (ret) {
            [self.pauseButton setSelected:NO];
        }
    }
}


- (void)pushVideoButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    
    if (self.delegate) {
        [self.delegate publisherOnClickedPushVideoButton:sender.selected button:sender];
    }
}


- (void)beautySettingButtonAction:(UIButton *)sender {
    
    if (!self.beautySettingView) {
        [self setupBeautySettingViews];
    }
    [self addSubview:self.beautySettingView];
    self.isBeautySettingShow = YES;
}

- (void)moreSettingButtonAction:(UIButton *)sender {
    
    if (!self.moreSettingView) {
        [self setupMoreSettingViews];
    }
    [self addSubview:self.moreSettingView];
    self.isMoreSettingShow = YES;
}

- (void)switchButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickedSwitchCameraButton];
    }
    
    [self.flashButton setEnabled:!self.flashButton.enabled];
}


- (void)flashButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    if (self.delegate) {
        [self.delegate publisherOnClickedFlashButton:sender.selected button:sender];
    }
}


- (void)pauseButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    if (self.delegate) {
        [self.delegate publisherOnClickedPauseButton:sender.selected button:sender];
    }
}


- (void)restartButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickedRestartButton];
    }
}

- (void)beautyButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    if (self.delegate) {
        [self.delegate publisherOnClickedBeautyButton:sender.selected];
    }
}


- (void)sharedButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickSharedButon];
    }
}


- (void)autoFocusSwitchAction:(UISwitch *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickAutoFocusButton:sender.on];
    }
}

- (void)pushMirrorSwitchAction:(UISwitch *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickPushMirrorButton:sender.on];
    }
}

- (void)previewMirrorSwitchAction:(UISwitch *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickPreviewMirrorButton:sender.on];
    }
}


#pragma mark - Gesture

- (void)tapGesture:(UITapGestureRecognizer *)gesture{
    
    if (self.isBeautySettingShow) {
        [self.beautySettingView removeFromSuperview];
        self.isBeautySettingShow = NO;
    } else if (self.isKeyboardEdit) {
        
        [self endEditing:YES];
        
    } else if (self.isMoreSettingShow) {
        [self.moreSettingView removeFromSuperview];
        self.isMoreSettingShow = NO;
    } else {
        CGPoint point = [gesture locationInView:self];
        CGPoint percentPoint = CGPointZero;
        percentPoint.x = point.x / CGRectGetWidth(self.bounds);
        percentPoint.y = point.y / CGRectGetHeight(self.bounds);
//        NSLog(@"聚焦点  - x:%f y:%f", percentPoint.x, percentPoint.y);
        if (self.delegate) {
            [self.delegate publisherOnClickedFocus:percentPoint];
        }
    }
    
}

static CGFloat lastPinchDistance = 0;
- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    
    if (gesture.numberOfTouches != 2) {
        return;
    }
    CGPoint p1 = [gesture locationOfTouch:0 inView:self];
    CGPoint p2 = [gesture locationOfTouch:1 inView:self];
    CGFloat dx = (p2.x - p1.x);
    CGFloat dy = (p2.y - p1.y);
    CGFloat dist = sqrt(dx*dx + dy*dy);
    if (gesture.state == UIGestureRecognizerStateBegan) {
        lastPinchDistance = dist;
    }
    
    CGFloat change = dist - lastPinchDistance;

    NSLog(@"zoom - %f", change);

    if (self.delegate) {
        [self.delegate publisherOnClickedZoom:change/3000];
    }
}


- (void)leftSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (self.guideView) {
        [self.guideView removeFromSuperview];
        self.guideView = nil;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AlivcUserDefaultsIndentifierFirst];
    }
    
    if (self.currentIndex == 0) {
        if (self.delegate) {
            [self.delegate publisherOnClickedShowDebugTextInfo:NO];
            [self animationWithView:self.debugTextView x:-self.bounds.size.width];
        }
        self.currentIndex++;
        return;
    }
    
    if (self.currentIndex == 1) {
        if (self.delegate) {
            [self.delegate publisherOnClickedShowDebugChartInfo:YES];
            [self animationWithView:self.debugChartView x:0];
        }
        self.currentIndex++;
        return;
    }
    
    if (self.currentIndex == 2) {
        // 无效
        return;
    }
}


- (void)rightSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (self.guideView) {
        [self.guideView removeFromSuperview];
        self.guideView = nil;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AlivcUserDefaultsIndentifierFirst];
    }
    
    if (self.currentIndex == 0) {
        // 无效
        return;
    }
    
    if (self.currentIndex == 1) {
        if (self.delegate) {
            [self.delegate publisherOnClickedShowDebugTextInfo:YES];
            [self animationWithView:self.debugTextView x:0];
        }
        self.currentIndex--;
        return;
    }
    
    if (self.currentIndex == 2) {
        if (self.delegate) {
            [self.delegate publisherOnClickedShowDebugChartInfo:NO];
            [self animationWithView:self.debugChartView x:self.bounds.size.width];
        }
        self.currentIndex--;
        return;
    }

}


#pragma mark - Slider Actions

- (void)buffingValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyBuffingValueChanged:(int)slider.value];
    }
}

- (void)whiteValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyWhiteValueChanged:(int)slider.value];
    }
}

- (void)brightnessValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyBrightnessValueChanged:(int)slider.value];
    }
}

- (void)ruddyValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyRubbyValueChanged:(int)slider.value];
    }
}

- (void)saturationValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautySaturationValueChanged:(int)slider.value];
    }
}

#pragma mark - Animation

- (void)animationWithView:(UIView *)view x:(CGFloat)x {
    
    [UIView animateWithDuration:0.5 animations:^{
       
        CGRect frame = view.frame;
        frame.origin.x = x;
        view.frame = frame;
    }];
    
}


#pragma mark - TextField Actions

- (void)maxBitrateTextFieldValueChanged:(UITextField *)sender {
    
    if (!sender.text.length) {
        sender.text = sender.placeholder;
    }
    
    if (self.delegate) {
        [self.delegate publisherOnBitrateChangedTargetBitrate:[sender.text intValue]];
    }
}

- (void)minBitrateTextFieldValueChanged:(UITextField *)sender {
    
    if (!sender.text.length) {
        sender.text = sender.placeholder;
    }
    
    if (self.delegate) {
        [self.delegate publisherOnBitrateChangedMinBitrate:[sender.text intValue]];
    }
}


#pragma mark - Public

- (void)updateInfoText:(NSString *)text {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.infoLabel setHidden:NO];
        self.infoLabel.text = text;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(hiddenInfoLabel) withObject:nil afterDelay:2.0];

    });
}

- (void)hiddenInfoLabel {
    
    [self.infoLabel setHidden:YES];
}


- (void)updateDebugChartData:(AlivcLivePushStatsInfo *)info {
    
    [self.debugChartView updateData:info];
}

- (void)updateDebugTextData:(AlivcLivePushStatsInfo *)info {
    
    [self.debugTextView updateData:info];
}


- (void)hiddenVideoViews {
    
    self.beautySettingButton.hidden = YES;
    self.muteButton.hidden = YES;
    self.flashButton.hidden = YES;
    self.switchButton.hidden = YES;
    self.moreSettingButton.hidden = YES;
}


#pragma mark - Notification

- (void)addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)sender {
    
    self.isKeyboardEdit = YES;
    CGRect keyboardFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.moreSettingView.frame;
        frame.origin.y = keyboardFrame.origin.y - frame.size.height;
        self.moreSettingView.frame = frame;
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)sender {
    self.isKeyboardEdit = NO;
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.moreSettingView.frame;
        frame.origin.y = AlivcScreenHeight - frame.size.height;
        self.moreSettingView.frame = frame;
    }];
}

- (void)onAppDidEnterBackGround:(NSNotification *)notification
{
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
    }];

}


@end
