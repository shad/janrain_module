/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Thursday, January 26, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "debug_log.h"
#import "JRCaptureObject.h"
#import "JRCaptureUser+Extras.h"
#import "CaptureProfileViewController.h"
#import "AppDelegate.h"
#import "JRCapture.h"
#import "Utils.h"
#import "JRCaptureError.h"

@interface CaptureProfileViewController () <UITextViewDelegate, UIAlertViewDelegate, JRCaptureUserDelegate,
        UITextFieldDelegate, JRCaptureDelegate>
@property(nonatomic, retain) id firstResponder;
@property(nonatomic, retain) NSDate *myBirthdate;
@end

@implementation CaptureProfileViewController
@synthesize myEmailTextField;
@synthesize myDisplayNameTextField;
@synthesize myFirstNameTextField;
@synthesize myLastNameTextField;
@synthesize myGenderIdentitySegControl;
@synthesize myBirthdayButton;
@synthesize myAboutMeTextView;
@synthesize myScrollView;
@synthesize myKeyboardToolbar;
@synthesize firstResponder;
@synthesize myBirthdate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
}

- (void)loadView {
    [super loadView];

    myScrollView.contentSize = CGSizeMake(320, 500);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    [myAboutMeTextView setInputAccessoryView:myKeyboardToolbar];
    [myEmailTextField setInputAccessoryView:myKeyboardToolbar];
    [myDisplayNameTextField setInputAccessoryView:myKeyboardToolbar];
    [myFirstNameTextField setInputAccessoryView:myKeyboardToolbar];
    [myLastNameTextField setInputAccessoryView:myKeyboardToolbar];

    if (appDelegate.captureUser.email)
        myEmailTextField.text  = appDelegate.captureUser.email;

    if (appDelegate.captureUser.aboutMe)
        myAboutMeTextView.text = appDelegate.captureUser.aboutMe;

    if (appDelegate.captureUser.displayName)
        myDisplayNameTextField.text = appDelegate.captureUser.displayName;

    if (appDelegate.captureUser.givenName)
        myFirstNameTextField.text = appDelegate.captureUser.givenName;

    if (appDelegate.captureUser.familyName)
        myLastNameTextField.text = appDelegate.captureUser.familyName;

    char genderSegment = ([self isFemaleGender:[appDelegate.captureUser.gender lowercaseString]]) ? 0 : 1;
    [myGenderIdentitySegControl setSelectedSegmentIndex:genderSegment];

    if (appDelegate.captureUser.birthday)
    {
        [myDatePicker setDate:appDelegate.captureUser.birthday];
        [self pickerChanged];
    }

    if (appDelegate.isNotYetCreated || !appDelegate.captureUser)
    {
        self.myDoneButton.title = @"Register";
    }
    else
    {
        self.myDoneButton.title = @"Update";
    }
}

- (BOOL)isFemaleGender:(NSString *)gender
{
    return [gender isEqualToString:[@"F" lowercaseString]] ||
        [gender isEqualToString:[@"female" lowercaseString]] ||
        [gender isEqualToString:[@"girl" lowercaseString]] ||
        [gender isEqualToString:[@"woman" lowercaseString]];
}

- (void)scrollUpBy:(NSInteger)scrollOffset
{
    [myScrollView setContentOffset:CGPointMake(0, scrollOffset)];
    [myScrollView setContentSize:CGSizeMake(320, self.view.frame.size.height + scrollOffset)];
}

- (void)scrollBack
{
    [myScrollView setContentOffset:CGPointZero];
    [myScrollView setContentSize:CGSizeMake(320, self.view.frame.size.height)];
}

- (IBAction)emailTextFieldClicked:(id)sender
{
    [myEmailTextField becomeFirstResponder];
}

- (IBAction)birthdayButtonClicked:(id)sender
{
    [self slidePickerUp];
    [self scrollUpBy:40];
}

- (IBAction)displayNameFieldClicked:(id)sender {
    [myDisplayNameTextField becomeFirstResponder];
}

- (IBAction)firstNameFieldClicked:(id)sender {
    [myFirstNameTextField becomeFirstResponder];
}

- (IBAction)lastNameFieldClicked:(id)sender {
    [myLastNameTextField becomeFirstResponder];
}

- (void)pickerDone
{
    [self slidePickerDown];
    [self scrollBack];
}

- (void)pickerChanged
{
    DLog(@"");
    [myBirthdayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    NSDateFormatter *dateFormatter = nil;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];

    NSDate *pickerDate = myDatePicker.date;
    NSString *dateString = [dateFormatter stringFromDate:pickerDate];

    [myBirthdayButton setTitle:dateString forState:UIControlStateNormal];

    self.myBirthdate = pickerDate;
}

- (IBAction)doneEditingButtonPressed:(id)sender
{
    [firstResponder resignFirstResponder];
    [self setFirstResponder:nil];
}

- (IBAction)doneButtonPressed:(id)sender
{
    appDelegate.captureUser.aboutMe  = myAboutMeTextView.text;
    appDelegate.captureUser.birthday = myBirthdate;
    appDelegate.captureUser.email    = myEmailTextField.text;
    appDelegate.captureUser.displayName = myDisplayNameTextField.text;
    appDelegate.captureUser.givenName = myFirstNameTextField.text;
    appDelegate.captureUser.familyName = myLastNameTextField.text;

    if (myGenderIdentitySegControl.selectedSegmentIndex == 0)
        appDelegate.captureUser.gender = @"female";
    else if (myGenderIdentitySegControl.selectedSegmentIndex == 1)
        appDelegate.captureUser.gender = @"male";

    if (appDelegate.isNotYetCreated)
    {
        [JRCapture registerNewUser:appDelegate.captureUser socialRegistrationToken:appDelegate.registrationToken
                       forDelegate:self];
    }

    self.myDoneButton.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (appDelegate.isNotYetCreated == YES)
    {
        appDelegate.isNotYetCreated = NO;
        appDelegate.captureUser = nil;
        appDelegate.registrationToken = nil;
    }
}

#define ABOUT_ME_TEXT_VIEW_TAG 20

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.firstResponder = textField;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.firstResponder = textView;
    if (textView.tag == ABOUT_ME_TEXT_VIEW_TAG)
    {
        [self scrollUpBy:210];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self scrollBack];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView { }
- (void)textViewDidChangeSelection:(UITextView *)textView { }
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView { return YES; }
- (BOOL)textViewShouldEndEditing:(UITextView *)textView { return YES; }

- (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
{
    [Utils handleSuccessWithTitle:@"Profile updated" message:nil forVc:self];
    self.myDoneButton.enabled = YES;
}

- (void)updateDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context
{
    [Utils handleFailureWithTitle:@"Profile not updated" message:nil];
    self.myDoneButton.enabled = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)registerUserDidSucceed:(JRCaptureUser *)registeredUser
{
    appDelegate.isNotYetCreated = NO;
    appDelegate.captureUser = registeredUser;
    appDelegate.registrationToken = nil;
    [Utils handleSuccessWithTitle:@"Registration Complete" message:nil forVc:self];
}

- (void)registerUserDidFailWithError:(NSError *)error
{
    [error isJRMergeFlowError];
    if ([error isJRFormValidationError])
    {
        NSDictionary *invalidFieldLocalizedFailureMessages = [error JRValidationFailureMessages];
        [Utils handleFailureWithTitle:@"Invalid Form Submission"
                              message:[invalidFieldLocalizedFailureMessages description]];

    }
    else
    {
        [Utils handleFailureWithTitle:@"Registration Failed" message:[error localizedDescription]];
    }

    self.myDoneButton.enabled = YES;
}

@end
