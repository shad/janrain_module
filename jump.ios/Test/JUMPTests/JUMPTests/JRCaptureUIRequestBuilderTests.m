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
#import <OCMock/OCMockObject.h>
#import <OCMock/OCMockRecorder.h>
#import "JRCaptureEnvironment.h"
#import "JRCaptureUIRequestBuilder.h"
#import "NSURLRequest+JRQueryParams.h"
#import "JRCaptureData.h"
#import "JRCaptureFlow.h"

@interface JRCaptureUIRequestBuilderTests : GHTestCase
@end

@implementation JRCaptureUIRequestBuilderTests

- (void)test_requestWithParams_throws_exception_if_form_cannot_be_found {
    id environment = [OCMockObject niceMockForProtocol:@protocol(JRCaptureEnvironment)];

    JRCaptureUIRequestBuilder *requestBuilder = [[JRCaptureUIRequestBuilder alloc] initWithEnvironment:environment];
    GHAssertThrowsSpecificNamed([requestBuilder requestWithParams:@{} form:@"badFormName"],
            NSException, NSInvalidArgumentException, @"Should have thrown an exception");

}

- (void)test_requestWithParams_for_resendVerificationForm {
    NSDictionary *flowDict = @{
            @"fields" : @{
                    @"resendVerificationForm" : @{
                            @"fields" : @[ @"traditionalSignIn_emailAddress" ]
                    },
                    @"traditionalSignIn_emailAddress" : @{ @"type" : @"email" }
            }
    };

    id environment = [OCMockObject mockForProtocol:@protocol(JRCaptureEnvironment)];
    [[[environment stub] andReturn:[JRCaptureFlow flowWithDictionary:flowDict]] captureFlow];
    [[[environment stub] andReturn:@"https://base.uri"] captureBaseUrl];
    [[[environment stub] andReturn:@"abc123"] clientId];
    [[[environment stub] andReturn:@"US-en"] captureLocale];
    [[[environment stub] andReturn:@"standard_flow"] captureFlowName];
    [[[environment stub] andReturn:@"123456"] downloadedFlowVersion];
    [[[environment stub] andReturn:@"resendVerificationForm"] resendEmailVerificationFormName];
    [[[environment stub] andReturn:@"https://redirect.uri"] redirectUri];

    NSDictionary *expectedParams = @{
            @"client_id" : @"abc123",
            @"locale" : @"US-en",
            @"response_type" : @"token",
            @"redirect_uri" : @"https://redirect.uri",
            @"form" : @"resendVerificationForm",
            @"traditionalSignIn_emailAddress" : @"me@mydomain.com",
            @"flow" : @"standard_flow",
            @"flow_version" : @"123456"
    };

    JRCaptureUIRequestBuilder *requestBuilder = [[JRCaptureUIRequestBuilder alloc] initWithEnvironment:environment];
    NSURLRequest *request = [requestBuilder requestWithParams:@{@"traditionalSignIn_emailAddress" : @"me@mydomain.com"}
                                                         form:@"resendVerificationForm"];
    GHAssertNotNil(request, @"Request should not be nil");
    GHAssertEqualStrings(request.URL.absoluteString, @"https://base.uri/oauth/verify_email_native",
                         @"URL does not match");
    GHAssertEqualObjects([request JR_HTTPBodyAsDictionary], expectedParams, @"Post params do not match");
}

@end