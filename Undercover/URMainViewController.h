//
//  URViewController.h
//  Undercover
//
//  Created by Justin Jia on 3/1/14.
//  Copyright (c) 2014 Jacinth. All rights reserved.
//

@interface URMainViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

- (IBAction)nameTextFieldDidEndOnExit:(id)sender;
- (IBAction)handleViewTap:(UIGestureRecognizer *)gestureRecognizer;

@end
