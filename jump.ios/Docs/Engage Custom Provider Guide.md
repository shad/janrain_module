# Engage Custom Provider Guide

This guide describes the process of configuring custom OpenID and custom SAML providers into the Engage library.
This guide assumes you have already completed either the `Engage-Only Integration Guide.md` or the
`JUMP Integration Guide.md`.

## 10,000' View

1. Gather configuration details
2. Build a custom-providers configuration dictionary
3. Initialize the library with the dictionary
4. Begin authentication by calling one of the "show...Dialog" methods.

## Gather Configuration Details

For each custom provider you wish to configure gather the following configuration details:

* Provider ID -- a short string which will be used to refer to the custom provider. E.g. the provider ID for Yahoo!
  is "yahoo". This is used only in the context of the iOS app, and can be any arbitrary value you choose.
* Friendly name -- a string representing the user-facing name of the provider. E.g. the friendly name for Yahoo! is
  "Yahoo!".

### Custom Open ID

In addition to the configuration details above you will need:

* The OpenID identifier of your custom OpenID provider.
* Optionally, a custom "opx_blob" parameter for use with Janrain Identity Services' OpenID providers.

### Custom SAML

In addition to the configuration details above you will need:

* The name of the SAML implementation in Engage for your custom SAML provider.

## Build the Custom-Providers Configuration Dictionary

Construct an NSDictionary similar to this example. The field names in the inner dictionaries are important. (I.e.
the field for friendly name must be "friendly_name".):

    NSDictionary *customProviders =
        @{
            @"my_custom_saml_provider": // this is the "provider ID".
                @{
                    @"friendly_name": @"Example Custom SAML Provider",
                    @"saml_provider": @"the_name_of_the_engage_implementation_of_the_saml_provider"
                },
            @"my_custom_openid_provider":
                @{
                    @"friendly_name": @"Example Custom OpenID Provider",
                    @"openid_identifier": @"https://my-custom-openid-provider.com/example-openid-identifier",
                    @"opx_blob": @"some_blob_for_opx" // This is an optional field
                },
            // You can define more custom SAML or custom OpenID providers below. They just need to have different
            // "provider IDs"
        };

## Icons

You can add a 30x30 provider icon for you custom providers by naming the icon `icon_your-provider-id-here_30x30.png`
and including the icon file in your iOS app's Resources project group.

## Initialize the Library with the Dictionary

The configuration of the custom providers varies slightly between Engage-only and complete JUMP integrations.

### JUMP

Call:

    +[JRCapture setEngageAppId:captureDomain:captureClientId:captureLocale:captureFlowName:captureFormName:captureTraditionalSignInType:customIdentityProviders:]

... passing in the custom provider configuration dictionary you defined for the `customIdentityProviders:` parameter.

### Engage-Only

Initialize the library as usual, then call `+[JREngage setCustomProviders:]` passing in the custom provider
configuration dictionary you defined for the customProviders parameter.

## Begin Authentication

Start authentication as you normally would (or as described in the integration guide). Your custom providers will
appear in the stock authentication provider list UI. You can skip the stock provider-list UI and start authentication
directly on any provider, including your custom providers:

For whole-JUMP integrations use: `+[JRCapture startEngageSignInDialogOnProvider:forDelegate:]`.
For Engage-only integrations use: `+[JREngage showAuthenticationDialogForProvider:]`.

(There are also other variants of those methods which accept a provider ID parameter.)
