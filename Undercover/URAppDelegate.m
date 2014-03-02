//
//  URAppDelegate.m
//  Undercover
//
//  Created by Justin Jia on 3/1/14.
//  Copyright (c) 2014 Jacinth. All rights reserved.
//

#import "URAppDelegate.h"
#import "MKSync.h"

@implementation URAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MKSync start];
    
    return YES;
}

@end
