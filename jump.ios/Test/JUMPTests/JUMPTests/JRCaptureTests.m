/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2013, Janrain, Inc.

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

#import <GHUnitIOS/GHUnit.h>
#import "JRCapture.h"
#import "JRConnectionManager.h"
#import "JRCaptureData.h"
#import "JRCaptureConfig.h"
#import "JRCaptureUser+Extras.h"
#import "JRCaptureFlow.h"
#import "NSMutableURLRequest+JRRequestUtils.h"
#import <OCMock/OCMock.h>

@interface JRCaptureTests : GHTestCase
@end

@implementation JRCaptureTests

- (void)test_startForgottenPasswordRecoveryForField
{
    NSDictionary *flow = @{
            @"fields" : @{
                    @"resetPasswordForm" : @{
                            @"fields" : @[ @"traditionalSignIn_emailAddress" ]
                    },
                    @"traditionalSignIn_emailAddress" : @{ @"type" : @"email" }
            }
    };

    JRCaptureData *captureData = [[JRCaptureData alloc] init];
    id mockData = [OCMockObject partialMockForObject:captureData];
    [[[mockData stub] andReturn:[JRCaptureFlow flowWithDictionary:flow]] captureFlow];
    [[[mockData stub] andReturn:@"http://base.uri"] captureBaseUrl];
    [[[mockData stub] andReturn:@"http://resetpassword.here"] passwordRecoverUri];
    [[[mockData stub] andReturn:@"resetPasswordForm"] captureForgottenPasswordFormName];
    [[[mockData stub] andReturn:@"abc123"] clientId];
    [[[mockData stub] andReturn:@"US-en"] captureLocale];
    [[[mockData stub] andReturn:@"native_flow"] captureFlowName];
    [[[mockData stub] andReturn:@"123456"] downloadedFlowVersion];

    id mockJRCaptureData = [OCMockObject mockForClass:[JRCaptureData class]];
    [[[mockJRCaptureData stub] andReturn:mockData] sharedCaptureData];

    NSString *expectedUri = @"http://base.uri/oauth/forgot_password_native";
    NSDictionary *expectedParams = @{
            @"client_id" : @"abc123",
            @"locale" : @"US-en",
            @"response_type" : @"token",
            @"redirect_uri" : @"http://resetpassword.here",
            @"form" : @"resetPasswordForm",
            @"flow" : @"native_flow",
            @"flow_version" : @"123456",
            @"traditionalSignIn_emailAddress" : @"me@mydomain.name"
    };

    NSMutableURLRequest *expectedRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:expectedUri]];
    [expectedRequest JR_setBodyWithParams:expectedParams];

    id connectionManager = [OCMockObject mockForClass:[JRConnectionManager class]];
    [[connectionManager expect] startURLConnectionWithRequest:expectedRequest completionHandler:[OCMArg any]];
    [JRCapture startForgottenPasswordRecoveryForField:@"me@mydomain.name" recoverUri:nil delegate:nil];
    [connectionManager verify];
}

- (void)test_resendVerificationEmail
{
    NSDictionary *flow = @{
            @"fields" : @{
                    @"resendVerificationForm" : @{
                            @"fields" : @[ @"traditionalSignIn_emailAddress" ]
                    },
                    @"traditionalSignIn_emailAddress" : @{ @"type" : @"email" }
            }
    };

    JRCaptureData *captureData = [[JRCaptureData alloc] init];
    id mockData = [OCMockObject partialMockForObject:captureData];
    [[[mockData stub] andReturn:[JRCaptureFlow flowWithDictionary:flow]] captureFlow];
    [[[mockData stub] andReturn:@"https://base.uri"] captureBaseUrl];
    [[[mockData stub] andReturn:@"resendVerificationForm"] resendEmailVerificationFormName];
    [[[mockData stub] andReturn:@"abc123"] clientId];
    [[[mockData stub] andReturn:@"US-en"] captureLocale];
    [[[mockData stub] andReturn:@"standard_flow"] captureFlowName];
    [[[mockData stub] andReturn:@"123456"] downloadedFlowVersion];

    id mockJRCaptureData = [OCMockObject mockForClass:[JRCaptureData class]];
    [[[mockJRCaptureData stub] andReturn:mockData] sharedCaptureData];

    NSString *expectedUri = @"https://base.uri/oauth/verify_email_native";
    NSDictionary *expectedParams = @{
            @"client_id" : @"abc123",
            @"locale" : @"US-en",
            @"response_type" : @"token",
            @"redirect_uri" : @"https://base.uri/cmeu",
            @"form" : @"resendVerificationForm",
            @"traditionalSignIn_emailAddress" : @"me@mydomain.name",
            @"flow" : @"standard_flow",
            @"flow_version" : @"123456"
    };

    NSMutableURLRequest *expectedRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:expectedUri]];
    [expectedRequest JR_setBodyWithParams:expectedParams];

    id connectionManager = [OCMockObject mockForClass:[JRConnectionManager class]];
    [[connectionManager expect] startURLConnectionWithRequest:expectedRequest completionHandler:[OCMArg any]];
    [JRCapture resendVerificationEmail:@"me@mydomain.name" delegate:nil];
    [connectionManager verify];
}

- (void)test_updateProfileForUserDelegate
{
    NSDictionary *flow = @{
            @"fields" : @{
                    @"editProfileForm" : @{
                            @"fields" : @[ @"message" ]
                    },
                    @"message" : @{
                            @"schemaId" : @{
                                    @"greeting" : @"basicString",
                                    @"number" : @"basicInteger",
                            }
                    }
            }
    };

    JRCaptureData *captureData = [[JRCaptureData alloc]  init];
    id mockData = [OCMockObject partialMockForObject:captureData];
    [[[mockData stub] andReturn:[JRCaptureFlow flowWithDictionary:flow]] captureFlow];
    [[[mockData stub] andReturn:@"http://base.uri"] captureBaseUrl];
    [[[mockData stub] andReturn:@"editProfileForm"] captureEditProfileFormName];
    [[[mockData stub] andReturn:@"abc123"] clientId];
    [[[mockData stub] andReturn:@"12345abcdef"] accessToken];
    [[[mockData stub] andReturn:@"US-en"] captureLocale];
    [[[mockData stub] andReturn:@"standard_flow"] captureFlowName];
    [[[mockData stub] andReturn:@"123456"] downloadedFlowVersion];

    id mockJRCaptureData = [OCMockObject mockForClass:[JRCaptureData class]];
    [[[mockJRCaptureData stub] andReturn:mockData] sharedCaptureData];

    JRCaptureUser *user = [JRCaptureUser captureUser];
    user.basicString = @"hello";
    user.basicInteger = @30;

    NSString *expectedUri = @"http://base.uri/oauth/update_profile_native";
    NSDictionary *expectedParams = @{
            @"client_id" : @"abc123",
            @"access_token" : @"12345abcdef",
            @"locale" : @"US-en",
            @"form" : @"editProfileForm",
            @"flow" : @"standard_flow",
            @"flow_version" : @"123456",
            @"message[greeting]" : @"hello",
            @"message[number]" : @"30"
    };

    NSMutableURLRequest *expectedRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:expectedUri]];
    [expectedRequest JR_setBodyWithParams:expectedParams];

    id connectionManager = [OCMockObject mockForClass:[JRConnectionManager class]];
    [[connectionManager expect] startURLConnectionWithRequest:expectedRequest completionHandler:[OCMArg any]];
    [JRCapture updateProfileForUser:user delegate:nil ];
    [connectionManager verify];
}

@end