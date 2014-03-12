# JUMP User Registration Guide

This guide describes use of the user registration feature in the JUMP SDK. This guide is a follow-on to
`JUMP Integration Guide.md`, which describes the fundamentals of the integration process.

## Registration Types

There are three types of user registration:

* "Traditional" registration. This is registration as traditionally implemented. The user fills out a form, and the
  fields of the form are submitted via a JUMP platform API, which registers the user.
* "Thin" social registration. This is automatic registration based on social identities. It is only used in the
  context of a authentication with a social identity. No form is presented to the user. The user's social identity is
  used to populate the fields of a new user record if one does not already exist for their social identity identifier
  URL.
* "Two-step" social registration. This is a registration form with pre-populated values from the user's social
  identity. The first step is "the user authenticates with a social identity, but no user record is found so a
  pre-populated form is returned to the user." The second step is "the user submits the registration form."

## Thin Registration

Thin registration is enabled or disabled at the time that you configure the Capture library, via the
`captureEnableThinRegistration:` part of the configuration selector. Pass `YES` to enable thin registration. No
further configuration is required. When thin registration is possible it will be performed by Capture automatically
and the user will be signed in simultaneously.

### Thin Registration Requirements

For thin registration to succeed all Capture schema constraints and rules must be fulfillable with the social profile.
(See http://developers.janrain.com/documentation/api-methods/capture/entitytype/setattributeconstraints/
and http://developers.janrain.com/documentation/api-methods/capture/entitytype/rules/ ) If a constraint or rule cannot
be met then thin registration will not occur, and the JUMP for iOS library will return an error code 3310,
`JRCaptureApidErrorRecordNotFound`. For example, if there is the schema constraint `required` on the `/email` attribute
of your schema, then users attempting to sign-in with Twitter (which does not profile an email address in it's social
profiles) will not be able to thin-register.

### Detecting Thin Registrations

If thin registration is enabled and succeeds for a user then the `captureAuthenticationDidSucceedForUser:...` message
will be sent to the `JRCaptureSigninDelegate` designated to receive responses from the sign-in process (i.e. the
delegate parameter passed to one of the `startEngageSigninDialogForDelegate:` or its variants, or to
`startCaptureConventionalSigninForUser`.

When `captureAuthenticationDidSucceedForUser:...` is received by your `JRCaptureSigninDelegate` the `status:`
parameter will be `JRCaptureRecordNewlyCreated`.

## Traditional Registration

To perform traditional registration first instantiate an empty Capture user object,
`JRCaptureUser *registeringUser = [JRCaptureUser captureUser]`.

Then, present a registration form of your own creation to the user, allow them to fill in values. There should be a
field in your form for each of the fields in your traditional registration form in your flow. (You can look in
your flow directly, or ask your deployment engineer for a list of these fields.)

For example, for the default Capture schema and the standard user registration flow, display 5 text fields, one each,
for the following attributes in the default Capture schema:

* /email
* /displayName
* /firstName
* /lastName
* /password

When the user submits the form then copy the text field values into the corresponding properties in the Capture user
model object created above. Once the user object is populated with values then call
`+[JRCapture registerNewUser:socialRegistrationToken:forDelegate:]`. Use `nil` for the social registration token.

Upon completion a corresponding delegate message will be sent to the delegate, either `registerUserDidFailWithError:`,
or `registerUserDidSucceed:`.

### Handling Form Validation Failures

Capture performs server side form validation on all forms. If there is s validation error then your delegate will
receive a failure message. The error received in that message can be inspected, and form validation errors can be
differentiated from other (e.g. networking) errors and presented to the user.

To detect a form validation error use `-[NSError isJRFormValidationError]`. A validation error, once detected, can be
further inspected by using `-[JRCaptureError JRValidationFailureMessages]`. This selector returns a dictionary of form-
field-names to array-of-localized-error-messages-for-that-field. For example, it might return a dictionary like:

    @{
        @"email" : @[@"Invalid email address"],
        @"password" : @[@"Passwords must be six or more characters."]
    @}

The localized validation failure messages will be localized in accordance with the locale used to configure the JUMP
library.

## "Two-Step" Social Registration

Two-step social registration is the composition of a failed social sign-in and a registration. It is started via the
social sign-in API first, with a follow-on call to the registration API when the sign-in fails.

To perform a social registration first the user is run through the social sign-in API. Inspect the error received in
`captureAuthenticationDidFailWithError:` with `-[NSError isJRTwoStepRegFlowError]`. If `YES`, then the sign-in error
can be recovered by performing a social registration. The error received will also provide a pre-populated user object
which should be used to pre-populate the social registration form.

### Implementation

Two-step social registration is performed similarly to traditional registration, as described above, but with the
addition of a social registration token in the `registerNewUser:socialRegistrationToken:forDelegate:` message.

The social registration token is retrieved from the error received in `captureAuthenticationDidFailWithError:` with the
`-[NSError JRSocialRegistrationToken]` selector, and the pre-populated user object can be retrieved with
`-[NSError JRPreregistrationRecord]`.

With the pre-populated user record display a form with fields pre-populated by the properties of the pre-registration
record, and pass the social registration token in with the registration message.

Social registration form validation errors can be handled in the same way as traditional registration form validation
errors.

## Forgotten Passwords

When a user submits an incorrect email address or password in a traditional registration sign-in from the
provider list, they are given the option to create new password. The UIAlertView that informs the user of the failed
sign-in has a button to begin the forgotten password flow. Once the user taps "Forgot Password," another UIAlertView is
presented asking the user to confirm their email address. If the user taps "Send," then an API call will be made to
Capture that will trigger an email with instructions on how the user can reset their password.

If you would like to trigger the forgotten password flow directly call
`+[JRCapture startForgottenPasswordRecoveryForEmailAddress:recoverUri:delegate]`.

## Example

In `Samples/SimpleCaptureDemo` see the `RootViewController` for an example of the `JRCaptureSigninDelegate`, and see
`CaptureDynamicForm` for an example of a traditional registration form. `CaptureProfileViewController` is an example of
the social-registration form, although currently only the email address attribute/field is hooked up.
