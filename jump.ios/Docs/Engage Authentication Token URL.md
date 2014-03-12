## Server-side Authentication

You will also want to implement [Server-side Authentication](http://developers.janrain.com/documentation/mobile-libraries/jump-for-android/engage-for-android/#server-side-authentication).

If you would like to access any of the extra features available in the Janrain Engage API, or if you would
like to complete server-side authentication, do so by implementing a token URL as follows:

1.  Create a server side HTTP or HTTPS endpoint (preferably HTTPS). This will be your `auth_info`
    token URL, and mobile devices running your mobile app will POST an Engage
    `[auth_info](/documentation/api/auth_info/ "auth_info")` token to this endpoint, in exchange for an
    access token for your web service.
2.  From the new endpoint, extract the token. It's POSTed in a parameter named `token`.
3.  Call `auth_info`. Supply the token just received, and your application's 40-character Engage API
    key.
4.  Process the profile data returned from `[auth_info](/documentation/api/auth_info/ "auth_info")`,
    and log your user into your web application. (The unique and secure key you should use to identify the
    user is the `identifier` field of the `profile` node.) As necessary create and return
    access tokens or session cookies in your endpoint's response. Your mobile app will receive that response.

For example, in Ruby on Rails, you might rely on the `ActionController` session and the cookie that
it sets like so:

    # The following helper class is from the Engage sample code found at
    # https://github.com/janrain/Janrain-Sample-Code
    ENGAGE = Rpx::RpxHelper.new("your_api_key_here",
                                "http://rpxnow.com",
                                "your_engage_app_realm_here") # e.g. mytestapp

    # This is the Engage auth_info token URL -- the endpoint which spawns
    # new mobile user sessions.
    def mobileEngageSignIn
       auth_info = ENGAGE.auth_info(params[:token])

       identifier = auth_info['identifier']

       user = User.find_or_create_by_engage_identifier(identifier)
       # do other stuff, like populate the User record with the auth_info

       session[:user_id] = user.id
    end

If you're using the Rails `ActionController` session, you should set the cookie expiration to an
appropriate value for a mobile device:

    # This initializer block is found in app/config/environment.rb
    Rails::Initializer.run do |config|
      config.action_controller.session[:session_expires] = 10.years.from_now
    end

Then, make sure that you save the cookie in your mobile app; for example:

org.apache.http.cookie.Cookie[] mSessionCookies;

    public void jrAuthenticationDidReachTokenUrl(String tokenUrl,
                                                 HttpResponseHeaders responseHeaders,
                                                 String tokenUrlPayload,
                                                 String provider) {
        mSessionCookies = responseHeaders.getCookies();
    }

From your new `auth_info` token URL you can also access access other Engage features. For example, you
could call `[get_contacts](/documentation/api/get_contacts/ "get_contacts")`* and use the contact list
returned to find other users of your mobile app that this user may know.

_* Some features are limited to Pro, Plus, or Enterprise customers only._

To configure the library with your token URL, pass it to
[`initInstance`](http://janrain.github.com/engage.android/docs/html/classcom_1_1janrain_1_1android_1_1engage_1_1_j_r_engage.html#a469d808d2464c065bc16dedec7a2cc23)
when initializing the library:

    private static final String ENGAGE_APP_ID = "";
    private static final String ENGAGE_TOKEN_URL = "";
    private JREngage mEngage;
    private JREngageDelegate mEngageDelegate;

    ...

    mEngage = JREngage.initInstance(this, engageAppId, engageTokenUrl, mEngageDelegate);

Alternatively, you can change the token URL at any time using the
[`setTokenUrl`](http://janrain.github.com/engage.android/docs/html/classcom_1_1janrain_1_1android_1_1engage_1_1_j_r_engage.html#a9cae37926c51b92a0d934b65cd14829c)
method:

    JREngage mEngage;

    ...

    mEngage.setTokenUrl(newTokenUrl);

You may configure the library with a null or empty token URL, and this authentication step will be skipped.

Whether or not the library posts the token to the token URL, your Android application must not contain your
Engage API key.
