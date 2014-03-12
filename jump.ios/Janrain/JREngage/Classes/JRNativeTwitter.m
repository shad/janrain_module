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

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "JRNativeTwitter.h"
#import "JRBase64.h"
#import "JRConnectionManager.h"
#import "debug_log.h"
#import "JREngageError.h"

@interface JRNativeTwitter () <UIActionSheetDelegate>
@property (nonatomic, retain) ACAccountStore *accountStore;
@property (atomic, retain) NSString *reverseAuthParameters;
@property (atomic, retain) UIView *backgroundView;
@property (atomic, retain) NSArray *accounts;
@property (atomic, retain) ACAccount *accountToSignInWith;
@end

@implementation JRNativeTwitter

#define kTwitterRequestTokenURL @"https://api.twitter.com/oauth/request_token"
#define kTwitterOAuthAccessTokenURL @"https://api.twitter.com/oauth/access_token"
#define kJRLastUsedTwitterAccount @"jrengage.jrNativeTwitter.lastUsedTwitterAccount"

- (NSString *)provider {
    return @"twitter";
}

+ (BOOL)canHandleAuthentication {
    // Check if at least one Twitter account is set up
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)startAuthenticationWithCompletion:(NativeCompletionBlock)completion {
    [super startAuthenticationWithCompletion:completion];

    if (self.consumerKey && self.consumerSecret) {
        _backgroundView = [[UIView alloc] init];
        [self obtainPermissionToAccessTwitterAccounts];
    } else {
        [self triggerWebViewAuthenticationWithMessage:@"Twitter SSO not configured, try web view authentication"];
    }
}

#pragma mark - Private

- (void)obtainPermissionToAccessTwitterAccounts {
    _accountStore = [[ACAccountStore alloc] init];

    // Do we have access to the twitter accounts?
    [self.accountStore requestAccessToAccountsWithType:self.twitterAccountType options:nil completion:
            ^(BOOL granted, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!granted) {
                        [self handleAccessToAccountsNotGranted:error];
                    } else {
                        [self selectTwitterAccount];
                    }
                });
            }];
}

- (void)handleAccessToAccountsNotGranted:(NSError *)error {
    if (!error) {
        // This error case should be handled by the host application.
        self.completion(
                [JREngageError errorWithMessage:@"No access to Twitter accounts"
                                        andCode:JRAuthenticationNoAccessToTwitterAccountsError]);
    } else if (error.code == ACErrorAccountNotFound) {
        // This occurs in the iOS 6 simulator when there are no accounts
        [self triggerWebViewAuthenticationWithMessage:@"No twitter accounts configured, try web view authentication"];
    } else {
        NSString *errorMessage = [NSString stringWithFormat:@"Failed to get access to Twitter accounts: %@", error];
        self.completion([JREngageError errorWithMessage:errorMessage andCode:JRAuthenticationNativeAuthError]);
    }
}

- (void)selectTwitterAccount {
    DLog("");
    self.accounts = [self.accountStore accountsWithAccountType:self.twitterAccountType];

    if (![self.accounts count]) {
        [self triggerWebViewAuthenticationWithMessage:@"No twitter accounts configured, try web view authentication"];
    } else if (self.shouldSignInAutomatically) {
        self.accountToSignInWith = self.accounts[0];
        [self doReverseAuthParametersRequest];
    } else {
        [self presentAccountSelectionDialog];

    }
}

- (BOOL)shouldSignInAutomatically {
    // YES if there is only 1 Twitter account and it was the last used Twitter account
    if ([self.accounts count] == 1) {
        ACAccount *account = self.accounts[0];
        NSString *storedAccountIdentifier =
                [[NSUserDefaults standardUserDefaults] stringForKey:kJRLastUsedTwitterAccount];

        return storedAccountIdentifier && [account.identifier isEqualToString:storedAccountIdentifier];
    }

    return NO;
}

- (void)presentAccountSelectionDialog {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = window.frame;
    self.backgroundView.frame = frame;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [window addSubview:self.backgroundView];

    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"Choose a Twitter Account"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil] autorelease];
    actionSheet.delegate = self;
    for (ACAccount *account in self.accounts) {
        [actionSheet addButtonWithTitle:account.username];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showInView:self.backgroundView];
}

#pragma mark - Twitter Reverse Auth Step 2

/**
 * Twitter Reverse Auth Step 2
 * Obtain the Twitter access token
 */
- (void)obtainTwitterAccessToken {
    NSDictionary *params = @{
            @"x_reverse_auth_target" : self.consumerKey,
            @"x_reverse_auth_parameters" : self.reverseAuthParameters
    };

    NSURL *url = [NSURL URLWithString:kTwitterOAuthAccessTokenURL];

    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:params];

    [request setAccount:self.accountToSignInWith];

    [request performRequestWithHandler:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        NSDictionary *tokenAndSecret = [self accessTokenAndSecretFromTwitterResult:data];
        if (tokenAndSecret) {
            [self getAuthInfoTokenForAccessToken:tokenAndSecret[@"access_token"]
                                  andTokenSecret:tokenAndSecret[@"token_secret"]];
        } else {
            self.completion([JREngageError errorWithMessage:@"Could not parse Twitter token info"
                                                    andCode:JRAuthenticationNativeAuthError]);
        }
    }];
}

