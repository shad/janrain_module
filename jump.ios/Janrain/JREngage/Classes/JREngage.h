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

 File:   JREngage.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/**
 * @mainpage Janrain Engage for iOS, version 2
 *
 * <a href="http://TODO">
 * The Janrain User Management Platform for iOS SDK</a> makes it easy to include third party authentication and
 * social sharing in your iPhone or iPad applications. This Objective-C library includes the same key
 * features as our web version, as well as additional features created specifically for the mobile
 * platform. With as few as three lines of code, you can authenticate your users with their
 * accounts on Google, Yahoo!, Facebook, etc., and they can immediately publish their
 * activities to multiple social networks, including Facebook, Twitter, LinkedIn, MySpace,
 * and Yahoo!, through one simple interface.
 *
 * Before you begin, you need to have created a
 * <a href="https://rpxnow.com/signup_createapp_plus">Janrain Engage application</a>,
 * which you can do on <a href="http://rpxnow.com">http://rpxnow.com</a>
 *
 * For an overview of how the library works and how you can take advantage of the library's
 * features, please see the <a href="http://TODO">
 *   Overview</a> section of our documentation.
 *
 * To begin using the library, please see the <a href="http://TODO">
 * Engage for iOS guide</a>.
 *
 * For more detailed documentation of the library's API, you can use
 * the <a href="http://TODO">
 *   JREngage API</a> or <a href="http://TODO">
 *   JRCapture API</a> documentation.
 **/

#if  __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
#error Incompatible deployment target - should be 5.0 or higher
#endif


/* Preprocessor directive that conditionally compiles the code that uses the weakly-linked MessageUI.Framework.
 This framework is required if you want to include the ability to share activities with email or SMS. By default
 the JRENGAGE_INCLUDE_EMAIL_SMS flag should always be set to "1", which can cause errors with the linker if the
 framework isn't included, but it's figured most apps would want the email and SMS sharing ability. If you don't want
 to add the MessageUI.Framework to one or more of your apps that use the JREngage library, you don't have to change
 this value to "0" (which could cause merging issues if I make changes later).

 Instead, if you want to override this setting, you need to add the preprocessor flag "OVERRIDE_INCLUDE_EMAIL_SMS"
 to your target's GCC_PREPROCESSOR_DEFINITIONS build setting (also listed as "Preprocessor Macros" under the
 "GCC 4.2 - Preprocessing" heading). */
#ifndef OVERRIDE_INCLUDE_EMAIL_SMS
#define JRENGAGE_INCLUDE_EMAIL_SMS 1
#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "JRNativeAuthConfig.h"

@class JRActivityObject;

/**
 * @brief
 * Protocol adopted by an object that wishes to receive notifications when and information about a
 * user that authenticates with your application.
 *
 * This protocol will notify the delegate(s) when authentication succeeds or fails,
 * it will provide the delegate(s) with the authenticated user's profile data, and, if server-side
 * authentication is desired, it can provide the delegate(s) with the data payload returned by your
 * server's token URL.
 **/
@protocol JREngageSigninDelegate <NSObject>
@optional

/**
 * @name Configuration
 * Messages sent by JREngage during dialog launch/configuration
 **/
/*@{*/

/**
 * Sent if the application tries to show a JREngage dialog, and JREngage failed to show. May
 * occur if the JREngage library failed to configure, or if the activity object was nil, etc.
 *
 * @param error
 *   The error that occurred during configuration. Please see the list of \ref engageErrors "Engage Errors" for more
 *   information
 *
 * @note
 * This message is only sent if your application tries to show a JREngage dialog, and not necessarily
 * when an error occurs, if, say, the error occurred during the library's configuration. The raison d'etre
 * is based on the possibility that your application may preemptively configure JREngage, but never actually
 * use it. If that is the case, then you won't get any error.
 **/
- (void)engageDialogDidFailToShowWithError:(NSError *)error;
/*@}*/

/**
 * @name Authentication
 * Messages sent by JREngage during authentication
 **/
