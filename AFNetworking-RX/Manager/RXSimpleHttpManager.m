//
//  RXSimpleHttpManager.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/20.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXSimpleHttpManager.h"
#import "RXNetworkingConfigManager.h"
#import "RXAFNetworkingGlobal.h"
#import "RXBaseResponse.h"

@interface RXSimpleHttpManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;


@end

@implementation RXSimpleHttpManager




+ (RXSimpleHttpManager *)exhibitionListWithOffset:(NSInteger)offset num:(NSInteger)num completion:(void (^)(RXBaseResponse *response))completion
{
    NSString *url = @"v1/zhanhui";
    NSDictionary *dic = @{@"num":@(num),
                          @"offset":@(offset)};
    RXSimpleHttpManager *http = [self getActionWithUrl:url parameters:dic completion:completion];
    return http;
}


+ (RXSimpleHttpManager *)getActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion
{
    RXSimpleHttpManager *http = [[RXSimpleHttpManager alloc] init];
    AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    [requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError **error) {
        // 注意此处的参数: parameters 跟 函数的parameters是不一样的
        return [RXAFNetworkingGlobal parametersFromDictionary:parameters];
    }];
    requestSerializer.timeoutInterval = 45;
    http.httpSessionManager.requestSerializer = requestSerializer;
    [http.httpSessionManager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // Do Noting
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [RXSimpleHttpManager resultWithResponseObject:responseObject error:nil completion:completion];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [RXSimpleHttpManager resultWithResponseObject:nil error:error completion:completion];
    }];
    return http;
    
}



+ (RXSimpleHttpManager *)postActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion
{
    
    RXSimpleHttpManager *http = [[RXSimpleHttpManager alloc] init];
    AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    requestSerializer.timeoutInterval = 45;
    http.httpSessionManager.requestSerializer = requestSerializer;
    [http.httpSessionManager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // Do Noting
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [RXSimpleHttpManager resultWithResponseObject:responseObject error:nil completion:completion];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [RXSimpleHttpManager resultWithResponseObject:nil error:error completion:completion];
    }];
    
    return http;
}

+ (void)resultWithResponseObject:(id)responseObject error:(NSError *)error completion:(void (^)(RXBaseResponse *response))completion
{
    if (completion) {
        RXBaseResponse *response = [RXBaseResponse responseWithResponseObject:responseObject error:error];
        completion(response);
    }

}


#pragma mark - Property
- (AFHTTPSessionManager *)httpSessionManager
{
    if (_httpSessionManager == nil) {
        NSString *baseUrlString = [RXNetworkingConfigManager sharedInstance].baseUrlString;
        _httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
    }
    return _httpSessionManager;
}





@end
