//
//  ViewController.m
//  TestAppUIkit
//
//  Created by christian jensen on 2/24/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)callMe:(id)sender {
        [[CallingManager sharedManager] callNumber:@"+4600000000020"];
}
- (IBAction)callUser:(id)sender {
    NSString* userName = @"sim";
#if (TARGET_IPHONE_SIMULATOR)
    userName=@"iphone";
#endif

    [[CallingManager sharedManager] callUser:userName];
    
}

-(void)viewDidAppear:(BOOL)animated
{

}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
