//
// Created by nathan on 10/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef enum propertyTypes
{
    PTString,
    PTBoolean,
    PTInteger,
    PTNumber,
    PTDate,
    PTDateTime,
    PTIpAddress,
    PTPassword,
    PTJsonObject,
    PTArray,
    PTStringArray,
    PTCaptureObject,
    PTUuid,
    PTObjectId,
    PTUnknown,
} PropertyType;

Class getPluralClassFromKey(NSString *key);
Class getClassFromKey(NSString *key);
NSString *upcaseFirst(NSString *string);

@interface Utils : NSObject
+ (void)handleSuccessWithTitle:(NSString *)title message:(NSString *)message forVc:(UIViewController *)forVc;

+ (void)handleFailureWithTitle:(NSString *)title message:(NSString *)message;
@end