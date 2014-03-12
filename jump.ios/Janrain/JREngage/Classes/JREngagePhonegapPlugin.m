/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

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

 File:   JREngagePhonegapPlugin.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Wednesday, January 4th, 2012
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef JR_ENABLE_CORDOVA_PLUGIN

#import "JREngagePhonegapPlugin.h"
#import "JREngageError.h"
#import "JRActivityObject.h"
#import "JRConnectionManager.h"
#import "debug_log.h"
#import "CDVJSON.h"

@interface JREngagePhonegapPlugin ()
@property(nonatomic, retain) NSMutableDictionary *fullAuthenticationResponse;
@property(nonatomic, retain) NSMutableDictionary *fullSharingResponse;
@property(nonatomic, retain) NSMutableArray *authenticationBlobs;
@property(nonatomic, retain) NSMutableArray *shareBlobs;
@end

@implementation JREngagePhonegapPlugin
@synthesize callbackID;
@synthesize fullAuthenticationResponse;
@synthesize fullSharingResponse;
@synthesize authenticationBlobs;
@synthesize shareBlobs;
@synthesize shareInProgress = _shareInProgress;

- (id)init
{
    if ((self = [super init]))
    {

    }
    return self;
}

- (void)print:(CDVInvokedUrlCommand *)command
{
    self.callbackID = command.callbackId;

    DLog(@"print arguments: %@", command);

    NSString *printString = [command.arguments objectAtIndex:0];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:printString];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
}

- (void)resetPluginState
{
    self.shareInProgress = NO;
    self.fullAuthenticationResponse = nil;
    self.fullSharingResponse = nil;
    self.authenticationBlobs = nil;
    self.shareBlobs = nil;
}

- (void)finishWithSuccessMessage:(NSString *)message
{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:message];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
    [self resetPluginState];
}

- (void)finishWithFailureMessage:(NSString *)message
{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                      messageAsString:message];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
    [self resetPluginState];
}

- (NSString *)stringFromError:(NSError *)error
{
    NSMutableDictionary *errorResponse = [NSMutableDictionary dictionary];

    [errorResponse setObject:[NSNumber numberWithInt:error.code] forKey:@"code"];
    [errorResponse setObject:error.localizedDescription forKey:@"message"];
    [errorResponse setObject:@"fail" forKey:@"stat"];

    return [errorResponse JSONString];
}

- (NSString *)stringFromCode:(NSInteger)code andMessage:(NSString *)message
{
    NSMutableDictionary *errorResponse = [NSMutableDictionary dictionary];

    [errorResponse setObject:[NSNumber numberWithInt:code] forKey:@"code"];
    [errorResponse setObject:message forKey:@"message"];
    [errorResponse setObject:@"fail" forKey:@"stat"];

    return [errorResponse JSONString];
}

- (void)saveAuthenticationBlob
{
    if (!authenticationBlobs)
        self.authenticationBlobs = [NSMutableArray array];

    [authenticationBlobs addObject:fullAuthenticationResponse];

    self.fullAuthenticationResponse = nil;
}

- (void)initializeJREngage:(CDVInvokedUrlCommand *)command __unused
{
    DLog(@"");

    self.callbackID = command.callbackId;

    NSString *engageAppId = [command.arguments objectAtIndex:0];

    if (!engageAppId)
    {
        [self finishWithFailureMessage:[self stringFromCode:JRMissingAppIdError
                                                 andMessage:@"Missing appId in call to initialize"]];
        return;
    }
    
    NSString *tokenUrl = ((id)[command.arguments objectAtIndex:1] == [NSNull null]) ? nil : [command.arguments objectAtIndex:1];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/JREngage-Info.plist"];
    NSMutableDictionary *infoPlist =
            [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];

    NSMutableString *ver = [NSMutableString stringWithString:[infoPlist objectForKey:@"CFBundleShortVersionString"]];

    if (![ver hasSuffix:@":cordova"])
        [ver appendString:@":cordova"];

    [infoPlist setObject:ver forKey:@"CFBundleShortVersionString"];
    [infoPlist writeToFile:path atomically:YES];

    [JREngage setEngageAppId:engageAppId tokenUrl:tokenUrl andDelegate:self];

    [self finishWithSuccessMessage:@"{'stat':'ok','message':'Initializing JREngage...'}"];
}

- (void)showAuthenticationDialog:(CDVInvokedUrlCommand *)command __unused
{
    DLog(@"");

    self.callbackID = command.callbackId;

    [JREngage showAuthenticationDialog];
}

- (void)showSharingDialog:(CDVInvokedUrlCommand *)command __unused
{
    DLog(@"");

    self.callbackID = command.callbackId;
    self.shareInProgress = YES;

    NSDictionary *activity = [command.arguments objectAtIndex:0];
    if (!activity)
    {
        [self finishWithFailureMessage:[self stringFromCode:JRPublishErrorActivityNil
                                                 andMessage:@"Activity object is required and cannot be null"]];

        return;
    }

    JRActivityObject *activityObject = [JRActivityObject activityObjectFromDictionary:activity];
    if (!activityObject)
    {
        [self finishWithFailureMessage:[self stringFromCode:JRPublishErrorBadActivityJson
                                                 andMessage:@"The JSON passed was not a valid activity object"]];

        return;
    }

    [JREngage showSharingDialogWithActivity:activityObject];
}

