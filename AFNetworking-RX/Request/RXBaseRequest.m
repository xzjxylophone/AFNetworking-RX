//
//  RXBaseRequest.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXBaseRequest.h"
#import "RXNetworkingConfigManager.h"
#import "RXAFNetworkingGlobal.h"



@interface RXBaseRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end



@implementation RXBaseRequest

#pragma mark - Property
- (AFHTTPSessionManager *)httpSessionManager
{
    if (_httpSessionManager == nil) {
        _httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrlString]];
    }
    return _httpSessionManager;
}

#pragma mark - ReadOnly Property
- (NSInteger)tag
{
    return 0;
}
- (NSString *)baseUrlString
{
    return [RXNetworkingConfigManager sharedInstance].baseUrlString;
}
- (NSString *)requestUrlString
{
    return @"";
}
- (E_RXRequestMethod)e_RXRequestMethod
{
    return kE_RXRequestMethod_Post;
}
- (NSDictionary *)requestParameters
{
    return [NSDictionary dictionary];
}
- (NSTimeInterval)timeoutInterval
{
    return [RXNetworkingConfigManager sharedInstance].timeoutInterval;
}

#pragma mark - Public
- (void)startWithCompletion:(RXRequestCompletionBlock)completion
{
    self.completion = completion;
    [self start];
}

- (void)start
{
    // 这里必须要用__strong
    __strong __typeof(self) strongSelf = self;
    
    
    AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    [requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError **error) {
        return [strongSelf __private_parametersFromDictionary:parameters];
    }];
    requestSerializer.timeoutInterval = self.timeoutInterval;
    self.httpSessionManager.requestSerializer = requestSerializer;
    
    switch (self.e_RXRequestMethod) {
        case kE_RXRequestMethod_Get:
        {
            [self.httpSessionManager GET:self.requestUrlString parameters:self.requestParameters progress:^(NSProgress * _Nonnull downloadProgress) {
                // Do Noting
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [strongSelf safeBlock_completion:strongSelf responseObject:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [strongSelf safeBlock_completion:strongSelf responseObject:nil error:error];
            }];
        }
            break;
        case kE_RXRequestMethod_Post:
        default:
        {
            [self.httpSessionManager POST:self.requestUrlString parameters:self.requestParameters progress:^(NSProgress * progress) {
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [strongSelf safeBlock_completion:strongSelf responseObject:responseObject error:nil];
            } failure:^(NSURLSessionDataTask *task, NSError * error) {
                [strongSelf safeBlock_completion:strongSelf responseObject:nil error:error];
            }];
        }
            break;
    }
}

#pragma mark - Private
- (NSString *)__private_parametersFromDictionary:(NSDictionary *)dic
{
    NSMutableArray *ary = [NSMutableArray array];
    for (NSString *key in dic.allKeys) {
        NSString *value = [dic objectForKey:key];
        [ary addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    NSString *result = [ary componentsJoinedByString:@"&"];
    return result;
}



#pragma mark - Safe Block
- (void)safeBlock_completion:(RXBaseRequest *)request responseObject:(id)responseObject error:(NSError *)error
{
    if (self.completion != nil) {
        self.completion(request, responseObject, error);
        self.completion = nil;
    }
}




- (void)dealloc
{
    // 可以正常释放
    RXAFnetworkingLog(@"dealloc");
}




































@end
