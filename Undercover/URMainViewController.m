//
//  URViewController.m
//  Undercover
//
//  Created by Justin Jia on 3/1/14.
//  Copyright (c) 2014 Jacinth. All rights reserved.
//

#import "URMainViewController.h"
#import "URHostViewController.h"
#import "URConstants.h"
#import "NSString+HasText.h"

static NSString * const hostSegueIdentifier = @"hostSegueIdentifier";
static NSString * const joinSegueIdentifier = @"joinSegueIdentifier";

@implementation URMainViewController

#pragma mark View Controller Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:nameKey];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.nameTextField.text.hasText) {
        [self.nameTextField becomeFirstResponder];
    }
}

#pragma mark - View Methods
- (IBAction)nameTextFieldDidEndOnExit:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:nameKey];
}

#pragma mark - Text Field Delegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger finalLength = (textField.text.length + string.length - range.length);
    return (finalLength <= maxNameLength || finalLength < textField.text.length) ? YES : NO;
}

#pragma - Responder Methods
- (IBAction)handleViewTap:(UIGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateRecognized:
            [self.view endEditing:YES];
            break;
            
        default:
            break;
    }
}

@end