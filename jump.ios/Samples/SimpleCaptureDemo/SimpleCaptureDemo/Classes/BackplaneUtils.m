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

 Author: ${USER}
 Date:   ${DATE}
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "debug_log.h"
#import "BackplaneUtils.h"
#import "JRConnectionManager.h"

@implementation BackplaneUtils
+ (void)asyncFetchNewBackplaneChannelWithBus:(NSString *)bpBusUrlString 
                                  completion:(void(^)(NSString *newChannel, NSError *error))completion __unused
{
    if (!bpBusUrlString) return;
    NSURL *bpNewChanUrl = [NSURL URLWithString:[bpBusUrlString stringByAppendingString:@"/channel/new"]];
    NSURLRequest *req = [NSURLRequest requestWithURL:bpNewChanUrl cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                     timeoutInterval:5];
    void (^urlHandler)(NSURLResponse *, NSData *, NSError *) = ^(NSURLResponse *r, NSData *d, NSError *e)
    {
        NSInteger code = [((NSHTTPURLResponse *) r) statusCode];
        if (e || code != 200)
        {
            [self fireErrorOnCompletion:completion r:r d:d e:e code:code errorDesc:nil];
        }
        else
        {
            NSString *body = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
            NSCharacterSet *quoteSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
            NSString *bpChannel = [body stringByTrimmingCharactersInSet:quoteSet];
            NSString *bpChannelUrl_ = [bpBusUrlString stringByAppendingFormat:@"/channel/%@",
                                                                              bpChannel];
            DLog(@"New BP channel: %@", bpChannelUrl_);
            completion(bpChannelUrl_, nil);
            [JRCapture setBackplaneChannelUrl:bpChannelUrl_];
        }
    };
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:urlHandler];
}

+ (void)fireErrorOnCompletion:(void (^)(NSString *, NSError *))completion r:(NSURLResponse *)r d:(NSData *)d
                            e:(NSError *)e code:(NSInteger)code errorDesc:(NSString *)desc
{
    ALog(@"%@: %@, code: %i", desc, e, code);
    NSMutableDictionary *errDict = [NSMutableDictionary dictionary];
    if (r) [errDict setObject:r forKey:@"url_response"];
    if (d) [errDict setObject:d forKey:@"url_data"];
    if (e) [errDict setObject:e forKey:@"error"];
    if (desc) [errDict setObject:desc forKey:@"error_description"];

    NSDictionary *errDict_ = [NSDictionary dictionaryWithDictionary:errDict];
    completion(nil, [NSError errorWithDomain:@"BackplaneUtils" code:0 userInfo:errDict_]);
}

+ (void)asyncFetchNewLiveFyreUserTokenWithArticleId:(NSString *)liveFyreArticleId
                                            network:(NSString *)liveFyreNetwork
                                             siteId:(NSString *)liveFyreSiteId
                                   backplaneChannel:(NSString *)bpChannelUrl
                                         completion:(void(^)(NSString *, NSError *))completion __unused
{
    if (!liveFyreArticleId || !liveFyreNetwork || !liveFyreSiteId) {
        completion(nil, [NSError errorWithDomain:@"BackplaneUtils" code:0
                                        userInfo:[NSDictionary dictionaryWithObject:@"bad params"
                                                                             forKey:@"error_description"]]);
        return;
    }

    NSString *lfAuthUrl = [NSString stringWithFormat:@"http://admin.%@/api/v3.0/auth?bp_channel=%@&siteId=%@"
                                                             "&articleId=%@",
                                                     liveFyreNetwork,
                                                     [bpChannelUrl stringByAddingUrlPercentEscapes],
                                                     liveFyreSiteId,
                                                     [liveFyreArticleId stringByAddingUrlPercentEscapes]];
    
    DLog(@"Fetching LF token from %@", lfAuthUrl);
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:lfAuthUrl]
                                         cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                     timeoutInterval:5];

    void (^urlHandler)(NSURLResponse *, NSData *, NSError *) = ^(NSURLResponse *r, NSData *d, NSError *e)
    {
        //NSString *body = d ? [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]
        //        : nil;
        NSInteger code = [((NSHTTPURLResponse *) r) statusCode];
        if (e || code != 200)
        {
            [self fireErrorOnCompletion:completion r:r d:d e:e code:0 errorDesc:nil];
        }
        else
        {
            NSError *jsonErr = nil;
            NSDictionary *lfResponse = [NSJSONSerialization JSONObjectWithData:d options:0 error:&jsonErr];
            if (!lfResponse)
            {
                [self fireErrorOnCompletion:completion r:r d:d e:nil code:0 errorDesc:@"Error parsing LF response."];
                return;
            }
            
            NSString *lfToken_ = [[lfResponse objectForKey:@"data"] objectForKey:@"token"];
            if (!lfToken_)
            {
                [self fireErrorOnCompletion:completion r:r d:d e:nil code:0
                                  errorDesc:@"Error retrieving token from LF response."];
                return;
            }

            completion(lfToken_, nil);
            
        }
    };

    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:urlHandler];
}

@end