/*@{*/

/**
 * Sent if the authentication was canceled for any reason other than an error. For example,
 * the user hits the "Cancel" button, any class (e.g., the %JREngage delegate) calls the
 * JREngage#cancelAuthentication message, or if configuration of the library is taking more
 * than about 16 seconds (rare) to download.
 **/
- (void)authenticationDidNotComplete;

/**
 * Tells the delegate that the user has successfully authenticated with the given provider, passing to
 * the delegate an \e NSDictionary object with the user's profile data.
 *
 * @param authInfo
 *   An \e NSDictionary of fields containing all the information Janrain Engage knows about the user
 *   logging into your application. Includes the field \c "profile" which contains the user's profile information
 *
 * @param provider
 *   The name of the provider on which the user authenticated. For a list of possible strings,
 *   please see the \ref authenticationProviders "List of Providers"
 *
 * @par Example:
 *   The structure of the auth_info dictionary (represented here in json) should look something like
 *   the following:
 * @code
 "auth_info":
 {
   "profile":
   {
     "displayName": "brian",
     "preferredUsername": "brian",
     "url": "http:\/\/brian.myopenid.com\/",
     "providerName": "Other",
     "identifier": "http:\/\/brian.myopenid.com\/"
   }
 }
 * @endcode
 *
 *
 * @sa
 * For a full description of the dictionary and its fields, please see the
 * <a href="http://developers.janrain.com/documentation/api/auth_info/">auth_info response</a>
 * section of the Janrain Engage API documentation.
 **/
- (void)authenticationDidSucceedForUser:(NSDictionary *)authInfo forProvider:(NSString *)provider;

/**
 * Sent when authentication failed and could not be recovered by the library.
 *
 * @param error
 *   The error that occurred during authentication. Please see the list of \ref engageErrors "Engage Errors" for more
 *   information
 *
 * @param provider
 *   The name of the provider on which the user tried to authenticate. For a list of possible strings,
 *   please see the \ref authenticationProviders "List of Providers"
 *
 * @note
 * This message is not sent if authentication was canceled. To be notified of a canceled authentication,
 * see authenticationDidNotComplete().
 **/
- (void)authenticationDidFailWithError:(NSError *)error forProvider:(NSString *)provider;

/**
 * Sent after JREngage has successfully posted the token to your application's tokenUrl, containing
 * the headers and body of the response from the server.
 *
 * @param tokenUrl
 *   The URL on the server where the token was posted and server-side authentication was completed
 *
 * @param response
 *   The final \e NSURLResponse returned from the server
 *
 * @param tokenUrlPayload
 *   The response from the server
 *
 * @param provider
 *   The name of the provider on which the user authenticated. For a list of possible strings,
 *   please see the \ref authenticationProviders "List of Providers"
 **/
- (void)authenticationDidReachTokenUrl:(NSString *)tokenUrl withResponse:(NSURLResponse *)response andPayload:(NSData *)tokenUrlPayload forProvider:(NSString *)provider;

/**
 * Sent when the call to the token URL has failed.
 *
 * @param tokenUrl
 *   The URL on the server where the token was posted and server-side authentication was completed
 *
 * @param error
 *   The error that occurred during server-side authentication. Please see the list of
 *   \ref engageErrors "Engage Errors" for more information
 *
 * @param provider
 *   The name of the provider on which the user authenticated. For a list of possible strings,
 *   please see the \ref authenticationProviders "List of Providers"
 **/
- (void)authenticationCallToTokenUrl:(NSString *)tokenUrl didFailWithError:(NSError *)error forProvider:(NSString *)provider;
/**
 * Sent when the Engage Authentication is completed successfully for Link Account Flow
 */
- (void)engageAuthenticationDidSucceedForAccountLinking:(NSDictionary *)engageAuthInfo forProvider:(NSString *)provider;
@end

#define JREngageDelegate JREngageSigninDelegate