- (NSDictionary *)accessTokenAndSecretFromTwitterResult:(NSData *)data {
    NSString *accessToken = nil;
    NSString *tokenSecret = nil;
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    for (NSString *param in [responseString componentsSeparatedByString:@"&"]) {
        NSArray *pair = [param componentsSeparatedByString:@"="];

        if ([pair count] == 2) {
            if ([pair[0] isEqualToString:@"oauth_token"]) accessToken = pair[1];
            if ([pair[0] isEqualToString:@"oauth_token_secret"]) tokenSecret = pair[1];
        }
    }

    [responseString release];

    if (!accessToken || !accessToken.length || !tokenSecret || !tokenSecret.length) return nil;
    return @{ @"access_token" : accessToken, @"token_secret" : tokenSecret };
}

- (ACAccountType *)twitterAccountType {
    return [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
}

#pragma mark - Twitter Reverse Auth Step 1

/**
 * Twitter Reverse Auth Step 1
 * Obtain a special request token
 */
- (void)doReverseAuthParametersRequest {
    DLog(@"Signing in with %@", self.accountToSignInWith.username);

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
            @"oauth_consumer_key" : self.consumerKey,
            @"oauth_nonce" : [self oauthNonce],
            @"oauth_signature_method" : @"HMAC-SHA1",
            @"oauth_timestamp" : [self secondsSinceEpoch],
            @"oauth_version" : @"1.0"
    }];

    [params setObject:[self oauthSignature:params] forKey:@"oauth_signature"];

    NSString *authorizationHeader = [self authorizationHeaderString:params];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kTwitterRequestTokenURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:[@"x_auth_mode=reverse_auth" dataUsingEncoding:NSUTF8StringEncoding]];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
            ^(NSURLResponse* response, NSData* data, NSError* connectionError) {
                if (connectionError) {
                    self.completion(connectionError);
                } else {
                    self.reverseAuthParameters =
                        [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
                    [self obtainTwitterAccessToken];
                }
            }];
}

- (NSString *)oauthSignature:(NSDictionary *)parameters {
    NSMutableDictionary *signatureParams = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [signatureParams setObject:@"reverse_auth" forKey:@"x_auth_mode"];

    NSArray *sortedKeys = [[signatureParams allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *encodedParams = [NSMutableArray arrayWithCapacity:[sortedKeys count]];

    for (NSUInteger i = 0; i < sortedKeys.count; ++i) {
        NSString *key = sortedKeys[i];
        NSString *value = signatureParams[key];

        [encodedParams addObject:[NSString stringWithFormat:@"%@=%@",
                [key stringByAddingUrlPercentEscapes],
                [value stringByAddingUrlPercentEscapes]]];
    }

    NSString *baseString = [NSString stringWithFormat:@"POST&%@&%@",
            [kTwitterRequestTokenURL stringByAddingUrlPercentEscapes],
            [[encodedParams componentsJoinedByString:@"&"] stringByAddingUrlPercentEscapes]];

    // We have no Oauth token secret, so the second part of the signing key is just ""
    NSString *signingKey = [NSString stringWithFormat:@"%@&",
            [self.consumerSecret stringByAddingUrlPercentEscapes]];

    NSString *signature = [self signBaseString:baseString withKey:signingKey];

    return signature;
}

- (NSString *)authorizationHeaderString:(NSDictionary *)params {
    NSArray *keys = [params allKeys];
    NSMutableArray *authorizationParams = [NSMutableArray arrayWithCapacity:[keys count]];

    for (NSUInteger i = 0; i < params.count; ++i) {
        NSString *key = keys[i];
        NSString *value = params[key];

        [authorizationParams addObject:[NSString stringWithFormat:@"%@=\"%@\"", [key stringByAddingUrlPercentEscapes],
              [value stringByAddingUrlPercentEscapes]]];
    }

    return [NSString stringWithFormat:@"OAuth %@", [authorizationParams componentsJoinedByString:@", "]];
}

- (NSString *)signBaseString:(NSString *)paramString withKey:(NSString *)key {
    unsigned char buf[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, [key UTF8String], [key length], [paramString UTF8String], [paramString length], buf);

    NSData *data = [NSData dataWithBytes:buf length:CC_SHA1_DIGEST_LENGTH];
    return [data JRBase64EncodedString];
}

- (NSString *)oauthNonce {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault,uuid);
    CFRelease(uuid);
    return [(NSString *)uuidString autorelease];
}

- (NSString *)secondsSinceEpoch {
    return [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.backgroundView removeFromSuperview];
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        self.completion([JREngageError errorWithMessage:@"Native Twitter authentication canceled"
                                                andCode:JRAuthenticationCanceledError]);
    } else if (buttonIndex >= 0) {
        self.accountToSignInWith = [self.accounts objectAtIndex:(NSUInteger)buttonIndex];
        if ([self.accounts count] == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:self.accountToSignInWith.identifier
                                                      forKey:kJRLastUsedTwitterAccount];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self doReverseAuthParametersRequest];
    }
}

- (void)dealloc {
    [_accountStore release];
    [_backgroundView release];
    [_accounts release];
    [_accountToSignInWith release];

    [super dealloc];
}

@end