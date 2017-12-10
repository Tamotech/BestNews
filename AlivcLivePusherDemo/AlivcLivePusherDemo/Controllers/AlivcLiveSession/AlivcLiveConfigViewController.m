//
//  AlivcLiveConfigViewController.m
//  AlivcLiveCaptureDev
//
//  Created by lyz on 2017/10/9.
//  Copyright © 2017年 Alivc. All rights reserved.
//

#import "AlivcLiveConfigViewController.h"
#import "AlivcLiveViewController.h"
#import "PrefixHeader.pch"


@interface AlivcLiveConfigViewController ()

@property(nonatomic, copy) NSString* pushUrl;
@property (weak, nonatomic) IBOutlet UITextField *pushURLTextField;
@property (weak, nonatomic) IBOutlet UISwitch *screenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mirrorSwitch;

@end

@implementation AlivcLiveConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pushURLTextField.clearsOnBeginEditing = YES;
    self.pushURLTextField.text = AlivcTextPushURL;
    
}


#pragma mark - Action
- (IBAction)switchAction:(UISwitch *)sender {
    
    if ([sender isOn]) {
        [sender setOn:YES];
    } else {
        [sender setOn:NO];
    }
}
- (IBAction)mirrorSwitchAction:(UISwitch *)sender {
    
    if ([sender isOn]) {
        [sender setOn:YES];
    } else {
        [sender setOn:NO];
    }
}

- (IBAction)startButtonClick:(id)sender {
    
    self.pushUrl = self.pushURLTextField.text;
    
    if (![self.pushUrl containsString:@"rtmp://"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推流地址格式错误，无法直播" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    AlivcLiveViewController *live = [[AlivcLiveViewController alloc] initWithNibName:@"AlivcLiveViewController" bundle:nil url:self.pushUrl isScreenHorizontal:!self.screenSwitch.on isFrontMirror:self.mirrorSwitch.on];
    [self presentViewController:live animated:YES completion:nil];
    
}


@end
