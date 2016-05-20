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




+ (id)exhibitionListWithOffset:(NSInteger)offset num:(NSInteger)num completion:(void (^)(RXBaseResponse *response))completion
{
    NSString *url = @"v1/zhanhui";
    NSDictionary *dic = @{@"num":@(num),
                          @"offset":@(offset)};
    id http = [self getActionWithUrl:url parameters:dic completion:completion];
    return http;
}





+ (id)uploadWithSessionId:(NSString *)sessionId type:(NSInteger)type image:(UIImage *)image constructingBodyBlock:(void (^)(id<AFMultipartFormData> formData))constructingBodyBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(RXBaseResponse *response))completion
{
    NSDictionary *dic = @{@"SESSIONID":image,
                          @"type":@(type)};
    NSString *url = @"v1/uploadpic";
    return [self postActionWithUrl:url parameters:dic image:image constructingBodyBlock:constructingBodyBlock progress:progress completion:completion];
}






#pragma mark - Class Method








+ (id)getActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion
{
    RXSimpleHttpManager *http = [[self alloc] init];
    AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    [requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError **error) {
        // 注意此处的参数: parameters 跟 函数的parameters是不一样的,也许值是一样的
        return [RXAFNetworkingGlobal parametersFromDictionary:parameters];
    }];
    requestSerializer.timeoutInterval = [RXNetworkingConfigManager sharedInstance].timeoutInterval;
    http.httpSessionManager.requestSerializer = requestSerializer;
    [http.httpSessionManager GET:url parameters:parameters progress:^(NSProgress *downloadProgress) {
        // Do Noting
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [RXSimpleHttpManager resultWithResponseObject:responseObject error:nil completion:completion];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [RXSimpleHttpManager resultWithResponseObject:nil error:error completion:completion];
    }];
    return http;
    
}



+ (id)postActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion
{
    RXSimpleHttpManager *http = [[self alloc] init];
    AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    requestSerializer.timeoutInterval = [RXNetworkingConfigManager sharedInstance].timeoutInterval;
    http.httpSessionManager.requestSerializer = requestSerializer;
    [http.httpSessionManager POST:url parameters:parameters progress:^(NSProgress *uploadProgress) {
        // Do Noting
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [RXSimpleHttpManager resultWithResponseObject:responseObject error:nil completion:completion];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [RXSimpleHttpManager resultWithResponseObject:nil error:error completion:completion];
    }];
    return http;
}




+ (id)postActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters image:(UIImage *)image constructingBodyBlock:(void (^)(id<AFMultipartFormData> formData))constructingBodyBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(RXBaseResponse *response))completion
{
    RXSimpleHttpManager *http = [[self alloc] init];
    [http.httpSessionManager POST:url parameters:parameters constructingBodyWithBlock:constructingBodyBlock progress:progress success:^(NSURLSessionDataTask *task, id responseObject) {
        [RXSimpleHttpManager resultWithResponseObject:responseObject error:nil completion:completion];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [RXSimpleHttpManager resultWithResponseObject:nil error:error completion:completion];
    }];
    return http;
}




#pragma mark - class private

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