/**
 * @brief
 * Protocol adopted by an object that wishes to receive notifications when and information about a
 * user that shares activities to their social networks.
 *
 * This protocol will notify the delegate(s) when authentication and social sharing succeed or fail.
 * The user will need to sign in to a provider, if they haven't already, to be able to share. If sign-in
 * occurs, this protocol will provide the delegate(s) with the authenticated user's profile data, and, if
 * server-side authentication is desired, it can provide the delegate(s) with the data payload returned by
 * your server's token URL.
 **/
@protocol JREngageSharingDelegate <JREngageSigninDelegate>
@optional

/**
 * @name SocialSharing
 * Messages sent by JREngage during social publishing
 **/
/*@{*/

/**
 * Sent if social sharing was canceled for any reason other than an error. For example, the user hits
 * the "Cancel" button, any class (e.g., the %JREngage delegate) calls the JREngage#cancelSharing
 * message, or if configuration of the library is taking more than about 16 seconds (rare) to download.
 **/
- (void)sharingDidNotComplete;

/**
 * Sent after the social sharing dialog is closed (e.g., the user hits the "Close" button) and sharing
 * is complete. You can receive multiple sharingDidSucceedForActivity:forProvider:()
 * messages before the dialog is closed and sharing is complete.
 **/
- (void)sharingDidComplete;

/**
 * Sent after the user successfully shares an activity on the given provider.
 *
 * @param activity
 *   The shared activity
 *
 * @param provider
 *   The name of the provider on which the user published the activity. For a list of possible strings,
 *   please see the \ref sharingProviders "List of Social Providers"
 **/
- (void)sharingDidSucceedForActivity:(JRActivityObject *)activity forProvider:(NSString *)provider;

/**
 * Sent when sharing an activity failed and could not be recovered by the library.
 *
 * @param activity
 *   The activity the user was trying to share
 *
 * @param error
 *   The error that occurred during sharing. Please see the list of \ref engageErrors "Engage Errors" for more
 *   information
 *
 * @param provider
 *   The name of the provider on which the user attempted to publish the activity. For a list of possible strings,
 *   please see the \ref sharingProviders "List of Social Providers"
 **/
- (void)sharingDidFailForActivity:(JRActivityObject *)activity withError:(NSError *)error forProvider:(NSString *)provider;
/*@}*/
@end

/**
 * Notification sent when the Engage configuration has been updated.
 */
extern NSString *const JRFinishedUpdatingEngageConfigurationNotification;
extern NSString *const JRFailedToUpdateEngageConfigurationNotification;

/**
 * @brief
 * Main API for interacting with the Janrain Engage for iOS library
 *
 * If you wish to include third-party authentication and social sharing in your iPhone or iPad
 * applications, you can use the JREngage class to achieve this. Prior to using the JREngage
 * library, you must already have an application on <a href="http://rpxnow.com">http://rpxnow.com</a>.
 * This is all that is required for basic authentication, although some providers may require extra
 * configuration (which can be done through your application's <a href="http://rpxnow.com/relying_parties">Dashboard</a>
 * For social sharing, you will need to configure your rpxnow application with the desired providers.
 *
 * If desired, you can optionally implement server-side authentication<span class="footnote">*</span>.
 * When provided, the JREngage library can post the user's authentication token to a url on your server:
 * the token URL. Your server can complete authentication, access more of JREngage's API, log the authentication, etc.
 * and the server's response will be passed back through to your iOS application.
 **/
@interface JREngage : NSObject <JRNativeAuthConfig>

/**
 * @name Get the JREngage Instance
 * Methods that initialize and return the shared JREngage instance
 **/
/*@{*/
/**
 * Initializes the JREngage library
 *
 * @param appId
 *   This is your 20-character application ID. You can find this on your application's Dashboard
 *   on <a href="http://rpxnow.com">http://rpxnow.com</a>. This value cannot be \e nil
 *
 * @param tokenUrl
 *   The URL on your server where you wish to complete authentication. If provided,
 *   the JREngage library will post the user's authentication token to this URL where it can
 *   used for further authentication and processing. When complete, the library will pass the
 *   server's response back to the your application
 *
 * @param delegate
 *   The delegate object that implements the JREngageSigninDelegate or JREngageSharingDelegate protocol
 *
 **/
