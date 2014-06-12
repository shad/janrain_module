/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComFoodonthetableJanrainModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "JRActivityObject.h"
#import "JREngage+CustomInterface.h"

@implementation ComFoodonthetableJanrainModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"b95d9070-8736-47f9-806d-280224c4c61a";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.foodonthetable.janrain";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

//	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma JanRain Social Login
- (void)initWithAppId:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);
  //ENSURE_SINGLE_ARG(args, NSString);
  //NSString *appId = [TiUtils stringValue:arg];
  //NSLog(args);
  id arg = [args objectAtIndex:0];
  [JREngage setEngageAppId:arg tokenUrl:nil andDelegate:self];
}

-(void)socialLogin:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    id provider = [args objectAtIndex:0];
    
    NSMutableDictionary* myEngageCustomizations = [NSMutableDictionary dictionary];
    UINavigationController *myNewNav = [[[UINavigationController alloc] init] autorelease];
    myNewNav.navigationBar.tintColor=[UIColor whiteColor];
    myNewNav.navigationBar.barTintColor = [UIColor colorWithRed:0.878 green:0.325 blue:0.282 alpha:1]; /*#e05348*/
    myNewNav.navigationBar.translucent = NO;
    myNewNav.navigationBar.barStyle = UIBarStyleBlack;
    
    
    [myEngageCustomizations setObject:myNewNav forKey:kJRCustomModalNavigationController];
    [myEngageCustomizations setObject:[UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1.0]
                               forKey:kJRAuthenticationBackgroundColor];

    
    [JREngage showAuthenticationDialogForProvider:provider
                     withCustomInterfaceOverrides:myEngageCustomizations];
}

- (void)authenticationDidReachTokenUrl:(NSString *)tokenUrl withResponse:(NSURLResponse *)response
                            andPayload:(NSData *)tokenUrlPayload forProvider:(NSString *)provider
{
  //NSLog(@"%@", [response description]);
  // not used ATM
}

- (void)authenticationDidSucceedForUser:(NSDictionary *)authInfo forProvider:(NSString *)provider
{
  //NSLog(@"%@", [authInfo description]);
  NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:authInfo,@"authInfo",
                                                                   provider, @"provider",
                                                                   nil];
  [self fireEvent:@"auth:success" withObject:event];
}


- (void)authenticationDidFailWithError:(NSError *)error forProvider:(NSString *)provider
{
  NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:[error userInfo],@"error",
                                                                   [error localizedDescription], @"message",
                                                                   provider, @"provider",
                                                                   nil];
  [self fireEvent:@"auth:error" withObject:event];
}


- (void)authenticationDidNotComplete
{
  [self fireEvent:@"auth:cancel"];
}

#pragma JanRain Social Share
- (void)socialShare:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    
    NSDictionary *activityHash = [args objectAtIndex:0];

    NSString *action = [activityHash objectForKey:@"action"];
    NSString *url = [activityHash objectForKey:@"url"];
    NSString *userGeneratedContent = [activityHash objectForKey:@"userGeneratedContent"];
    
    
    JRActivityObject *activity = [JRActivityObject activityObjectWithAction:action andUrl:url];
    
    if (userGeneratedContent)
    {
        [activity setUserGeneratedContent:userGeneratedContent];
    }

    // EMAIL
    NSDictionary *emailHash = [activityHash objectForKey:@"email"];
//    NSLog(@"%@", emailHash);
    JREmailObject *email;
    if (emailHash)
    {
        email = [JREmailObject emailObjectWithSubject: [emailHash objectForKey:@"subject"]
                                       andMessageBody: [emailHash objectForKey:@"messageBody"]
                                               isHtml: [emailHash objectForKey:@"isHtml"]
                                 andUrlsToBeShortened: [emailHash objectForKey:@"urls"]];
        [activity setEmail:email];
    }
    
    // SMS
    JRSmsObject *sms;
    NSDictionary *smsHash = [activityHash objectForKey:@"sms"];
//    NSLog(@"%@", smsHash);
    if (smsHash)
    {
        sms = [JRSmsObject smsObjectWithMessage:[smsHash objectForKey:@"message"]
                           andUrlsToBeShortened:[smsHash objectForKey:@"urls"]];
        [activity setSms:sms];
        
    }
    
    
    [JREngage showSharingDialogWithActivity:activity];
}

- (void)sharingDidSucceedForActivity:(JRActivityObject *)activity forProvider:(NSString *)provider
{
    //NSLog(@"%@", [authInfo description]);
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                           [activity dictionaryForObject],@"activity",
                           provider, @"provider",
                           nil];
    [self fireEvent:@"share:success" withObject:event];
}

- (void)sharingDidFailForActivity:(JRActivityObject *)activity withError:(NSError *)error forProvider:(NSString *)provider
{
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:[error userInfo],@"error",
                           [error localizedDescription], @"message",
                           [activity dictionaryForObject], @"activity",
                           provider, @"provider",
                           nil];
    [self fireEvent:@"share:error" withObject:event];
}
- (void)sharingDidNotComplete
{
    [self fireEvent:@"share:cancel"];
}


// Logout
- (void)clearSharingCredentials
{
    [JREngage clearSharingCredentialsForAllProviders];
}

@end
