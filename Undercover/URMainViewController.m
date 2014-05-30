//
//  URMainViewController.m
//
//  Copyright (C) 2014 by Bowei Jia (Justin).
//
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
//

#import "URMainViewController.h"
#import "URHostViewController.h"
#import "URConstants.h"
#import "NSString+HasText.h"

static NSUInteger const maxNameLength = 16;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[URConnectViewController class]]) {
        URConnectViewController *connectViewController = segue.destinationViewController;
        connectViewController.delegate = self;
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

#pragma mark - Connect View Controller Delegate Methods

- (void)connectViewControllerDidFinish:(URConnectViewController *)connectViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma - Responder Methods

- (IBAction)handleViewTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        [self.view endEditing:YES];
    }
}

#pragma mark - Status Bar Methods

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end