+ (void)setEngageAppId:(NSString *)appId tokenUrl:(NSString *)tokenUrl
           andDelegate:(id <JREngageSigninDelegate>)delegate;

/**
 * Get the shared JREngage instance
 */
+ (JREngage *)instance;

/**
 * @deprecated
 * Use [JREngage setEngageAppId:TokenUrl:andDelegate] instead
 */
+ (JREngage *)jrEngageWithAppId:(NSString *)appId andTokenUrl:(NSString *)tokenUrl
                       delegate:(id <JREngageSigninDelegate>)delegate __attribute__((deprecated));
/*@}*/

/**
 *  Set the Google+ client id for use with native Google+ SSO
 *
 *  @param clientId
 *    Your google+ client id. Should be from the same Google+ app that is registered with Engage.
 */
+ (void)setGooglePlusClientId:(NSString *)clientId;

/**
 *  Set the Twitter consumer key and secret. This is required for native Twitter SSO.
 *  The values must match the values in your Engage Dashboard.
 *
 *  @param consumerKey
 *    Your Twitter consumer key
 *  @param consumerSecret
 *    Your Twitter consumer secret
 */
+ (void)setTwitterConsumerKey:(NSString *)consumerKey andSecret:(NSString *)consumerSecret;

/**
 * @name Manage the Delegates
 * Add/remove delegates that implement the JREngageSigninDelegate or JREngageSharingDelegate protocol
 **/
/*@{*/
/**
 * Add a JREngageSigninDelegate or JREngageSharingDelegate to the JREngage library.
 *
 * @param delegate
 *   The object that implements the JREngageSigninDelegate or JREngageSharingDelegate protocol
 **/
+ (void)addDelegate:(id<JREngageSigninDelegate>)delegate __unused;

/**
 * Remove a JREngageSigninDelegate or JREngageSharingDelegate from the JREngage library.
 *
 * @param delegate
 *   The object that implements the JREngageSigninDelegate or JREngageSharingDelegate protocol
 **/
+ (void)removeDelegate:(id<JREngageSigninDelegate>)delegate __unused;
/*@}*/

/**
 * @name Show the JREngage Dialogs
 * Methods that display JREngage's dialogs to initiate authentication and social sharing
 **/
/*@{*/
/**
 * Use this function to begin authentication. The JREngage library will
 * pop up a modal dialog and take the user through the sign-in process.
 **/
+ (void)showAuthenticationDialog __unused;

/**
 * Use this function to begin authentication for one specific provider. The JREngage library will
 * pop up a modal dialog, skipping the list of providers, and take the user straight to the sign-in
 * flow of the passed provider. The user will not be able to return to the list of providers.
 *
 * @param provider
 *   The name of the provider on which the user will authenticate. For a list of possible strings,
 *   please see the \ref authenticationProviders "List of Providers"
 **/
+ (void)showAuthenticationDialogForProvider:(NSString *)provider __unused;

/**
 * Use this function to begin authentication. The JREngage library will pop up a modal dialog,
 * configured with the given custom interface, and take the user through the sign-in process.
 *
 * @param customInterfaceOverrides
 *   A dictionary of objects and properties, indexed by the set of
 *   \link customInterface pre-defined custom interface keys\endlink,
 *   to be used by the library to customize the look and feel of the user
 *   interface and/or add a native login experience
 *
 * @note
 * Any values specified in the \e customInterfaceOverrides dictionary will override the corresponding
 * values specified the dictionary passed into the setCustomInterfaceDefaults:() method.
 **/
+ (void)showAuthenticationDialogWithCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides __unused;

