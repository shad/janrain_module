/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "JRJsonUtils.h"
#import "debug_log.h"

@implementation JRJsonUtils
+ (NSString *)jsonStringForJsonObject:(id)jsonObject
{
    NSError *jsonErr = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:&jsonErr];
    if (jsonErr) ALog("WARNING, JSON serialization error: %@", jsonErr);
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
#if !__has_feature(objc_arc)
    [jsonString autorelease];
#endif
    return jsonString;
}

+ (id)jsonObjectWithString:(NSString *)jsonString
{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [self jsonObjectWithData:jsonData];
}

+ (id)jsonObjectWithData:(NSData *)jsonData
{
    NSError *jsonErr = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingOptions) 0 error:&jsonErr];
    if (jsonErr) ALog("WARNING, JSON parse error: %@", jsonErr);
    return jsonObject;
}
@end

@implementation NSString (JRJsonUtils)
- (id)JR_objectFromJSONString
{
    return [JRJsonUtils jsonObjectWithString:self];
}
@end

@implementation NSDictionary (JRJsonUtils)
- (NSString *)JR_jsonString
{
    return [JRJsonUtils jsonStringForJsonObject:self];
}

- (BOOL)JR_isOKStatus
{
    return [@"ok" isEqualToString:[self objectForKey:@"stat"]];
}
@end

@implementation NSArray (JRJsonUtils)
- (NSString *)JR_jsonString
{
    return [JRJsonUtils jsonStringForJsonObject:self];
}
@end