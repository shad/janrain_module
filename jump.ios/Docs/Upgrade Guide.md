# JUMP iOS Upgrade Guide

This guide describes the steps required to upgrade from different versions of the library.

## Generalized Upgrade Process

A less desirable but more reliable and more general upgrade strategy:

1. Remove existing Janrain project groups
2. Remove generated Capture user model project groups
3. Follow the process described JUMP Integration Guide


### Upgrading from any version to v3.6 or greater
1. Ensure that the **Accounts** and **Social** frameworks have been added to your project.
2. Ensure that your deployment target is at least iOS 6.


### Solutions for upgrading from v2.5.2-v3.1.4 to v3.4.0
* **'JSONKit.h' file not found**
    Remove `#import "JSONKit.h` it is no longer required for JUMP.

* **no visible @interface for 'NSDictionary' declares the selector 'JSONString'**

    Import `JRJsonUtils.h` and change `JSONString` to `JR_jsonString`.

* **no visible @interface for 'NSArray' declares the selector 'JSONString'**

    Import `JRJsonUtils.h` and change `JSONString` to `JR_jsonString`.

* **no visible @interface for 'NSString' declares the selector 'objectFromJSONString'**

    Import `JRJsonUtils.h` and change `objectFromJSONString` to `JR_objectFromJSONString`


### Solutions for upgrading v3.1.4 to v3.4.0
* **no visible @interface for 'NSError' declares the selector 'JRMergeFlowExistingProvider'**

    Import `JREngageError.h`

* **no visible @interface for 'NSError' declares the selector 'JRMergeToken'**

    Import `JREngageError.h`

* **no visible @interface for 'NSError' declares the selector 'isJRMergeFlowError'**

    Import `JREngageError.h`

* **use of undeclared identifier 'JRCaptureErrorGenericBadPassword'**

    Import `JREngageError.h`


### Solutions for upgrading v2.5.2 to v3.4.0

* **no visible @interface for 'JRCaptureUser' declares the selector 'createOnCaptureForDelegate:context:'**
    Use `+[JRCapture registerNewUser:socialRegistrationToken:forDelegate:]` instead

* **Use of undeclared identifier 'JRCaptureErrorGenericBadPassword'**

    Import `JREngageError.h`

* **use of undeclared identifier 'JRCaptureRecordMissingRequiredFields'**

    `JRCaptureRecordMissingRequiredFields` has been removed.

* **no known class method for selector 'setEngageAppId:captureApidDomain:captureUIDomain:clientId:andEntityTypeName:'**

    Use `+[JRCapture +setCaptureConfig:]` instead. For example, if you had:

            [JRCapture setEngageAppId:engageAppId captureApidDomain:captureApidDomain
                      captureUIDomain:captureUIDomain clientId:captureClientId andEntityTypeName:nil];

    Then do the following instead:

            JRCaptureConfig *config = [JRCaptureConfig emptyCaptureConfig];
            config.engageAppId = engageAppId;
            config.captureDomain = captureDomain;
            config.captureClientId = captureClientId;
            config.captureLocale = @"en-US";
            [JRCapture setCaptureConfig:config];


## Upgrading from v2.2.0-v2.3.x to v3.4.0

1. Delete the **JREngage** group from Xcode.
2. Get the latest version of the SDK from GitHub `git clone https://github.com/janrain/jump.ios.git`
3. Make sure that the **Project Navigator** pane is showing.
4. Open **Finder** and navigate to the location where you cloned the `jump.ios` repository. Drag the **Janrain**
   folder into your Xcode project's **Project Navigator** and drop it below the root project node.

       **Warning**: Do not drag the **jump.ios** folder into your project, drag the **Janrain** folder in.
5. In the dialog, do **not** check the **Copy items is not destination group's folder (if needed)**. Ensure that the
   **Create groups for any added folders** radio button is selected, and that the **Add to targets** check box is
   selected for you application's target.
6. v2.2.0 and v2.3.0 did support Capture so you need to remove the **JRCapture** project group from the **Janrain**
   project group.
