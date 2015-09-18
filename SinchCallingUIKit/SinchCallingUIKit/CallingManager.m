//
//  CallingManager.m
//  SinchCallingUIKit
//
//  Created by christian jensen on 2/24/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "CallingManager.h"
#import <Sinch/Sinch.h>
#import "ClientDelegate.h"
#import "CallScreenViewController.h"

@interface CallingManager()
{
    id<SINClient> sinchClient;
    id<SINClientDelegate> clientDelegate;
    id<SINCall> currentCall;
}

@end

@implementation CallingManager
+ (CallingManager*)sharedManager {
    static CallingManager *sharedManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManagerInstance = [[self alloc] init];
        [sharedManagerInstance requestUserNotificationPermission];
//        sharedManagerInstance.logLevel = SINLogSeverityCritical;
    });
    return sharedManagerInstance;
}

- (void)requestUserNotificationPermission {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}
-(void)showCallController
{
  
    NSBundle* bundle = [NSBundle bundleWithIdentifier:@"com.sinch.SinchCallingUIKit"];
    CallScreenViewController *vc = [[CallScreenViewController alloc] initWithNibName:@"CallScreenViewController" bundle:bundle];
    currentCall.delegate = vc;
    vc.currentCall = currentCall;
    vc.audioController = [sinchClient audioController];
    UIWindow* window  = [[[UIApplication sharedApplication] delegate] window];
    [[window rootViewController] presentViewController:vc animated:true completion:^{
        NSLog(@"presented");
    }];

    
}
-(void)callUser:(NSString*)userName
{
    currentCall = [[sinchClient callClient] callUserWithId:userName];
    [self showCallController];
}

-(void)callNumber:(NSString *)phoneNumber
{
    if (![sinchClient isStarted])
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please start the sinch client before making a call" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    
    currentCall = [[sinchClient callClient] callPhoneNumber:phoneNumber];
    [self showCallController];
    
}

- (void)handleLocalNotification:(UILocalNotification *)notification {
    if (notification) {
        id<SINNotificationResult> result = [sinchClient relayLocalNotification:notification];
        if ([result isCall] && [[result callResult] isTimedOut]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Missed call"
                                  message:[NSString stringWithFormat:@"Missed call from %@", [[result callResult] remoteUserId]]
                                  delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}

/// public Methods
-(void)startClientWithKey:(NSString*)appKey secret:(NSString*)secret userName:(NSString*)userName sandbox:(bool)sandbox launchOptions:(NSDictionary*)launchOptions
{
    NSString* url = sandbox ? @"sandbox.sinch.com" : @"clientapi.sinch.com";
    sinchClient = [Sinch clientWithApplicationKey:appKey applicationSecret:secret environmentHost:url userId:userName];
    [sinchClient setSupportCalling:YES];
    [sinchClient setSupportMessaging:YES];
    clientDelegate = [[ClientDelegate alloc] init];
    sinchClient.delegate =clientDelegate;
    // below line will affect your monthly active users
    [sinchClient setSupportActiveConnectionInBackground:YES];
    [sinchClient setSupportPushNotifications:NO];
    [sinchClient start];
    [sinchClient startListeningOnActiveConnection];
    [self handleLocalNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]];
}

@end
