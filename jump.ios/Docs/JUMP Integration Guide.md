# JUMP for iOS Integration Guide

This guide describes integrating the Janrain User Management Platform into your iOS app. This includes the Capture
user registration system. For Engage-only (i.e. social-authentication-only) integrations see
`Engage-Only Integration Guide.md`

**Warning** You must have a flow configured with your Capture instance in order to use the Capture library.

## JUMP SDK Features

* Engage social sign-in (includes OpenID, and many OAuth identity providers, e.g. Google, Facebook, etc.)
* Sign-in to Capture accounts
    * Either via Engage social sign-in or via traditional username/password sign-in
    * Including the Capture "merge account flow" (which links two social accounts by verified email address at sign-in
      time)
* Register new Capture accounts
    * Traditional accounts (e.g. authenticated via password)
    * Social accounts (with pre-populated registration forms.)
    * "Thin" social registration -- automatic account creation for social sign-in users without a registration form.
* Capture account record updates
* Session refreshing

### Features in the Pipeline

* Profile updates (including password and email address updates)
* In app forgot-password-flow initiation
* Social account linking (like the "merge account" sign-in flow, but after a user is signed in.)

## 10,000' View

Basic use flow:

1. Gather your configuration details
2. [Add the JUMP for iOS SDK to your Xcode project](Xcode%20Project%20Setup.md).
3. Initialize the library
4. Start a sign-in
5. Modify the profile
6. Send record updates
7. Persist the local user object

### SimpleCaptureDemo

There is a JUMP SDK demo in Samples/SimpleCaptureDemo. The demo includes a default configuration in
`Sample/SimpleCaptureDemo/assets/janrain-config-default.plist`. To customize the demo configuration copy that file to
`janrain-config.plist` and edit its contents.

The demo shows:
- Registration
- Sign-in
- Record updates
- Session refreshing

## Gather your Configuration Details

