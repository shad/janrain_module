# Engage-Only Integration Guide

This guide describes integrating Engage-only into your iOS App. For a description of integration steps for the JUMP
platform see `JUMP Integration Guide.md`.

## 10,000' View

1. Gather configuration details.
2. Add the library to your Xcode project.
3. Initialize the library with your Engage application’s application ID, your web server’s token URL, and your delegate
   object (which conforms to the the
   [JREngageSigninDelegate](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_signin_delegate-p.html)
   and/or the
   [JREngageSharingDelegate](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_sharing_delegate-p.html)
   protocols.)
4. Begin authentication or sharing by calling one of the "show...Dialog" methods.
5. Receive your token URL's response in `-authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:`.

## Gather Configuration Details

### Configure Identity Providers on the Engage Dashboard

Make sure your desired set of social identity providers is configured in the Engage Dashboard. Sign-in to Engage and
[configure the providers](http://developers.janrain.com/documentation/widgets/social-sign-in-widget/social-sign-in-widget-users-guide/configure-the-widget/provider-setup-guide/).

(Configuring the providers themselves is a separate step from configuring which providers are enabled for the Engage
library.)

### Configure the Providers Used in the iOS Library

While signed in to the Engage dashboard go to the Engage for iOS configuration wizard (in the drop-down menus, under
Deployment -> Engage for iOS). Follow the wizard, use it to configure the providers to use for authentication and
social sharing from the iOS library.

### Retrieve your Engage Application ID

You will also need your 20-character Application ID from the Engage Dashboard. Click the `Home` link int the Engage
dashboard and you will find your app ID in the right-most column towards the bottom of the colum under the "Application
Info" header.

## Add the Engage Library to the Xcode Project

1. Follow the steps JUMP for iOS Xcode setup instructions here, but skip generating the Capture User Model:
   [Adding to Xcode](http://developers.janrain.com/documentation/mobile-libraries/jump-for-ios/adding-to-xcode/)
2. Remove the JRCapture project group from your project.

## Choose an Engage Delegate Class and Initialize the Library

Select the class you will use to receive callbacks from the Engage library. This is called your Engage delegate.
The delegate should be persistent (will not be dealloced during the course of your app's lifetime) and it should be a
singleton. Your app's AppDelegate is a good choice to start with.

In the interface of your chosen Engage delegate class import the Engage header: `#import "JREngage.h"`, and conform to
the `JREngageSigninDelegate` and `JREngageSharingDelegate` protocols:

    @interface AppDelegate : UIResponder <UIApplicationDelegate, JREngageSigninDelegate>

In your delegate's implementation, during its initialization, (or from elsewhere in your app's initialization), call
the JREngage initialization method, for example from from your AppDelegate's
`-application:didFinishLaunchingWithOptions:`:

    [JREngage setEngageAppId:@"<your app id>" tokenUrl:@"<your_token_url>" andDelegate:yourEngageDelegate];

Stub out these two delegate message implementations in your delegate:

    - (void)authenticationDidReachTokenUrl:(NSString *)tokenUrl withResponse:(NSURLResponse *)response
                                andPayload:(NSData *)tokenUrlPayload forProvider:(NSString *)provider
    {
        NSLog(@"%@", [response description]);
    }

    - (void)authenticationDidSucceedForUser:(NSDictionary *)authInfo forProvider:(NSString *)provider
    {
        NSLog(@"%@", [authInfo description]);
    }

## Social Sign-In

An Engage authentication is only meaningful in the context of authenticating your mobile app /to/ something.
If you are unsure of what your users should be signing-in to, then Janrain Capture may be a suitable choice.

To start authentication send the
[showAuthenticationDialog](http://janrain.github.com/jump.ios/gh_docs/engage/html/interface_j_r_engage.html#a0de1aa16e951a1b62e2ef459b1596e83)
message to the `JREngage` class:

    [JREngage showAuthenticationDialog];

You will receive your authentication token URL's response in the authenticationDidReachTokenUrl:... message. When
received you will have access to the body of the response, as well as the headers, which frequently contain session
cookies used to coordinate the app's session with your web server. Parsing your authentication token URL's response
for session establishing information, or retrieving session cookies from the header, is your app's responsibility.

For guidance implementing your web-server's authentication token URL, see `Authentication-Token-URL.md`.

### UI Customization

To customize the look and feel of the sign-in experience, please see the
[Custom Interface Guide for iOS](http://developers.janrain.com/documentation/mobile-libraries/advanced-topics/custom-ui-for-ios/).

## Social Sharing

If you want to share an activity, first
[create an instance](http://janrain.github.com/jump.ios/gh_docs/engage/html/interface_j_r_activity_object.html#a853261b333e02bbd096a8e1d2092195d)
of the [JRActivityObject](http://janrain.github.com/jump.ios/gh_docs/engage/html/interface_j_r_activity_object.html)
and populate the activity object’s fields:

    JRActivityObject *activity =
        [JRActivityObject activityObjectWithAction:@"added JREngage to her iPhone application!"
                                            andUrl:@"http://janrain.com"];[/sourcecode]

Then pass the activity to the
[showSharingDialogWithActivity:](http://janrain.github.com/jump.ios/gh_docs/engage/html/interface_j_r_engage.html#adbbf64bfffdd179fe593145f16ab4b5f)
message:

    [JREngage showSharingDialogWithActivity:activity];

Your user may choose to sign in with additional social providers in order to share. If they do, your delegate will
receive the
[authenticationDidSucceedForUser:forProvider:](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_signin_delegate-p.html#a9803676f3066c7eae7127d57a193f38f "authenticationDidSucceedForUser") and [authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_signin_delegate-p.html#abb576f76e23750d0fbc90409f60ab250 "authenticationDidSucceedForUser") messages. If you don’t want new authentications posted to your token URL, you can remove the token URL with the [updateTokenUrl:](http://janrain.github.com/jump.ios/gh_docs/engage/html/interface_j_r_engage.html#a5af5ed8a0bcaf58a31656d4ed81b7b40)
message.

Additionally, as your users shares their activity on the different providers, you will receive
[sharingDidSucceedForActivity:forProvider:](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_sharing_delegate-p.html#afe0da35cf96f23421abfa12d497c0132 "sharingDidSucceedForActivity:forProvider:") messages on your [JREngageSharingDelegate](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_sharing_delegate-p.html "JREngageSharingDelegate") delegate. Finally, the [JREngageSharingDelegate](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_sharing_delegate-p.html "JREngageSharingDelegate") delegate will receive a [sharingDidComplete](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_sharing_delegate-p.html#abfd122aa4da3befaa402a8c528ab67ef "SharingDidComplete") message once the user finishes sharing. If the user cancels sharing before the activity was posted to any provider, the delegate will receive the [sharingDidNotComplete](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_sharing_delegate-p.html#abfd122aa4da3befaa402a8c528ab67ef)
message.

### More

For information on sharing through email or SMS, please see
[Email, SMS, and Shortening URLs](http://developers.janrain.com/documentation/mobile-libraries/advanced-topics/email-sms-and-urls/).

## Good to Know

The first time your application uses `JREngage` on any device, the library contacts the Engage servers to retrieve your
application’s configuration information. After downloading, the library caches this information. The library updates
the cache only when the information changes (for example, when you add or remove a provider). The Library checks for
updates after it initializes.

While you can initialize the `JREngage` library immediately before you call one of the `show...` methods, understand
that your users may encounter our loading screen while the library contacts the Engage servers.
