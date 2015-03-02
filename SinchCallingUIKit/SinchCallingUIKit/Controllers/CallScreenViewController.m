//
//  CallScreenViewController.m
//  SinchCallingUIKit
//
//  Created by christian jensen on 2/17/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "CallScreenViewController.h"
#import "CallingManager.h"
@interface CallScreenViewController ()
{
    NSTimer* callTimer;
    BOOL muted;
    BOOL speaker;
    BOOL keypad;
    UITextField* keypadField;
}

@end

@implementation CallScreenViewController
@synthesize currentCall, audioController, statusField, numberField, keybadButton, muteButton, speakerButton, answerButton, hangupConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)hangup:(id)sender {
    if (currentCall != nil)
        [currentCall hangup];
    
    
}

-(IBAction)answer:(id)sender
{
    [currentCall answer];
    [self.view layoutIfNeeded];
    
    self.hangupConstraint.constant = 0;

    self.buttonView.alpha=0;
    self.buttonView.hidden=NO;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                   
                         self.answerButton.alpha = 0;
                         self.buttonView.alpha=1;
                         [self.view layoutIfNeeded]; // Called on parent view
                     } completion:^(BOOL finished) {
                         
                         self.answerButton.hidden = YES;
                     }];
   
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.numberField.text = [currentCall remoteUserId];
    if ([currentCall direction] == SINCallDirectionOutgoing)
    {
        self.answerButton.hidden = YES;
        self.hangupConstraint.constant = 0;
    }
    else
    {
        [[self audioController] startPlayingSoundFile:[self pathForSound:@"incoming.wav"] loop:YES];        self.buttonView.hidden=YES;
    }
}
#pragma mark "call delegate"
//call delegate methods

-(void)callDidProgress:(id<SINCall>)call
{

    statusField.text = call.direction == SINCallDirectionOutgoing? @"Calling..." : @"Incoming call";
    
    [[self audioController] startPlayingSoundFile:[self pathForSound:@"ringback.wav"] loop:YES];
}
-(void)callDidEstablish:(id<SINCall>)call
{
    [[self audioController] stopPlayingSoundFile];
    
    callTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                 target:self
                                               selector:@selector(updateStatus)
                                               userInfo:nil
                                                repeats:YES];
}
-(void)callDidEnd:(id<SINCall>)call
{
    [[self audioController] stopPlayingSoundFile];
    [self stopCallDurationTimer];
    statusField.text = @"Ended";
    __weak id myself = self;
    if (keypad)
        [self keyPad:nil]; //hide the keypad
    //createa  disabled look
    UIView* baseView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                [[UIScreen mainScreen] applicationFrame].size.width,
                                                                [[UIScreen mainScreen] applicationFrame].size.height)];
    //self.view = baseView;
    [self.view addSubview:baseView];
    [baseView setBackgroundColor:[UIColor blackColor]];
    baseView.userInteractionEnabled = NO;
    baseView.alpha = 0.5;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [myself dismissViewControllerAnimated:YES completion:nil];
    });
    
    
    
}

- (NSString *)pathForSound:(NSString *)soundName {
    NSBundle* bundle = [NSBundle bundleWithIdentifier:@"com.sinch.SinchCallingUIKit"];
    return [[bundle resourcePath] stringByAppendingPathComponent:soundName];
}

- (void)stopCallDurationTimer {
    [callTimer invalidate];
    callTimer = nil;
}



-(UIImage*)loadImageWithName:(NSString*)imageName
{
    NSBundle* bundle = [NSBundle bundleWithIdentifier:@"com.sinch.SinchCallingUIKit"];
    NSString *imagePath = [bundle pathForResource:imageName ofType:@"png"];
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

-(void)updateStatus
{
    NSInteger duration = [[NSDate date] timeIntervalSinceDate:[[self.currentCall details] establishedTime]];
    statusField.text = [NSString stringWithFormat:@"%02d:%02d", (int)(duration / 60), (int)(duration % 60)];
}

- (IBAction)mute:(id)sender {
    if (muted)
    {
        muted = NO;
        [muteButton setImage:[self loadImageWithName:@"mute"] forState:UIControlStateNormal];
        [audioController unmute];
    }
    else
    {
        muted = YES;
        [muteButton setImage:[self loadImageWithName:@"mute_selected"] forState:UIControlStateNormal];
        [audioController mute];
    }
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [currentCall sendDTMF:string];
    return NO;
}

- (IBAction)keyPad:(id)sender {
    if (keypad)
    {
        keypad = NO;
        [keybadButton setImage:[self loadImageWithName:@"keypad"] forState:UIControlStateNormal];
        [keypadField resignFirstResponder];
        [keypadField removeFromSuperview];
    }
    else
    {
        keypad = YES;
        [keybadButton setImage:[self loadImageWithName:@"keypad_selected"] forState:UIControlStateNormal];
        keypadField= [[UITextField alloc] init];
        keypadField.delegate= self;
        
        [keypadField setKeyboardType:UIKeyboardTypePhonePad];
        [[self view] addSubview:keypadField];
        [keypadField becomeFirstResponder];
    }
    
}

- (IBAction)speaker:(id)sender {
    if (speaker)
    {
        speaker = NO;
        [speakerButton setImage:[self loadImageWithName:@"speaker"] forState:UIControlStateNormal];
        [audioController disableSpeaker];
    }
    else
    {
        speaker = YES;
        [speakerButton setImage:[self loadImageWithName:@"speaker_selected"] forState:UIControlStateNormal];
        [audioController enableSpeaker];
    }
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
