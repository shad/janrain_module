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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>

/**
 * @defgroup engageErrors Engage Errors
 *
 * Engage-related error codes and explanations that you may receive through the delegate methods of the
 * JREngageSigninDelegate and JREngageSharingDelegate.
 *
 * @{
 **/

typedef enum
{
    ConfigurationError = 1,
    AuthenticationError = 2,
    SocialSharingError = 3,
} JRErrorCategory;

/**
 * Errors received on the JREngageSigninDelegate and JREngageSharingDelegate protocols when configuration has failed.
 **/
typedef enum
{
    JRUrlError = 100,                     /**< Url error */
    JRDataParsingError,                   /**< Data parsing error */
    JRJsonError,                          /**< JSON error */
    JRConfigurationInformationError,      /**< Configuration error */
    JRSessionDataFinishGetProvidersError, /**< Configuration error */
    JRDialogShowingError,                 /**< Error show the dialog */
    JRProviderNotConfiguredError,         /**< Provider not configured error */
    JRMissingAppIdError,                  /**< Missing App ID error */
    JRGenericConfigurationError,          /**< Generic configuration error */
} JREngageConfigurationError;

/**
 * Errors received on the JREngageSigninDelegate and JREngageSharingDelegate protocols when sign-in has failed.
 **/
typedef enum
{
    JRAuthenticationFailedError = 200,   /**< Authentication failed error */
    JRAuthenticationTokenUrlFailedError, /**< Token URL failed error */
    JRAuthenticationCanceledError,       /**< Authentication canceled */
    JRAuthenticationNativeAuthError,     /**< Native authentication error */
    JRAuthenticationShouldTryWebViewError, /**< Native auth failed, but we should attempt UIWebView authentication */
    JRAuthenticationNoAccessToTwitterAccountsError /**< Native auth failed, no access to twitter accounts*/
    // TODO: Add the token url error where appropriate
} JREngageAuthenticationError;

/**
 * Errors received on the JREngageSharingDelegate protocol when sharing has failed.
 *
 * Many of these errors correspond to the errors listed on the
 * <a href="http://developers.janrain.com/documentation/engage/reference/error-responses/">
 *     Engage Error Reponses Page</a>
 **/
typedef enum
{
    JRPublishFailedError = 300,           /**< Sharing failed error */
    JRPublishErrorActivityNil,            /**< Activity was \e nil error */
    JRPublishErrorBadActivityJson,        /**< JSON error */
    JRPublishCanceledError,               /**< Sharing was canceled */
    JRPublishErrorBadConnection,          /**< Bad connection error */
    JRPublishErrorMissingParameter,       /**< Missing parameters error */
    JRPublishErrorMissingApiKey,
    JRPublishErrorCharacterLimitExceeded, /**< Character limit exceeded error */
    JRPublishErrorFacebookGeneric,        /**< Generic Facebook error */
    JRPublishErrorInvalidFacebookSession, /**< Invalid Facebook session error */
    JRPublishErrorInvalidFacebookMedia,   /**< Invalid Facebook media error */
    //JRPublishErrorInvalidFacebookActionLinks/Properties,
    JRPublishErrorTwitterGeneric,         /**< Generic Twitter error */
    JRPublishErrorDuplicateTwitter,       /**< Twitter error, cannot send duplicate tweet */
    JRPublishErrorLinkedInGeneric,        /**< Generic LinkedIn error */
    JRPublishErrorMyspaceGeneric,         /**< Generic MySpace error */
    JRPublishErrorYahooGeneric,           /**< Generic Yahoo! error */
    JRPublishErrorFeedActionRequestLimit, /**< Request limit was reached for feed action */ // TODO: Add a test for this
    JRPublishErrorInvalidOauthKey, /* Will be deprecating */
    JRPublishErrorLinkedInCharacterExceeded, /* Will be deprecating */
} JREngageSocialPublishingError;

extern NSString * JREngageErrorDomain;

@interface JREngageError : NSObject
+ (NSError *)errorWithMessage:(NSString *)message andCode:(NSInteger)code;
@end
/** @}*/
