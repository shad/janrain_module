#import <GHUnitIOS/GHTestCase.h>
#import <OCMock/OCMockObject.h>
#import <OCMock/OCMArg.h>
#import "JRNativeTwitter.h"
#import "NSURLRequest+JRQueryParams.h"

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

#import <OCMock/OCMock.h>

@interface JRNativeTwitterTests : GHTestCase
@end

@interface JRNativeTwitter ()

- (void)doReverseAuthParametersRequest;
- (NSString *)secondsSinceEpoch;
- (NSString *)oauthNonce;
- (NSString *)oauthSignature:(NSDictionary *)parameters;
- (NSDictionary *)accessTokenAndSecretFromTwitterResult:(NSData *)data;
@end

@implementation JRNativeTwitterTests

- (void)test_doReverseAuthParametersRequest_makes_request {
    id twitter = [OCMockObject partialMockForObject:[[JRNativeTwitter alloc] init]];
    [[[twitter stub] andReturn:@"1387238208"] secondsSinceEpoch];
    [[[twitter stub] andReturn:@"abcdef"] oauthNonce];
    [[[twitter stub] andReturn:@"asecretsignature="] oauthSignature:[OCMArg any]];
    [twitter setConsumerKey:@"123456"];

    NSString *expectedAuthorizationHeader = @"OAuth oauth_timestamp=\"1387238208\", oauth_nonce=\"abcdef\", "
            "oauth_version=\"1.0\", oauth_consumer_key=\"123456\", oauth_signature_method=\"HMAC-SHA1\", "
            "oauth_signature=\"asecretsignature%3D\"";

    BOOL (^verifyRequest)(id) = ^(id value) {
        NSURLRequest *request = (NSURLRequest *)value;

        GHAssertEqualStrings(request.HTTPMethod, @"POST", @"HTTPMethod does not match");

        GHAssertEqualStrings(request.URL.absoluteString, @"https://api.twitter.com/oauth/request_token",
                @"URL does not match");

        GHAssertEqualStrings([request valueForHTTPHeaderField:@"Authorization"], expectedAuthorizationHeader,
                @"Authorization header does not match");

        GHAssertEqualObjects(request.HTTPBody, [@"x_auth_mode=reverse_auth" dataUsingEncoding:NSUTF8StringEncoding],
                @"HTTPBody does not match");

        return YES;
    };

    id connection = [OCMockObject mockForClass:[NSURLConnection class]];
    [[connection expect] sendAsynchronousRequest:[OCMArg checkWithBlock:verifyRequest]
                                                                  queue:[NSOperationQueue mainQueue]
                                                      completionHandler:[OCMArg any]];
    [twitter doReverseAuthParametersRequest];
    [connection verify];
}

- (void)test_oauthSignature_is_deterministic {
    JRNativeTwitter *twitter = [[JRNativeTwitter alloc] init];
    twitter.consumerKey = @"key";
    twitter.consumerSecret = @"secret";

    NSString *actualSignatures = [twitter oauthSignature:@{
            @"oauth_consumer_key" : @"key",
            @"oauth_nonce" : @"abcdef",
            @"oauth_signature_method" : @"HMAC-SHA1",
            @"oauth_timestamp" : @"12387238208",
            @"oauth_version" : @"1.0"
    }];

    GHAssertEqualStrings(actualSignatures, @"kwSJmm8XJ7fYRH8kfN13L8r53t8=", @"Signature does not match");
}

- (void)test_accessTokenAndSecretFromTwitterResult {
    NSString *resultString = @"oauth_token=MYTOKEN&oauth_token_secret=MYSECRET&user_id=1234&screen_name=me";
    NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];

    JRNativeTwitter *twitter = [[JRNativeTwitter alloc] init];
    NSDictionary *tokenInfo = [twitter accessTokenAndSecretFromTwitterResult:data];
    NSDictionary *expectedTokenInfo = @{ @"access_token" : @"MYTOKEN", @"token_secret" : @"MYSECRET" };

    GHAssertEqualObjects(tokenInfo, expectedTokenInfo, @"Token Info does not match");
}

- (void)test_accessTokenAndSecretFromTwitterResult_is_not_order_dependent {
    NSString *resultString = @"oauth_token_secret=MYSECRET&user_id=1234&screen_name=me&oauth_token=MYTOKEN&";
    NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];

    JRNativeTwitter *twitter = [[JRNativeTwitter alloc] init];
    NSDictionary *tokenInfo = [twitter accessTokenAndSecretFromTwitterResult:data];
    NSDictionary *expectedTokenInfo = @{ @"access_token" : @"MYTOKEN", @"token_secret" : @"MYSECRET" };

    GHAssertEqualObjects(tokenInfo, expectedTokenInfo, @"Token Info does not match");
}

- (void)test_accessTokenAndSecretFromTwitterResult_returns_nil_if_parsing_fails {
    NSString *resultString = @"oauth_token_secret&user_idMYTOKEN";
    NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];

    JRNativeTwitter *twitter = [[JRNativeTwitter alloc] init];
    GHAssertNil([twitter accessTokenAndSecretFromTwitterResult:data], @"Result should be nil");
}

- (void)test_accessTokenAndSecretFromTwitterResult_returns_nil_if_token_is_absent {
    NSString *resultString = @"oauth_token_secret=MYSECRET&user_id=1234&screen_name=me&oauth_token=";
    NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];

    JRNativeTwitter *twitter = [[JRNativeTwitter alloc] init];
    GHAssertNil([twitter accessTokenAndSecretFromTwitterResult:data], @"Result should be nil");
}

- (void)test_accessTokenAndSecretFromTwitterResult_returns_nil_if_token_secret_is_absent {
    NSString *resultString = @"user_id=1234&screen_name=me&oauth_token=MYTOKEN";
    NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];

    JRNativeTwitter *twitter = [[JRNativeTwitter alloc] init];
    GHAssertNil([twitter accessTokenAndSecretFromTwitterResult:data], @"Result should be nil");
}

@end