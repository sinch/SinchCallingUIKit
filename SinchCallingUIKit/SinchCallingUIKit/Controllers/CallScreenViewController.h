//
//  CallScreenViewController.h
//  SinchCallingUIKit
//
//  Created by christian jensen on 2/17/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>
@interface CallScreenViewController : UIViewController <SINCallDelegate, UITextFieldDelegate>
@property id<SINCall> currentCall;
@property id<SINAudioController> audioController;
@property (weak, nonatomic) IBOutlet UILabel *statusField;
@property (weak, nonatomic) IBOutlet UILabel *numberField;

@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@property (weak, nonatomic) IBOutlet UIButton *keybadButton;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hangupConstraint;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;

@end
