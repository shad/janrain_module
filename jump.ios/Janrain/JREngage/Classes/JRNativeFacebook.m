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

#import <objc/message.h>
#import "JRNativeFacebook.h"
#import "debug_log.h"
#import "JREngageError.h"

@interface JRNativeFacebook ()
@end

@implementation JRNativeFacebook {
}

+ (BOOL)canHandleAuthentication {
    return NSClassFromString(@"FBSession") ? YES : NO;
}

- (NSString *)provider {
    return @"facebook";
}

- (void)startAuthenticationWithCompletion:(NativeCompletionBlock)completion {
    [super startAuthenticationWithCompletion:completion];

    Class fbSession = NSClassFromString(@"FBSession");
    SEL activeSessionSelector = NSSelectorFromString(@"activeSession");
    id (*getActiveSession)(id, SEL) = (void *)[fbSession methodForSelector:activeSessionSelector];
    id fbActiveSession = getActiveSession(fbSession, activeSessionSelector);

    SEL stateSelector = NSSelectorFromString(@"state");
    unsigned int (*getState)(id, SEL) = (void *)[fbActiveSession methodForSelector:stateSelector];
    unsigned int fbState = getState(fbActiveSession, stateSelector);

    // We don't always have access to the Facebook headers,
    // so we'll use the actual values of the states instead of their names
    // #define FB_SESSIONSTATEOPENBIT (1 << 9)
    // #define FB_SESSIONSTATETERMINALBIT (1 << 9)
    if (fbState & (1 << 9)) {
        id accessToken = [self getAccessToken:fbActiveSession];
        [self getAuthInfoTokenForAccessToken:accessToken];
    } else {
        void (^handler)(id, unsigned int, NSError *) =
                ^(id session, unsigned int state, NSError *error) {
                    DLog(@"session %@ state %d error %@", session, state, error);
                    switch (state) {
                        case (1 | (1 << 9)): {// Open
                                DLog(@"Facebook Session Open: %@", session);
                                id accessToken = [self getAccessToken:session];
                                [self getAuthInfoTokenForAccessToken:accessToken];
                            }
                            break;
                        case (1 | (1 << 8)): // Closed Login Failed
                            DLog(@"Facebook Session Closed/Login Failed: %@, error: %@", session, error);
                            if (error && [self getErrorCategory:error] == 6) { // Canceled
                                NSError *canceledError = [JREngageError errorWithMessage:@"native fb auth canceled"
                                                                       andCode:JRAuthenticationCanceledError];
                                self.completion(canceledError);
                            } else {
                                self.completion(error);
                            }
                        case (2 | (1 << 8)): // Closed
                            DLog(@"Facebook Session Closed: %@", session);
                            break;
                        default:
                            break;
                    }
                };
        objc_msgSend(
                fbSession,
                NSSelectorFromString(@"openActiveSessionWithReadPermissions:allowLoginUI:completionHandler:"),
                @[
                @"public_profile",
                @"email",
                @"user_friends",
                @"user_about_me",
                @"user_birthday",
                @"user_location",
                @"user_photos",
                @"read_friendlists"
                ], YES, handler);
    }
}

- (id)getAccessToken:(id)fbActiveSession
{
    SEL accessTokenDataSelector = NSSelectorFromString(@"accessTokenData");
    id (*getAccessTokenData)(id, SEL) = (void *)[fbActiveSession methodForSelector:accessTokenDataSelector];
    id accessTokenData = getAccessTokenData(fbActiveSession, accessTokenDataSelector);

    SEL accessTokenSelector = NSSelectorFromString(@"accessToken");
    id (*getToken)(id, SEL) = (void *)[accessTokenData methodForSelector:accessTokenSelector];
    id accessToken = getToken(accessTokenData, accessTokenSelector);
    return accessToken;
}

- (int)getErrorCategory:(NSError *)error {
    Class fbErrorUtilityClass = NSClassFromString(@"FBErrorUtility");
    SEL fbErrorCategoryForErrorSelector = NSSelectorFromString(@"errorCategoryForError:");
    int (*getErrorCategory)(id, SEL, NSError *) =
            (void *)[fbErrorUtilityClass methodForSelector:fbErrorCategoryForErrorSelector];
    return getErrorCategory(fbErrorUtilityClass, fbErrorCategoryForErrorSelector, error);
}

+ (BOOL)urlHandler:(NSURL *)url {
    Class fbSession = NSClassFromString(@"FBSession");

    if (fbSession) {
        SEL activeSessionSelector = NSSelectorFromString(@"activeSession");
        id (*getActiveSession)(id, SEL) = (void *)[fbSession methodForSelector:activeSessionSelector];
        id activeSession = getActiveSession(fbSession, activeSessionSelector);

        SEL urlHandlerSelector = NSSelectorFromString(@"handleOpenURL:");
        BOOL (*urlHandler)(id, SEL, NSURL *) = (void *)[activeSession methodForSelector:urlHandlerSelector];
        return urlHandler(activeSession, urlHandlerSelector, url);
    }

    return NO;
}


@end
