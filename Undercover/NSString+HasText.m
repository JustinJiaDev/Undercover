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
    return self && ![self isEqualToString:[NSString string]];
}

@end
