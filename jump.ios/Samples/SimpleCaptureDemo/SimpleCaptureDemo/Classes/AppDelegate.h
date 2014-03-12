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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <UIKit/UIKit.h>

#define cJRCurrentProvider  @"simpleCaptureDemo.currentProvider"
#define cJRCaptureUser      @"simpleCaptureDemo.captureUser"

@class AppDelegate;
@class JRCaptureUser;

AppDelegate *appDelegate;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong) NSUserDefaults *prefs;
@property(strong) JRCaptureUser *captureUser;
@property BOOL isNotYetCreated;
@property(strong) NSString *currentProvider;
@property(nonatomic, strong) NSString *captureClientId;
@property(nonatomic, strong) NSString *captureDomain;
@property(nonatomic, strong) NSString *captureLocale;
@property(nonatomic, strong) NSString *captureFlowName;
@property(nonatomic, strong) NSString *captureTraditionalSignInFormName;
@property(nonatomic) BOOL captureEnableThinRegistration;
@property(nonatomic, strong) NSString *captureFlowVersion;
@property(nonatomic, strong) NSString *captureTraditionalRegistrationFormName;
@property(nonatomic, strong) NSString *captureSocialRegistrationFormName;
@property(nonatomic, strong) NSString *captureAppId;
@property(nonatomic, strong) NSString *engageAppId;
@property(nonatomic, strong) NSString *bpBusUrlString;

@property(nonatomic, strong) NSString *lfToken;
@property(nonatomic, strong) NSString *bpChannelUrl;
@property(nonatomic, strong) NSString *liveFyreNetwork;
@property(nonatomic, strong) NSString *liveFyreSiteId;
@property(nonatomic, strong) NSString *liveFyreArticleId;


@property(nonatomic, retain) NSString *registrationToken;

@property(nonatomic, strong) NSDictionary *customProviders;

@property(nonatomic, retain) NSString *captureForgottenPasswordFormName;
@property(nonatomic, retain) NSString *captureEditProfileFormName;
@property(nonatomic, retain) NSString *resendVerificationFormName;

- (void)saveCaptureUser;
@end
