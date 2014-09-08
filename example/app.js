var janrain = require('com.foodonthetable.janrain');
janrain.initWithAppId("aaaaaaaaaaaaaaaaaaaa");

janrain.addEventListener("auth:success", function (event) {
  Ti.API.info("auth:success");
  Ti.API.info("provider:" + JSON.stringify(event.provider));
  Ti.API.info("authInfo:" + JSON.stringify(event.authInfo));
});
janrain.addEventListener("auth:cancel", function (event) {
  Ti.API.info("auth:cancel");
  Ti.API.info("provider:" + JSON.stringify(event.provider));
});
janrain.addEventListener("auth:error", function (event) {
  Ti.API.info("auth:cancel");
  Ti.API.info("provider:" + JSON.stringify(event.provider));
  Ti.API.info("message:" + JSON.stringify(event.message));
  Ti.API.info("error:" + JSON.stringify(event.error));
});



janrain.addEventListener('share:success', function (event) {
  Ti.API.info('share:success');
  Ti.API.info("event:" + JSON.stringify(event));
});
janrain.addEventListener('share:cancel', function (event) {
  Ti.API.info('share:cancel');
});
janrain.addEventListener('share:error', function (event) {
  Ti.API.info('share:error');
  Ti.API.info("event:" + JSON.stringify(event));
});



// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
var socialButton = Ti.UI.createButton({
  top:40,
  left:10, right:10,
  title:'Social Login'
});
win.add(socialButton);

var fbButton = Ti.UI.createButton({
  top:100,
  left:10, right:10,
  title:'Facebook Login'
});
win.add(fbButton);


var share = Ti.UI.createButton({
  top:160,
  left:10, right:10,
  title:'Share'
});
win.add(share);




win.open();

socialButton.addEventListener('click', function () {
  janrain.socialLogin();
});
fbButton.addEventListener('click', function () {
  janrain.socialLogin('facebook');
});

share.addEventListener('click', function () {
  janrain.socialShare({
    action:"shared a recipe.",
    userGeneratedContent:"I really liked this thing!",
    url:"http://foo.com/recipes/1234",
    email: {
      subject:"Nice Recipe!",
      messageBody:"Check out this recipe: http://food.com/recipes/1234",
      isHTML:false,
      urls:["http://foo.com/recipes/1234"]
    },
    sms: {
      message:"Check out this recipe: http://food.com/recipes/1234",
      urls:["http://foo.com/recipes/1234"]
    }
  });
});