1. Sign in to your Engage Dashboard - https://rpxnow.com
    1. Configure the social providers you wish to use for authentication ("Deployment" drop down menu -> "Engage for
       iOS").
    2. Retrieve your 20-character Engage application ID from the Engage Dashboard (In the right column of the "Home"
       page on the Engage dashboard.)
2. Ask your deployment engineer or account manager for your Capture domain.
3. Create a new Capture API client for your mobile app:
    1. Sign in to the Capture dashboard and provision a new API client for your mobile app (https://janraincapture.com)
       (Copy down the new API client's client ID, you will need this.)
    2. Use the dashboard to add the "login_client" feature to your new API client.

       **Warning** `login_client` is mutually exclusive with all other API client features, which means only login
       clients can be used to sign users in, and only non-login-clients can perform client_id and client_secret
       authenticated Capture API calls. This means that you cannot use the owner client as a login client.
    3. Use the
       [setAccessSchema API](http://developers.janrain.com/documentation/api-methods/capture/entitytype/setaccessschema/)
       API to set the subset of the schema you wish your mobile app to be able to update.
       You must use the "write_with_token" schema type.

       **Warning** If you do set the write_with_token access schema for your API client to include the attributes your
       client will write to in its write access schema you will receive `missing attribute` errors when attempting
       to update attributes.

       **Warning** Do not use the "write" schema type with login clients, use "write_with_token"

       **Warning** This cannot be done from the dashboard, it must be done with the API.

       It is assumed that you are integrating the JUMP SDK into your app in order to update attributes of the user's
       record on Capture. In order to update attributes the `write_with_token` access schema must be set for your
       app's API client.

       Because record updates from the iOS SDK use the `entity` API, they are not suitable for security sensitive
       attributes (such as the user's email address, password, and display name.) You should restrict the write access
       schema to those attributes you want the user to have direct control over. E.g. app data such as "favorites,"
       usage history, and user generated content.
4. Discover your flow settings:
    Ask your deployment engineer for:
        * The name of the Capture "flow" you should use
        * The name of the flow's traditional sign-in form
        * The name of the flow's social registration form
        * The name of the flow's traditional registration form
        * The name of the "locale" in the flow your app should use
          The commonly used value for US English is "en-US".
5. Determine whether your app should use "thin" social registration, or "two-step" social registration.
6. Determine the name of the traditional sign-in key attribute (e.g. `email` or `username`)

**Warning** You _must_ create a new API client with the correct login_client feature for operation of the JUMP for iOS
SDK.

## Xcode Project Setup

Follow the Xcode project setup guide, in `Xcode Project Setup.md`.

## Import the Library and Declare a JRCaptureUser Property

In your application, determine where you want to manage the authenticated Capture user object. You will want to
implement your Capture library interface code in an object that won't go away, such as the `AppDelegate` or a singleton
object that manages your application's state model.

1. In the chosen class's header, import the Capture library header:

        #import "JRCapture.h"
        #import "JRCaptureConfig.h"

2. Modify your class's interface declaration to declare conformation to the protocol. (All of the messages of the
   protocol are optional.) So, for example, start your AppDelegate's interface declaration like this:

        @interface AppDelegate : UIResponder <UIApplicationDelegate, JRCaptureDelegate>

3. Add a `JRCaptureUser *` property to your class's interface declaration:

        @property (retain, nonatomic) JRCaptureUser *captureUser;

4. In your class's implementation synthesize that property:

        @synthesize captureUser;

## Initialize the Library

To configure the library, pass your configuration settings to the initializer method. This should be called as soon as
possible during your app's lifecycle so that the network configuration call has time to complete before the library is
used.

Copy and paste this block into `-[AppDelegate application:didFinishLaunchingWithOptions:]` to get started:

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        // ... Your existing initialization logic here

        JRCaptureConfig *config = [JRCaptureConfig emptyCaptureConfig];
        config.engageAppId = @"your_engage_app_id";
        config.captureDomain = @"your_capture_ui_base_url";
        config.captureClientId = @"your_capture_client_id";
        config.captureLocale = @"en-US"; // e.g.
        config.captureFlowName = nil; // e.g.
        config.captureFlowVersion = nil; // e.g.
        config.captureSignInFormName = @"signinForm";
        config.captureTraditionalSignInType = JRTraditionalSignInEmailPassword;
        config.enableThinRegistration = YES;
        config.customProviders = nil;
        config.captureTraditionalRegistrationFormName = @"registrationForm"; // e.g.
        config.captureSocialRegistrationFormName = @"socialRegistrationForm"; // e.g.
        config.captureAppId = @"your_capture_app_id";
        config.forgottenPasswordFormName = @"forgotPasswordForm"; // e.g.
        config.passwordRecoverUri = @"your_password_recovery_uri";
        config.editProfileFormName = @"editProfileForm";

        [JRCapture setCaptureConfig:config];
    }

## Start the User Sign-In Flow

To start the authentication and sign-in flow, send the `startEngageSignInForDelegate:` message to the `JRCapture`
class. For example, you could call this method when your app's sign-in button is pressed:

    @interface MyAppSignInViewController () <JRCaptureDelegate>
    @end

    // ...

    @implementation MyAppSignInViewController

    // ...

    - (IBAction)signInButtonTouchUpInside:(id)sender
    {
        [JRCapture startEngageSignInForDelegate:self];
    }

This starts the Engage user authentication flow, the result of which is used to sign-in to Capture. Once a user is
signed in, the library instantiates a user model object (an instance of `JRCaptureUser`.)

The `JRCaptureDelegate` protocol defines a set of (optional) messages your Capture delegate can respond to. As the
flow proceeds, a series of delegate messages will be sent to your delegate.

First, your delegate will receive `engageAuthenticationDidSucceedForUser:forProvider:` when Engage authentication is
complete. At this point, the library will close the authentication dialog and then complete sign-in to Capture
headlessly. This message contains limited data which can be used to update UI while your app waits for Capture to
complete authentication.

    - (void)engageAuthenticationDidSucceedForUser:(NSDictionary *)engageAuthInfo
                                      forProvider:(NSString *)provider
    {
        self.currentDisplayName = [self getDisplayNameFromProfile:engageAuthInfo];
    
        // Update the UI to show that authentication is completing...
        [self showCompletingSigninVisualAffordance]; // E.g. a UIActivityIndicator
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }

Once the authentication token reaches Capture, Capture automatically adds the profile data to the Capture record.

## Finish the User Sign-In Flow

Once the the user record is retrieved from Capture, the `captureSignInDidSucceedForUser:status:` message is sent to
your delegate. This message delivers the `JRCaptureUser` instance, and also the state of the record.


    @interface MyAppSignInViewController () <JRCaptureDelegate>
    @end

    // ...

    @implementation MyAppSignInViewController

    // ...

    - (void)captureSignInDidSucceedForUser:(JRCaptureUser *)newCaptureUser
                                    status:(JRCaptureRecordStatus)captureRecordStatus
    {
        // Retain a reference to the user object
        myAppDelegate.captureUser = newCaptureUser;
    
        // User records can come back with one of two states
        if (captureRecordStatus == JRCaptureRecordNewlyCreated)
        {
            // The user has not signed in to this Capture instance before and a new record
            // has been automatically created. This is called a "thin registration"
    
            // You may wish to collect additional data from the user and add it
            // to the user's record, e.g. an avatar image URL, T.O.S. acceptance, etc. 
        }
        else if (captureRecordStatus == JRCaptureRecordExists)
        {
            // The user had a pre-existing Capture user record
        }
    }

There are two possible values for `captureRecordStatus`:

`JRCaptureRecordExists` indicates that the user had an existing Capture record and that record has been retrieved.
Your application should update its state to reflect the user being signed-in.

`JRCaptureRecordNewlyCreated` indicates that this is a new user and that a new Capture record has been automatically
created. (This is called "thin registration.") Because this is a new user, your application may wish to collect
additional profile information and push that information back to Capture.

Optionally, your delegate can receive `captureDidSucceedWithCode:`. When the sign-in has succeeded, this is called with
a Capture OAuth Authorization Code that can be used by a server side application, such as the Capture Drupal Plugin,
to retrieve an Access Token.

### Traditional Sign-In and Social Sign-In

The Capture part of the SDK supports both social sign-in via Engage (e.g. Facebook) as well as traditional sign-in
(i.e. username and password or email and password sign-in.) There are four main ways to start sign-in:

- `+[JRCapture startEngageSignInDialogForDelegate:]`: Starts the Engage social sign-in process for all currently
  configured social sign-in providers, displaying a list of them initially, and guiding the user through the
  authentication.
- `+[JRCapture startEngageSignInDialogOnProvider:withCustomInterfaceOverrides:mergeToken:forDelegate:]`: Starts the
   Engage social sign-in process beginning directly with the specified social sign-in identity provider (skipping the
   list of configured social sign-in providers)
- `+[JRCapture startEngageSignInDialogWithConventionalSignin:forDelegate:]`: Start the Engage social sign-in process
  for all currently configured social sign-in providers, preceding the list with a traditional sign-in form.
- `+[JRCapture startCaptureTraditionalSigninForUser:withPassword:withSignInType:mergeToken:forDelegate:]`: Starts
  the traditional sign-in flow headlessly.

The first two methods start social sign-in only (either by presenting a list of configured providers, or by starting
the sign-in flow directly on a configured provider.) The fourth method performs a headless traditional sign-in -
useful if your host app wishes to present it's own traditional sign-in UI. The third method combines social sign-in
with a stock traditional sign-in UI.

The merge token parameters are used in the second part of the Merge Account Flow, described below.

### Handling the Merge Account Sign-In Flow

Sometimes a user will have created a record with one means of sign-in (e.g. a traditional username and password record)
and will later attempt to sign-in with a different means (e.g. with Facebook.)

When this happens the sign-in cannot succeed, because there is no Capture record associated with the social sign-in
identity, and the email address from the identity is already in use.

Before being able to sign-in with the social identity, the user must merge the identity into their existing record.
This is called the "Merge Account Flow."

The merge is achieved at the conclusion of a second sign-in flow authenticated by the record's existing associated
identity. The second sign-in is initiated upon the failure of the first sign-in flow, and also includes a merge token
which Capture uses to merge the identity from the first (failed) sign-in into the record.

Capture SDK event sequence for Merge Account Flow:

 1. User attempts to sign-in with a social identity, "identity F".
 2. Capture sign-in fails because there is an existing Capture record connected to "identity G", which shares some
    constrained attributes with "identity F". E.g. the two identities have the same email address.
 3. The `-[JRCaptureSigninDelegate captureSignInDidFailWithError:]` delegate message is sent with an
    error representing this state. This state is to be discerned via the `-[NSError isJRMergeFlowError]`
    class category message.
 4. The host application (your mobile app) notifies the user of the conflict and advises the user to merge the accounts
 5. The user elects to take action
 6. The merge sign-in is started by invoking either
    `+[JRCapture startEngageSignInDialogOnProvider:withCustomInterfaceOverrides:mergeToken:forDelegate:]` or
    `+[JRCapture startCaptureConventionalSigninForUser:withPassword:withSigninType:mergeToken:forDelegate:]` depending
    on the existing identity provider for the record.

    The existing identity provider of the record is retrieved with the `-[NSError JRMergeFlowExistingProvider]` message,
    and the merge token with the `-[NSError JRMergeToken]` message.

Example:

    @interface MyAppSignInViewController () <JRCaptureDelegate>
    @end

    // ...

    @implementation MyAppSignInViewController

    // ...

    - (void)captureSignInDidFailWithError:(NSError *)error
    {
        if ([error code] == JRCaptureErrorGenericBadPassword)
        {
            [self handleBadPasswordError:error]; // Advises the user to try again.
        }
        else if ([error isJRMergeFlowError])
        {
            [self handleMergeFlowError:error];
        }
    }

    - (void)handleMergeFlowError:(NSError *)error
    {
        NSString *existingAccountProvider = [error JRMergeFlowExistingProvider];
        void (^mergeAlertCompletion)(UIAlertView *, BOOL, NSInteger) =
                ^(UIAlertView *alertView, BOOL cancelled, NSInteger buttonIndex)
                {
                    if (cancelled) return;

                    if ([existingAccountProvider isEqualToString:@"capture"]) // Traditional sign-in required
                    {
                        [self handleTradMerge:error];

                    }
                    else
                    {
                        // Social sign-in required:
                        [JRCapture startEngageSignInDialogOnProvider:existingAccountProvider
                                        withCustomInterfaceOverrides:self.customUi
                                                          mergeToken:[error JRMergeToken]
                                                         forDelegate:self];
                    }
                };

        [self showMergeAlertDialog:existingAccountProvider mergeAlertCompletion:mergeAlertCompletion];

    }

    - (void)handleTradMerge:(NSError *)error
    {
        void (^signInCompletion)(UIAlertView *, BOOL, NSInteger) =
                ^(UIAlertView *alertView_, BOOL cancelled_, NSInteger buttonIndex_)
                {
                    if (cancelled_) return;
                    NSString *user = [[alertView_ textFieldAtIndex:0] text];
                    NSString *password = [[alertView_ textFieldAtIndex:1] text];
                    [JRCapture startCaptureConventionalSigninForUser:user withPassword:password
                                                      withSigninType:JRTraditionalSignInEmailPassword
                                                          mergeToken:[error JRMergeToken]
                                                         forDelegate:self];
                };

        [[[AlertViewWithBlocks alloc] initWithTitle:@"Sign in" message:nil completion:signInCompletion
                                              style:UIAlertViewStyleLoginAndPasswordInput
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Sign-in", nil] show];
    }

**Note** This example makes use of the `AlertViewWithBlocks` subclass of `UIAlertView` (which provides an interface
to `UIAlertView` with a block handler, as opposed to a delegate object handler.) See the SimpleCaptureDemo project in
the Samples directory of the SDK for source code.

This example checks for the merge-flow error, it prompts the user to merge, and it start authentication.

**Note** That the "existing provider" of the merge flow can be Capture itself. This happens when the merge-failure was
a conflict with an existing record created with traditional sign-in. This case is handled in the `handleTradMerge:`
method.

### Performing Account Linking Flow

There are times when a user want to link another social identity provider to the existing capture account. This flow enables
user to link other social identity provider accounts to the current capture account. 

- `+[JRCapture startAccountLinkingSignInDialogForDelegate:forAccountLinking:withRedirectUri:]` : Starts the 
   social sign-in process for all currently configured social sign-in providers, displaying a list of them initially,
   and guiding the user through the authentication. Once the authentication is completed, this new account is linked to the 
   existing capture account.
   
Parameters :
- `JRCaptureDelegate` : A capture delegate object.
- `forAccountLinking` : A `bool` value to indicate whether to perform account linking or not. Set it `"YES` to start account linking.
- `withRedirectUri`	  : A url which will be used if & only if the flow is set up to trigger an email after linking accounts successfully.
During the capture account setup process, email triggering can be configured.

Delegates:
- `-(void)linkNewAccountDidFailWithError:(NSError *)error` : The delegate is fired with an error when the account linking fails.

- `-(void)linkNewAccountDidSucceed` : The delegate is fired after the Successful account linking process.

Example:
Let's call this on the click of a button for Account Linking.

    [JRCapture startAccountLinkingSignInDialogForDelegate:self.captureDelegate 
                                        forAccountLinking:YES
                                          withRedirectUri:@"http://your-domain-custom-redirect-url-page.html"]

**Note** This should be called when the user has already signed-in into capture application.

### Performing Account Unlink Flow

A user can have multiple accounts linked to the same capture account. To unlink an account associated with an existing capture account,
use this flow. This flow will unlink one account at a time, in a successful execution.

**Note** This should be called when the user has already signed-in into capture application.

-`[JRCaptureData getLinkedProfiles]` : Use this method to fetch the list of linked accounts after the successful sign-in. The linked profile
   array consists of dictionary of linked profiles. This is stored in the `JRCaptureData` object. Each dictionary object has
   the following keys:
   `verifiedEmail`  & `identifier` : Use `identifier` value for unlinking account.

- `+[JRcapture startAccountUnlinking:(id<JRCaptureDelegate>)delegate forProfileIdentifier:(NSString *)identifier`: This will
   unlink the account identified by the `identifier`, from the existing capture account. Pass any `identifier` value being retrieved from 
   `[JRCaptureData getLinkedProfiles]` array. The `JRCapture` will trigger `accountUnlinkingDidFailWithError` &
   `accountUnlinkingDidSucceed` delegates.

Delegates:
- `-(void)accountUnlinkingDidFailWithError:(NSError *)error` : This delegate is fired when the account unlinking process fails.

- `-(void)accountUnlinkingDidSucceed` : This delegate is fired after a successful account unlinking flow.

Example:
Let's call this on the click of a button for Account Un-linking.
**Note** This should be called when the user has already signed-in into a capture application.
    
    // store the Linked accounts into your array aobject from JRCaptureData object.
    NSArray *linkedProfiles = [JRCaptureData getLinkedProfiles];
    
    if([linkedProfiles count]) {
    	NSString *selectedProfile = [[linkedProfiles objectAtIndex:0] valueForKey:@"identifier"];
    	
    	// pass the selected  identifier to the unlinking method.
    	[JRCapture startAccountUnlinking:self.captureDelegate forProfileIdentifier:selectedProfile];
    }

## Making Changes in a Capture User Record

### Capture Schema Basics

Capture user records are defined by the Capture schema, which defines the attributes of the record. An attribute is
either a primitive value (a number, a string, a date, or similar) an object, or a plural.

Primitive attribute values are the actual data that make up your user record. For example, they are your user's
identifier, or their email address, or birthday.

Objects and plurals make up the structure of your user record. For example, in the default Capture schema, the user's
name is represented by an object with six primitive values (strings) used to contain the different parts of the name.
(The six values are `familyName`, `formatted`, `givenName`, `honorificPrefix`, `honorificSuffix`, `middleName`.)
Objects can contain primitive values, sub-objects, or plurals, and those attributes are defined in the schema.

Plurals contain collections of objects. Each element in a plural is an object or another plural. Every element in a
plural has the same set of attributes, which are defined in the schema. Think of a plural as an object that may have
zero-or-more instances.

Generating your Capture user model produces Objective-C classes for all your objects and non--string-plural plural
elements. For example, you will have a `JRName` class which contains `NSString` properties for the six attributes
noted above.

Internally, Capture user record updates occur through one of two mechanisms: updating and replacing. Both updating and
replacing are limited in scope to part of the record, depending on the object from which they are called. Broadly
speaking, parts of the record that are limited to objects can be updated, but to change the plural elements in a plural
you must replace the plural. For example, `JRName` (the user's name) is an object and can be updated if the user changes
part of their name, but `JRInterests` (a plural of strings holding the user's interests) must be replaced if the user
adds or removes an interest.

### Updating User Profiles

Conform to the `JRCaptureDelegate` protocol in your class.

    @interface MyCaptureEditProfileController : UIViewController <JRCaptureDelegate>

Update the properties of your `JRCaptureUser` that correspond to the fields of your `editProfileForm` in your flow. For
example: `givenName`, `familyName`, `birthdate`, `aboutMe`, etc.

Call `+[JRCapture updateProfileForUser:delegate]` to update the users profile.

Upon a successful update the delegate method `updateUserProfileDidSucceed` will be called. If the update fails for any
reason `updateUserProfileDidFailWithError:` will be called instead.

### Updating Record Entities (Non-Plurals)

Conform to the
[JRCaptureObjectDelegate](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_object_delegate-p.html)
protocol in your class:

    @interface MyCaptureUserManager : NSObject <JRCaptureObjectDelegate>

Update the object's non-plural properties, and then send the object the
[updateOnCaptureForDelegate:context:](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_object.html#a307b20b8cb70eec684e7197550c9f4c3)
message. For example:

    appDelegate.captureUser.aboutMe = @"Hello. My name is Inigo Montoya.";
    [appDelegate.captureUser updateOnCaptureForDelegate:self context:nil];

**Note** Context arguments are used across most of the asynchronous Capture methods to facilitate correlation of the
response messages with the calling code. Use of the context is entirely optional. You can use any object which conforms
to `<NSObject>`.

You may respond to
[updateDidSucceedForObject:context:](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_object_delegate-p.html#afa043773e69351fc3115d7ae765986db)
for notification of success:

    - (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
    {
        // Successful update
    }

Similarly
[updateDidFailForObject:withError:context:](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_object_delegate-p.html#affff9e5fe9d03312a4d5db8b39ba5ff0)
will be sent on failure. See
[Capture Errors](http://janrain.github.com/jump.ios/gh_docs/capture/html/group__capture_errors.html#ggabc7274cb58c13d8cda35a6554a013de9ac24c5311be2739cfa10797413b2023ca)
in the API documentation for possible errors.

You can send the `updateOnCaptureForDelegate:context:` message to the top-level object (an instance of
[JRCaptureUser](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_user.html)
instance), or a sub-object of that object.

**Warning** When you update an object, the update _does not_ affect plurals inside of that object.

### Replacing Plurals

To add or remove the elements of a plural send the `replace_ArrayName_ArrayOnCaptureForDelegate:context:` message to
the parent-object of the plural, where _ArrayName_ is the name of the plural attribute.

For example, if you have a schema with a plural attribute named `photos`, the user model generator generates a method
named `replacePhotosArrayOnCaptureForDelegate:context:`. In this case the _ArrayName_ is `Photos`.

Once the values in the plural element attribute have been updated in the local instance of the user record model,
Capture can be updated by called `replace_ArrayName_ArrayOnCaptureForDelegate:context:`.

For example:

    // Make a new photos plural element:
    JRPhotosElement *newPhoto = [[JRPhotosElement alloc] init];
    newPhoto.value = @"http://janrain.com/wp-content/uploads/drupal/janrain-logo.png";
    
    // Make a new array with the new element added:
    NSMutableArray *newPhotos = [NSMutableArray  arrayWithArray:captureUser.photos];
    [newPhotos addObject:newPhoto];
    
    // Assign the new array to the photos plural property:
    captureUser.photos = newPhotos;
    
    // ... And update Capture:
    [captureUser replacePhotosArrayOnCaptureForDelegate:self context:nil];

**Warning** The `NSArray` properties used to model plurals are copy-on-set. This means that to modify the array you
must create a new mutable array with the existing array, then modify the mutable array, then assign the mutable array
to the property. (Because the property is copy-on-set further modifications to the copied array will not change the
property.) See the above example for an example of this technique.

## Persisting the Capture User Record

When your application terminates, you should save your active user record to local storage. For example, from your
UIApplicationDelegate:

    #define cJRCaptureUser @"jr_capture_user"
    
    - (void)applicationWillTerminate:(UIApplication *)application
    {
        // Store the Capture user record for use when your app restarts;
        // JRCaptureUser objects conform to NSCoding so you can serialize them with the
        // rest of your app state
        NSUserDefaults *myPreferences = [NSUserDefaults standardUserDefaults];
        [myPreferences setObject:[NSKeyedArchiver archivedDataWithRootObject:captureUser]
                          forKey:cJRCaptureUser];
    }

Likewise, load the saved user record state when your application launches. For example, from your
`UIApplicationDelegate`:

    - (BOOL)          application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        NSUserDefaults *myPreferences = [NSUserDefaults standardUserDefaults];
        NSData *encodedUser = [myPreferences objectForKey:cJRCaptureUser];
        self.captureUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedUser];
    }

**Warning** While your application is responsible for saving and restoring the user record, the Capture library will
automatically save and restore the session token.

### Refreshing the User's Access Token

Call `+[JRCapture refreshAccessTokenForDelegate:context:]` to refresh the signed-in-user's access token. Access tokens
last one hour. They may be refreshed after expiration. The underlying refreshing system lasts "a long time".

## Next: Registration

Once you have sign-in and record updates working, see the `User Registration Guide.md` for a guide to new user
registration.

## Troubleshooting

#### Failed Sign-In Due to Client Permissions

Sign-ins fail with an error message indicating that the client doesn't have the necessary permissions.

Ensure that the API client ID you are using is for an API client with the "login_client" API client feature. To
configure this see the clients/set_features Capture API and also the clients/list Capture API to get the set of
configured API client features.

#### Attribute Does Not Exist

    code: 223 error: unknown_attribute description: attribute does not exist: /your_attr_name

Use [entityType.setAccessSchema](http://developers.janrain.com/documentation/api-methods/capture/entitytype/setaccessschema)
to add write-access to this attribute to your native API client.

#### Undefined Symbol _CATransform3DConcat

    Undefined symbols for architecture i386: "_CATransform3DConcat", referenced from:

Add the QuartzCore framework to the build target for the project.

#### Undefined Symbol _OBJC_CLASS_$_MFMailComposeViewController

    Undefined symbols for architecture i386: "_OBJC_CLASS_$_MFMailComposeViewController", referenced from:

Add the MessageUI framework to the build target for the project (set it to "Optional").

