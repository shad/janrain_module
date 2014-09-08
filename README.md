# JanRain in Titanium

!! USE AT YOUR OWN PERIL !!

I'm using this in production, but I make no assurances that this will work
in your specific case. JanRain is suprisingly complex to get working just
right, so this module is here as information to others only.

## Modified JanRain Source

JanRain source was modified to ask for the correct permissions.
By default, JanRain only asks for `public_profile` but we needed more and
there was no way to configure. If you don't need this, then change it back
to the default.

Check out near the bottom of JRNativeFacebook.m and add/remove privileges.

    objc_msgSend(
            fbSession,
            NSSelectorFromString(@"openActiveSessionWithReadPermissions:allowLoginUI:completionHandler:"),
            @[
            @"public_profile",
            @"email",
            @"user_friends",
            @"user_about_me",
            @"user_birthday",
            @"user_location",
            @"user_photos",
            @"read_friendlists"
            ], YES, handler);
