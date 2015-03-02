//
//  ClientDelegate.m
//  SinchCallingUIKit
//
//  Created by christian jensen on 2/25/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "ClientDelegate.h"

@implementation ClientDelegate
{
    id<SINAudioController> audioController;
}
-(void)clientDidStart:(id<SINClient>)client
{
    NSLog(@"Sinch client started successfully (version: %@)", [Sinch version]);

    [client callClient].delegate = self;
    audioController = [client audioController];
    
}

-(void)clientDidStop:(id<SINClient>)client
{
    
}
-(void)clientDidFail:(id<SINClient>)client error:(NSError *)error
{
    NSLog(@"client failed: %@", error);
}

-(void)client:(id<SINClient>)client logMessage:(NSString *)message area:(NSString *)area severity:(SINLogSeverity)severity timestamp:(NSDate *)timestamp
{
        if (severity == SINLogSeverityCritical)
            NSLog(@"%@:%@", timestamp, message);
}



-(void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call
{
    NSLog(@"%ld", [UIApplication sharedApplication].applicationState);
    
//    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground)
//    {
        NSBundle* bundle = [NSBundle bundleWithIdentifier:@"com.sinch.SinchCallingUIKit"];
        CallScreenViewController *vc = [[CallScreenViewController alloc] initWithNibName:@"CallScreenViewController" bundle:bundle];
        call.delegate = vc;
        vc.currentCall = call;
        vc.audioController = audioController;
        UIWindow* window  = [[[UIApplication sharedApplication] delegate] window];
        [[window rootViewController] presentViewController:vc animated:true completion:^{
            NSLog(@"presented");
        }];
//    }
  
    
}

-(SINLocalNotification *)client:(id<SINCallClient>)client localNotificationForIncomingCall:(id<SINCall>)call
{
          SINLocalNotification *notification = [[SINLocalNotification alloc] init];
        notification.alertAction = @"Answer";
        notification.alertBody = [NSString stringWithFormat:@"Incoming call from %@", [call remoteUserId]];
    notification.soundName = @"incoming.wav";
        return notification;
}
@end
