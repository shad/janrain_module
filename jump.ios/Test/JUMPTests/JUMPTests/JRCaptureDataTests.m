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
#import "JRCaptureData.h"
#import "JRCaptureFlow.h"
#import <OCMock/OCMock.h>

@interface JRCaptureDataTests : GHTestCase
@end

@implementation JRCaptureDataTests

- (void)test_getForgottenPasswordFieldName
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
    [[[mockData stub] andReturn:@"resetPasswordForm"] captureForgottenPasswordFormName];

    GHAssertEqualStrings([mockData getForgottenPasswordFieldName],
                         @"traditionalSignIn_emailAddress", nil);
}

- (void)test_getForgottenPasswordFieldName_picks_first_field_that_is_a_string_type
{
    NSDictionary *flow = @{
            @"fields" : @{
                    @"resetPasswordForm" : @{
                            @"fields" : @[ @"monkey", @"username", @"traditionalSignIn_emailAddress" ]
                    },
                    @"monkey" : @{ @"type" : @"animal" },
                    @"username" : @{ @"type" : @"text" },
                    @"traditionalSignIn_emailAddress" : @{ @"type" : @"email" }
            }
    };

    JRCaptureData *captureData = [[JRCaptureData alloc] init];
    id mockData = [OCMockObject partialMockForObject:captureData];
    [[[mockData stub] andReturn:[JRCaptureFlow flowWithDictionary:flow]] captureFlow];
    [[[mockData stub] andReturn:@"resetPasswordForm"] captureForgottenPasswordFormName];

    GHAssertEqualStrings([mockData getForgottenPasswordFieldName], @"username", nil, nil);
}

- (void)test_getForgottenPasswordFieldName_returns_nil_when_no_form
{
    NSDictionary *flow = @{ };

    JRCaptureData *captureData = [[JRCaptureData alloc] init];
    id mockData = [OCMockObject partialMockForObject:captureData];
    [[[mockData stub] andReturn:[JRCaptureFlow flowWithDictionary:flow]] captureFlow];
    [[[mockData stub] andReturn:@"resetPasswordForm"] captureForgottenPasswordFormName];

    GHAssertEqualStrings([mockData getForgottenPasswordFieldName], nil, nil, nil);
}

@end
