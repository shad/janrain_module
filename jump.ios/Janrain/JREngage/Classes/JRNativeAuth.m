/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

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

#import "JRNativeAuth.h"
#import "debug_log.h"
#import "JRConnectionManager.h"
#import "JRNativeFacebook.h"
#import "JRNativeAuthConfig.h"
#import "JRNativeGooglePlus.h"
#import "JRNativeTwitter.h"

@interface JRNativeAuth ()
@property (nonatomic, retain) JRNativeProvider *nativeProvider;
@end

@implementation JRNativeAuth

+ (BOOL)canHandleProvider:(NSString *)provider
{
    if ([provider isEqualToString:@"facebook"] && [JRNativeFacebook canHandleAuthentication]) return YES;
    else if ([provider isEqualToString:@"googleplus"] && [JRNativeGooglePlus canHandleAuthentication]) return YES;
    else if ([provider isEqualToString:@"twitter"] && [JRNativeTwitter canHandleAuthentication]) return YES;

    return NO;
}

+ (JRNativeProvider *)nativeProviderNamed:(NSString *)provider withConfiguration:(id <JRNativeAuthConfig>)config {
    JRNativeProvider *nativeProvider = nil;

    if ([provider isEqualToString:@"facebook"]) {
        nativeProvider = [[[JRNativeFacebook alloc] init] autorelease];
    } else if ([provider isEqualToString:@"googleplus"]) {
        nativeProvider = [[[JRNativeGooglePlus alloc] init] autorelease];
        [(JRNativeGooglePlus *)nativeProvider setGooglePlusClientId:config.googlePlusClientId];
    } else if ([provider isEqualToString:@"twitter"]) {
        nativeProvider = [[[JRNativeTwitter alloc] init] autorelease];
        [(JRNativeTwitter *)nativeProvider setConsumerKey:config.twitterConsumerKey];
        [(JRNativeTwitter *)nativeProvider setConsumerSecret:config.twitterConsumerSecret];
    } else {
        [NSException raiseJRDebugException:@"unexpected native auth provider" format:provider];
    }

    return nativeProvider;
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([JRNativeFacebook urlHandler:url]) return YES;
    if ([JRNativeGooglePlus handleURL:url sourceApplication:sourceApplication annotation:annotation]) return YES;

    return NO;
}


@end