//
// Created by nathan on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "NSDictionary+JRQueryParams.h"
#import "JRConnectionManager.h"

@implementation NSDictionary (JRQueryParams)
- (NSString *)asJRURLParamString
{
    NSMutableString *retVal = [NSMutableString string];

    for (id key in [self allKeys])
    {
        if ([retVal length] > 0) [retVal appendString:@"&"];
        NSString *value = [self objectForKey:key];
        NSString *urlEncodedValue = [value stringByAddingUrlPercentEscapes];
        [retVal appendFormat:@"%@=%@", key, urlEncodedValue];
    }

    return retVal;
}
@end