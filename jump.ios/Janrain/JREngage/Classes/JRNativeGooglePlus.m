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

#import "JRNativeGooglePlus.h"
#import "debug_log.h"

@implementation JRNativeGooglePlus

+ (BOOL)canHandleAuthentication {
    return NSClassFromString(@"GPPSignIn") ? YES : NO;
}

- (NSString *)provider {
    return @"googleplus";
}

- (void)startAuthenticationWithCompletion:(NativeCompletionBlock)completion {
    [super startAuthenticationWithCompletion:completion];

    id signIn = [self signInInstance];
    SEL setClientIDSelector = NSSelectorFromString(@"setClientID:");
    void (*setClientID)(id, SEL, NSString *) = (void *)[signIn methodForSelector:setClientIDSelector];
    setClientID(signIn, setClientIDSelector, self.googlePlusClientId);

    SEL setScopesSelector = NSSelectorFromString(@"setScopes:");
    void (*setScopes)(id, SEL, NSArray *) = (void *)[signIn methodForSelector:setScopesSelector];
    setScopes(signIn, setScopesSelector, self.scopes);
    SEL setDelegateSelector = NSSelectorFromString(@"setDelegate:");
    void (*setDelegate)(id, SEL, id) = (void *)[signIn methodForSelector:setDelegateSelector];
    setDelegate(signIn, setDelegateSelector, self);

    SEL authenticateSelector = NSSelectorFromString(@"authenticate");
    void (*authenticate)(id, SEL) = (void *)[signIn methodForSelector:authenticateSelector];
    authenticate(signIn, authenticateSelector);
}

- (NSArray *)scopes {
    return @[@"https://www.googleapis.com/auth/plus.login"];
}

- (void)finishedWithAuth:(id)auth error:(NSError *)error __unused {
    if (error) {
        DLog(@"Google+ received error %@",error);
        self.completion(error);
    } else {
        DLog(@"Google+ received auth object %@", auth);
        SEL accessTokenSelector = NSSelectorFromString(@"accessToken");
        id (*getAccessToken)(id, SEL) = (void *)[auth methodForSelector:accessTokenSelector];
        id accessToken = getAccessToken(auth, accessTokenSelector);
        [self getAuthInfoTokenForAccessToken:(NSString *)accessToken];
    }
}

- (id)signInInstance {
    Class signInClass = NSClassFromString(@"GPPSignIn");
    SEL getInstanceSelector = NSSelectorFromString(@"sharedInstance");
    id (*getInstance)(id, SEL) = (void *)[signInClass methodForSelector:getInstanceSelector];
    return getInstance(signInClass, getInstanceSelector);
}

+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(NSString *)annotation {
    Class gPPURLHandler = NSClassFromString(@"GPPURLHandler");

    if (gPPURLHandler) {
        SEL urlHandlerSel = NSSelectorFromString(@"handleURL:sourceApplication:annotation:");
        BOOL (*urlHandler)(id, SEL, NSURL *, NSString *, id) = (void *)[gPPURLHandler methodForSelector:urlHandlerSel];
        return urlHandler(gPPURLHandler, urlHandlerSel, url, sourceApplication, annotation);
    }

    return NO;
}


@end