/**
 * Use this function for linking an account. The JREngage library will pop up a modal dialog,
 * configured with the given custom interface, and take the user through the sign-in process.
 *
 * @param customInterfaceOverrides
 *   A dictionary of objects and properties, indexed by the set of
 *   \link customInterface pre-defined custom interface keys\endlink,
 *   to be used by the library to customize the look and feel of the user
 *   interface and/or add a native login experience
 * 
 * @param linkAccount
 *   A BOOL value indicating to consider this flow for Account Linking process.
 *
 * @note
 * Any values specified in the \e customInterfaceOverrides dictionary will override the corresponding
 * values specified the dictionary passed into the setCustomInterfaceDefaults:() method.
 **/
+ (void)showAuthenticationDialogWithCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                           forAccountLinking:(BOOL)linkAccount __unused;
/**
* Use this function to begin authentication. The JREngage library will pop up a modal dialog, configured
* with the given custom interface and skipping the list of providers, and take the user straight to the sign-in
* flow of the passed provider. The user will not be able to return to the list of providers.
*
* @param provider
*   The name of the provider on which the user will authenticate. For a list of possible strings,
*   please see the \ref authenticationProviders "List of Providers"
*
* @param customInterfaceOverrides
*   A dictionary of objects and properties, indexed by the set of
*   \link customInterface pre-defined custom interface keys\endlink,
*   to be used by the library to customize the look and feel of the user
*   interface and/or add a native login experience
*
* @note
* Any values specified in the \e customInterfaceOverrides dictionary will override the corresponding
* values specified the dictionary passed into the setCustomInterfaceDefaults:() method.
**/
+ (void)showAuthenticationDialogForProvider:(NSString *)provider
               withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides __unused;

/**
 * Use this function to begin social sharing. The JREngage library will pop up a modal dialog and
 * take the user through the sign-in process, if necessary, and share the given JRActivityObject.
 *
 * @param activity
 *   The activity you wish to share
 **/
+ (void)showSharingDialogWithActivity:(JRActivityObject *)activity __unused;

/**
 * Use this function to begin social sharing. The JREngage library will pop up a modal dialog,
 * configured with the given custom interface, take the user through the sign-in process,
 * if necessary, and share the given JRActivityObject.
 *
 * @param activity
 *   The activity you wish to share
 *
 * @param customInterfaceOverrides
 *   A dictionary of objects and properties, indexed by the set of
 *   \link customInterface pre-defined custom interface keys\endlink,
 *   to be used by the library to customize the look and feel of the user
 *   interface and/or add a native login experience
 *
 * @note
 * Any values specified in the \e customInterfaceOverrides dictionary will override the corresponding
 * values specified the dictionary passed into the setCustomInterfaceDefaults:() method.
 **/
+ (void)showSharingDialogWithActivity:(JRActivityObject*)activity
         withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides __unused;
/*@}*/

/**
 * @name Management Authenticated Users
 * Methods that manage authenticated users remembered by the library
 **/
/*@{*/
/**
 * Tell JREngage to clear the sharing credentials for a user who is signed in with the given sharing provider.
 *
 * @param provider
 *   The name of the provider on which the user authenticated. For a list of possible strings,
 *   please see the \ref sharingProviders "List of Social Providers"
 **/
+ (void)clearSharingCredentialsForProvider:(NSString *)provider __unused;

/**
 * Tell JREngage to the sharing credentials for all the \ref sharingProviders "Social Providers" that the
 * user is signed in with
 **/
+ (void)clearSharingCredentialsForAllProviders __unused;

/**
 * Use this function to toggle whether or not the library should force the user to reauthenticate for all providers.
 *
 * @param force
 *   \c YES if the library should force reauthentication for all providers or \c NO if the library should
 *   perform the default behavior
 **/
+ (void)alwaysForceReauthentication:(BOOL)force __unused;
/*@}*/

/**
 * @name Cancel the JREngage Dialogs
 * Methods to cancel authentication and social sharing
 **/
/*@{*/
/**
 * Use this functions if you need to cancel authentication for any reason.
 **/
+ (void)cancelAuthentication __unused;

/**
 * Use this functions if you need to cancel sharing for any reason.
 **/
+ (void)cancelSharing __unused;
/*@}*/

