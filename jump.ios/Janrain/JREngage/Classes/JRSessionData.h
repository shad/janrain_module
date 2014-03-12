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

 File:   JRSessionData.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/JSONKit.h>
#else
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/JSONKit.h>
#else

#endif
#endif

#import "SFHFKeychainUtils.h"
#import "JRConnectionManager.h"
#import "JRActivityObject.h"

@protocol JRUserInterfaceDelegate <NSObject>
- (void)userInterfaceWillClose;

- (void)userInterfaceDidClose;
@end

@interface JRAuthenticatedUser : NSObject <NSCoding>
@property(nonatomic, readonly) NSString *photo;
@property(nonatomic, readonly) NSString *displayName;
@property(nonatomic, readonly) NSString *preferredUsername;
@property(nonatomic, readonly) NSString *deviceToken;
@property(nonatomic, readonly) NSString *providerName;
@property(nonatomic, copy) NSString *welcomeString;
@end

@interface JRProvider : NSObject <NSCoding>
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *friendlyName;
@property(nonatomic, readonly) NSString *shortText;
@property(nonatomic, readonly) NSString *placeholderText;
@property(nonatomic, readonly) BOOL requiresInput;
@property(nonatomic) BOOL forceReauthStartUrlFlag;
@property(nonatomic, retain) NSString *userInput;
@property(nonatomic, readonly) NSDictionary *socialSharingProperties;
@property(nonatomic, readonly) NSArray *cookieDomains;
@property(nonatomic, retain) NSString *customUserAgentString;
@property(nonatomic) BOOL usesPhoneUserAgentString;
@property(nonatomic, retain) NSString *samlName;

@property(nonatomic, retain) NSString *opxBlob; // already URL encoded

- (BOOL)isEqualToReturningProvider:(NSString *)returningProvider;
- (void)clearCookiesOnCookieDomains;

- (void)forceReauth;
@end

@protocol JRSessionDelegate <NSObject>
@optional
- (void)authenticationDidRestart;

- (void)authenticationDidCancel;

- (void)authenticationDidCompleteForUser:(NSDictionary *)profile forProvider:(NSString *)provider;

- (void)authenticationDidSucceedForAccountLinking:(NSDictionary *)profile forProvider:(NSString *)provider;

- (void)authenticationDidFailWithError:(NSError *)error forProvider:(NSString *)provider;

- (void)authenticationDidReachTokenUrl:(NSString *)tokenUrl withResponse:(NSURLResponse *)response
                            andPayload:(NSData *)tokenUrlPayload forProvider:(NSString *)provider;

- (void)authenticationCallToTokenUrl:(NSString *)tokenUrl didFailWithError:(NSError *)error
                         forProvider:(NSString *)provider;

//- (void)publishingDidRestart;
- (void)publishingDidCancel;

- (void)publishingDidComplete;

- (void)publishingActivityDidSucceed:(JRActivityObject *)activity forProvider:(NSString *)provider;

- (void)publishingActivity:(JRActivityObject *)activity didFailWithError:(NSError *)error
               forProvider:(NSString *)provider;

- (void)urlShortenedToNewUrl:(NSString *)url forActivity:(JRActivityObject *)activity;
@end

@class JRActivityObject;

@interface JRSessionData : NSObject <JRConnectionManagerDelegate>
@property(retain) JRProvider *currentProvider;
@property(readonly) NSString *returningAuthenticationProvider;
@property(readonly) NSString *returningSharingProvider;

/** engageProviders is a dictionary of JRProviders, where each JRProvider contains the information specific to that
    provider. authenticationProviders and sharingProviders are arrays of NSStrings, each string being the primary key
    in engageProviders for that provider, representing the list of providers to be used in authentication and social
    publishing. The arrays are in the order configured by the RP on http://rpxnow.com. */
@property(readonly, retain) NSMutableDictionary *engageProviders;
@property(readonly, retain) NSArray *authenticationProviders;
@property(readonly, retain) NSArray *sharingProviders;

@property(copy) JRActivityObject *activity;

@property(copy) NSString *tokenUrl;
@property(readonly) NSString *baseUrl;

@property(readonly) BOOL hidePoweredBy;
@property BOOL alwaysForceReauth;
@property BOOL socialSharing;
@property BOOL authenticationFlowIsInFlight;
@property BOOL nativeAuthenticationFlowIsInFlight;
@property BOOL accountLinking;
@property(retain, readonly) NSError *error;

+ (JRSessionData *)jrSessionData;

+ (JRSessionData *)jrSessionDataWithAppId:(NSString *)newAppId tokenUrl:(NSString *)newTokenUrl
                 andDelegate:(id <JRSessionDelegate>)newDelegate;

- (void)tryToReconfigureLibrary;

- (id)reconfigureWithAppId:(NSString *)newAppId tokenUrl:(NSString *)newTokenUrl;

- (void)addDelegate:(id <JRSessionDelegate>)delegateToAdd;

- (void)removeDelegate:(id <JRSessionDelegate>)delegateToRemove;

- (NSURL *)startUrlForCurrentProvider;

- (JRProvider *)getProviderNamed:(NSString *)name;

- (JRAuthenticatedUser *)authenticatedUserForProvider:(JRProvider *)provider;

- (JRAuthenticatedUser *)authenticatedUserForProviderNamed:(NSString *)provider;

- (void)forgetAuthenticatedUserForProvider:(NSString *)providerName;

- (NSDictionary *)allProviders;

- (void)forgetAllAuthenticatedUsers;

- (BOOL)weShouldBeFirstResponder;

- (void)shareActivityForUser:(JRAuthenticatedUser *)user;

- (void)setStatusForUser:(JRAuthenticatedUser *)user;

- (void)triggerAuthenticationDidCompleteWithPayload:(NSDictionary *)payloadDict;

- (void)triggerAuthenticationDidStartOver:(id)sender;

- (void)triggerAuthenticationDidCancel;

- (void)triggerAuthenticationDidCancel:(id)sender;

- (void)triggerAuthenticationDidTimeOutConfiguration;

- (void)triggerAuthenticationDidFailWithError:(NSError *)theError;

- (void)triggerPublishingDidCancel;

- (void)triggerPublishingDidCancel:(id)sender;

- (void)triggerPublishingDidTimeOutConfiguration;

- (void)triggerPublishingDidFailWithError:(NSError *)theError;

- (void)triggerEmailSharingDidComplete;

- (void)triggerSmsSharingDidComplete;

- (void)setCustomProvidersWithDictionary:(NSDictionary *)customProviders __unused;

- (void)clearReturningAuthenticationProvider;
@end

