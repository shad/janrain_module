//
// Created by nathan on 10/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AppDelegate.h"
#import "Utils.h"

Class getPluralClassFromKey(NSString *key)
{
    if (!key || [key length] < 1) return nil;
    NSString *className = [NSString stringWithFormat:@"JR%@Element", upcaseFirst(key)];
    return NSClassFromString(className);
}

Class getClassFromKey(NSString *key)
{
    if (!key || [key length] < 1) return nil;
    NSString *className = [NSString stringWithFormat:@"JR%@", upcaseFirst(key)];
    return NSClassFromString(className);
}

NSString *upcaseFirst(NSString *string)
{
    if (!string) return nil;
    if (![string length]) return string;
    return [string stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                           withString:[[string substringToIndex:1] capitalizedString]];
}

@implementation Utils
+ (void)handleSuccessWithTitle:(NSString *)title message:(NSString *)message forVc:(UIViewController *)forVc
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];

    [forVc.navigationController popViewControllerAnimated:YES];

    [appDelegate saveCaptureUser];
}

+ (void)handleFailureWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}
@end