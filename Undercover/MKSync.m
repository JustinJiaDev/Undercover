//
//  MKSync.m
//
//  Created by Mugunth Kumar (@mugunthkumar) on 20/11/11.
//  Copyright (C) 2011-2020 by Steinlogic

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

//  As a side note, you might also consider 
//	1) tweeting about this mentioning @mugunthkumar
//	2) A paypal donation to mugunth.kumar@gmail.com


#import "MKSync.h"

@interface MKSync ()

+ (void)updateFrom:(NSNotification*)notificationObject;
+ (void)updateTo:(NSNotification *)notificationObject;

@end

@implementation MKSync

#pragma mark - Init Methods

+ (void)start
{
    if (![NSUbiquitousKeyValueStore defaultStore]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFrom:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTo:) name:NSUserDefaultsDidChangeNotification object:nil];
}

+ (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Interval Methods

+ (void)updateFrom:(NSNotification *)notificationObject
{
    // Prevent NSUserDefaultsDidChangeNotification from being posted while we update from iCloud.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];

    [[[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    }];

    [[NSUserDefaults standardUserDefaults] synchronize];

    // Enable NSUserDefaultsDidChangeNotification notifications again.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTo:) name:NSUserDefaultsDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MKSyncDidUpdateToDateNotification object:nil];
}

+ (void)updateTo:(NSNotification *)notificationObject
{
    [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [[NSUbiquitousKeyValueStore defaultStore] setObject:obj forKey:key];
    }];
    
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

@end