- (void)engageDialogDidFailToShowWithError:(NSError *)error
{
    DLog(@"");
    [self finishWithFailureMessage:[self stringFromError:error]];
}

- (void)authenticationDidNotComplete
{
    DLog(@"");
    [self finishWithFailureMessage:[self stringFromCode:JRAuthenticationCanceledError
                                             andMessage:@"User canceled authentication"]];
}

- (void)authenticationDidFailWithError:(NSError *)error forProvider:(NSString *)provider
{
    DLog(@"");

    if (!self.shareInProgress)
        [self finishWithFailureMessage:[self stringFromError:error]];
}

- (void)authenticationCallToTokenUrl:(NSString *)tokenUrl didFailWithError:(NSError *)error
                         forProvider:(NSString *)provider
{
    DLog(@"");

    if (!self.shareInProgress)
        [self finishWithFailureMessage:[self stringFromError:error]];
}

- (void)authenticationDidSucceedForUser:(NSDictionary *)authInfo forProvider:(NSString *)provider
{
    DLog(@"");

    NSMutableDictionary *newAuthInfo = [NSMutableDictionary dictionaryWithDictionary:authInfo];
    [newAuthInfo removeObjectForKey:@"stat"];

    self.fullAuthenticationResponse = [NSMutableDictionary dictionary];

    [fullAuthenticationResponse setObject:newAuthInfo forKey:@"auth_info"];
    [fullAuthenticationResponse setObject:provider forKey:@"provider"];
    if (![JREngage tokenUrl])
    {
        self.fullAuthenticationResponse = [self authinfoResponseWithStuff:fullAuthenticationResponse
                                                                 tokenUrl:nil payloadString:nil];
        NSString *authResponseString = [self.fullAuthenticationResponse JSONString];

        if (self.shareInProgress)
            [self saveAuthenticationBlob];
        else
            [self finishWithSuccessMessage:authResponseString];
    }
}

- (NSMutableDictionary *)authinfoResponseWithStuff:(NSMutableDictionary *)dictionary
                                          tokenUrl:(NSString *)tokenUrl
                                     payloadString:(NSString *)payloadString
{
    NSMutableDictionary *r = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [r setObject:tokenUrl ? tokenUrl : (void *) kCFNull forKey:@"tokenUrl"];
    [r setObject:(payloadString ? payloadString : (void *) kCFNull) forKey:@"tokenUrlPayload"];
    [r setObject:@"ok" forKey:@"stat"];
    return r;
}

- (void)authenticationDidReachTokenUrl:(NSString *)tokenUrl withResponse:(NSURLResponse *)response
                            andPayload:(NSData *)tokenUrlPayload forProvider:(NSString *)provider
{
    DLog(@"");

    // TODO: Will this ever happen, and if so, what should we do?
    if (!fullAuthenticationResponse) ALog(@"JREngage error");

    NSString *payloadString = [[[NSString alloc] initWithData:tokenUrlPayload
                                                     encoding:NSUTF8StringEncoding] autorelease];

    self.fullAuthenticationResponse = [self authinfoResponseWithStuff:self.fullAuthenticationResponse
                                                             tokenUrl:tokenUrl
                                                        payloadString:payloadString];

    NSString *authResponseString = [self.fullAuthenticationResponse JSONString];

    if (self.shareInProgress)
        [self saveAuthenticationBlob];
    else
        [self finishWithSuccessMessage:authResponseString];
}

- (void)sharingDidFailForActivity:(JRActivityObject *)activity withError:(NSError *)error
                      forProvider:(NSString *)provider
{
    DLog(@"");

    NSDictionary *shareBlob =
            [NSDictionary dictionaryWithObjectsAndKeys:
                                  provider, @"provider",
                                  @"fail", @"stat",
                                  [NSString stringWithFormat:@"%d", error.code], @"code",
                                  error.localizedDescription, @"message", nil];

    if (!shareBlobs)
        self.shareBlobs = [NSMutableArray array];

    [shareBlobs addObject:shareBlob];
}

- (void)sharingDidSucceedForActivity:(JRActivityObject *)activity forProvider:(NSString *)provider
{
    DLog(@"");

    NSDictionary *shareBlob = [NSDictionary dictionaryWithObjectsAndKeys:provider, @"provider", @"ok", @"stat", nil];

    if (!shareBlobs)
        self.shareBlobs = [NSMutableArray array];

    [shareBlobs addObject:shareBlob];
}

- (void)sharingDidComplete
{
    DLog(@"");

    if (!fullSharingResponse)
        self.fullSharingResponse = [NSMutableDictionary dictionary];

    if (authenticationBlobs)
        [fullSharingResponse setObject:authenticationBlobs forKey:@"signIns"];

    if (shareBlobs)
        [fullSharingResponse setObject:shareBlobs forKey:@"shares"];

    [self finishWithSuccessMessage:[fullSharingResponse JSONString]];
}

- (void)sharingDidNotComplete
{
    DLog(@"");

    /* If there have been ANY shares (successful or otherwise) or any auths, call jrSocialDidCompletePublishing */
    if (authenticationBlobs || shareBlobs)
        return [self sharingDidComplete];


    [self finishWithFailureMessage:[self stringFromCode:JRPublishCanceledError
                                             andMessage:@"User canceled sharing"]];
}

- (void)dealloc
{
    [fullAuthenticationResponse release];
    [fullSharingResponse release];
    [authenticationBlobs release];
    [super dealloc];
}
@end

#endif
