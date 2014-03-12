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
#import "JRCaptureUser.h"
#import "JRCaptureFlow.h"
#import "JRCaptureUser+Extras.h"

@interface JRCaptureUserExtrasTests : GHTestCase
@end

@implementation JRCaptureUserExtrasTests

- (void)test_toFormFieldsForFormWithFlow
{
    NSDictionary *flow = @{
            @"fields" : @{
                    @"editProfileForm" : @{
                            @"fields" : @[ @"message" ]
                    },
                    @"message" : @{
                            @"schemaId" : @"basicString"
                    }
            }
    };

    JRCaptureUser *user = [JRCaptureUser captureUser];
    user.basicString = @"hello";

    NSDictionary *actualFields = [user toFormFieldsForForm:@"editProfileForm" withFlow:[JRCaptureFlow flowWithDictionary:flow]];
    NSDictionary *expectedFields = @{
            @"message" : @"hello",
    };

    GHAssertEqualObjects(actualFields, expectedFields, nil);
}

- (void)test_toFormFieldsForFormWithFlow__complex_fields
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

    JRCaptureUser *user = [JRCaptureUser captureUser];
    user.basicString = @"hello";
    user.basicInteger = @30;

    NSDictionary *actualFields = [user toFormFieldsForForm:@"editProfileForm" withFlow:[JRCaptureFlow flowWithDictionary:flow]];
    NSDictionary *expectedFields = @{
            @"message[greeting]" : @"hello",
            @"message[number]" : @"30"
    };

    GHAssertEqualObjects(actualFields, expectedFields, nil);
}

- (void)test_toFormFieldsForFormWithFlow_special_handling_for_dates
{
    NSDictionary *flow = @{
            @"fields" : @{
                    @"editProfileForm" : @{
                            @"fields" : @[ @"birthdate" ]
                    },
                    @"birthdate" : @{
                            @"schemaId" : @"basicDate",
                            @"type" : @"dateselect"
                    }
            }
    };

    JRCaptureUser *user = [JRCaptureUser captureUser];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    user.basicDate = [dateFormatter dateFromString:@"1959-04-22"];

    NSDictionary *actualFields = [user toFormFieldsForForm:@"editProfileForm" withFlow:[JRCaptureFlow flowWithDictionary:flow]];
    NSDictionary *expectedFields = @{
            @"birthdate[dateselect_day]" : @"22",
            @"birthdate[dateselect_month]" : @"04",
            @"birthdate[dateselect_year]" : @"1959",
    };

    GHAssertEqualObjects(actualFields, expectedFields, nil);
}

@end