7. You must also add the **QuartzCore** framework, and the **MessageUI** framework to your project.  As the
   **MessageUI** framework is not available on all iOS devices and versions, you must designate the framework as
   "optional."
8. Ensure that your **Deployment Target** is *iOS 5.0* or higher.

### Solutions for upgrading from v2.2.0-v2.3.x to v3.4.0

* **Delegate methods are not being called**

    Delegate method names are no longer prepended with 'jr'. For example:

    * `jrEngageDialogDidFailToShowWithError:` has been replaced with `engageDialogDidFailToShowWithError:`
    * `jrAuthenticationDidSucceedForUser:forProvider` has been replaced with
      `authenticationDidSucceedForUser:forProvider:`
    * `jrAuthenticationDidReachTokenUrl:withPayload:forProvider:` has been replaced with
      `authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:`
    * `jrAuthenticationDidReachTokenUrl:withResponse:andPayload:forProvider:` has been replaced with
      `authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:`
    * `jrAuthenticationDidNotComplete` has been replaced with `authenticationDidNotComplete`
    * `jrAuthenticationDidFailWithError:forProvider:` has been replaced with
      `authenticationDidFailWithError:forProvider:`
    * `jrAuthenticationCallToTokenUrl:didFailWithError:forProvider:` has been replaced with
      `authenticationCallToTokenUrl:didFailWithError:forProvider:`

* **cannot find protocol declaration for 'JREngageDelegate'**

    Change `<JREngageDelegate>` to `<JREngageSigninDelegate>`

* **Use of undeclared identifier 'JRDialogShowingError'**

    Import `JREngageError.h`

* **class method '+jrEngage' not found (return type defaults to 'id')**

    This method has been removed some of the instance methods that you might be trying to use have been replaced with
    class methods.

* **Instance method '-authenticationDidCancel' not found (return type defaults to 'id')**

    Use the class method `+[JREngage cancelAuthentication]` instead

* **instance method '-cancelPublishing' not found (return type defaults to 'id')**
    Use the class method `+[JREngage cancelSharing]` instead


### Solutions for upgrading v2.3.x to v3.4.0

* **Instance method '-showAuthenticationDialogWithCustomInterfaceOverrides:' not found (return type defaults to 'id')**

    Use `+[JREngage showAuthenticationDialogWithCustomInterfaceOverrides:]` instead.


### Solutions for upgrading v2.2.0 to v3.4.0

* **Instance method '-setCustomNavigationController:' not found (return type defaults to 'id')**

    **Instance method '-setCustomInterfaceDefaults:' not found (return type defaults to 'id')**

    Use `+[JREngage showAuthenticationDialogWithCustomInterfaceOverrides:]` instead. For example if you had:

            NSDictionary *myCustomInterface = @{
                    kJRProviderTableHeaderView : embeddedTable.view,
                    kJRProviderTableSectionHeaderTitleString : @"Sign in with a social provider"
            };
            [myJREngageInstance setCustomNavigationController:myNavigationController]
            [customInterface addEntriesFromDictionary:myCustomInterface];
            [myJREngageInstance setCustomInterfaceDefaults:customInterface];
            [myJREngageInstance showAuthenticationDialog];

    Then do the following:

            NSDictionary *myCustomInterface = @{
                    kJRProviderTableHeaderView : embeddedTable.view,
                    kJRProviderTableSectionHeaderTitleString : @"Sign in with a social provider",
                    kJRApplicationNavigationController : myNavigationController
            };
            [JREngage showAuthenticationDialogWithCustomInterfaceOverrides:myCustomInterface];


## Upgrading from 3.0.x to 3.1

The signature to the JRCapture initialization method added a new parameter to its selector, `customIdentityProviders:`,
which describes custom identity providers to configure the library with. See `Engage Custom Provider Guide.md` for more
details.

## Upgrading from 3.1.x to 3.2

The signature to the JRCapture initialization method added several new parameters to its selector.  See the selector
in `JRCapture.h` which begins "setEngageAppId:" for the current list of parameters.
