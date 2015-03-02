//
//  CallingManager.h
//  SinchCallingUIKit
//
//  Created by christian jensen on 2/24/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallingManager : NSObject
+ (CallingManager*)sharedManager;

-(void)startClientWithKey:(NSString*)appKey secret:(NSString*)secret userName:(NSString*)userName sandbox:(bool)sandbox;
-(void)callNumber:(NSString *)phoneNumber;
-(void)callUser:(NSString*)userName;

@end