/**
 * @name Server-side Authentication
 * Methods to reconfigure server-side authentication
 **/
/*@{*/
/**
 * Use this function to specify a different tokenUrl than the one with which you initiated the library.
 * On this URL, you can continue any server-side authentication, and send your server's response back
 * to the library. The library will pass your server's response back to your application with the
 * JREngageSigninDelegate#authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:() method
 *
 * @param tokenUrl
 *   The valid URL on your web server where the library will \e POST the authentication token
 **/
+ (void)updateTokenUrl:(NSString *)tokenUrl __unused;

/**
 * Returns the currently configured token URL (or nil if none is configured)
 */
+ (NSString *)tokenUrl __unused;
/*@}*/


/**
 * @name Configure the User Interface
 * Methods used to customize the JREngage's user interface
 **/
/*@{*/
/**
 * Use this function if you want to customize the look and feel of the user interface or add
 * your own native login experience, by passing an \e NSMutableDictionary object indexed by the set of
 * \link customInterface pre-defined custom interface keys\endlink.
 *
 * @param customInterfaceDefaults
 *   A dictionary of objects and properties, indexed by the set of
 *   \link customInterface pre-defined custom interface keys\endlink,
 *   to be used by the library to customize the look and feel of the user
 *   interface and/or add a native login experience
 *
 * @note
 * Any values specified in the \e customizationInterfaceOverrides dictionary of the
 * showAuthenticationDialogWithCustomInterfaceOverrides:(NSDictionary *) or
 * showSharingDialogWithActivity:withCustomInterfaceOverrides:()
 * methods, will override the corresponding values specified in the dictionary passed into
 * the setCustomInterfaceDefaults:() method.
 **/
+ (void)setCustomInterfaceDefaults:(NSDictionary *)customInterfaceDefaults __unused;
/*@}*/
+ (void)setCustomProviders:(NSDictionary *)customProviders __unused;

/**
 * JREngage URL handler
 */
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

/**
 * JREngage application did become active handler
 */
+ (void)applicationDidBecomeActive:(UIApplication *)application;

@end

/**
 * @name Custom Providers
 *
 * Custom Open ID and custom SAML identity provider configuration.
 *
 * See http://developers.janrain.com/documentation/widgets/social-sign-in-widget/users-guide/custom-provider-button/
 * for documentation
 **/
/*@{*/
#define kJRCustomOpenIdIdentifier @"openid_identifier"
#define kJRCustomOpenIdOpxblob @"opx_blob"

#define kJRCustomSamlProviderSamlName @"saml_provider"

/*@}*/

/**
 * @page Providers
 *
@htmlonly
<!-- Script to resize the iFrames; Only works because iFrames origin is on same domain and iFrame
      code contains script that calls this script -->
<script type="text/javascript">
    function resize(width, height, id) {
        var iframe = document.getElementById(id);
        iframe.width = width;
        iframe.height = height + 50;
        iframe.scrolling = false;
        console.log(width);
        console.log(height);
    }
</script>
@endhtmlonly

@anchor authenticationProviders
@htmlonly
<!-- Redundant attributes to force scrolling to work across multiple browsers -->
<iframe id="basic" src="https://rpxnow.com/docs/mobile_providers?list=basic&device=iphone" width="100%" height="100%"
    style="border:none; overflow:hidden;" frameborder="0" scrolling="no">
  Your browser does not support iFrames.
  <a href="https://rpxnow.com/docs/mobile_providers?list=basic&device=iphone">List of Providers</a>
</iframe></p>
@endhtmlonly

@anchor sharingProviders
@htmlonly
<iframe id="social" src="https://rpxnow.com/docs/mobile_providers?list=social&device=iphone" width="100%" height="100%"
    style="border:none; overflow:hidden;" frameborder="0" scrolling="no">
  Your browser does not support iFrames.
  <a href="https://rpxnow.com/docs/mobile_providers?list=social&device=iphone">List of Social Providers</a>
</iframe></p>
@endhtmlonly
 *
 **/
