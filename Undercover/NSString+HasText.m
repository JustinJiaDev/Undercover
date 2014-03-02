//
//  NSString+HasText.m
//  Undercover
//
//  Created by Justin Jia on 3/1/14.
//  Copyright (c) 2014 Jacinth. All rights reserved.
//

#import "NSString+HasText.h"

@implementation NSString (HasText)

- (BOOL)hasText
{
    if (self && ![self isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

@end
