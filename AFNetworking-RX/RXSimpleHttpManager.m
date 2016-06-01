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
#import "RXNetworkingConfigManager.h"


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
    NSString *baseUrlString = [RXNetworkingConfigManager sharedInstance].baseUrlString;
    return [self getActionWithBaseUrl:baseUrlString url:url parameters:parameters completion:completion];
}



+ (id)postActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion
{
    NSString *baseUrlString = [RXNetworkingConfigManager sharedInstance].baseUrlString;
    return [self postActionWithBaseUrl:baseUrlString url:url parameters:parameters completion:completion];
}

+ (id)postActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters image:(UIImage *)image constructingBodyBlock:(void (^)(id<AFMultipartFormData> formData))constructingBodyBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(RXBaseResponse *response))completion
{
    NSString *baseUrlString = [RXNetworkingConfigManager sharedInstance].baseUrlString;
    return [self postActionWithBaseUrl:baseUrlString url:url parameters:parameters image:image constructingBodyBlock:constructingBodyBlock progress:progress completion:completion];
}


+ (id)getActionWithBaseUrl:(NSString *)baseUrl url:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion
{
    parameters = [self mergerSuffixWithDictionary:parameters];
    RXSimpleHttpManager *http = [[self alloc] init];
    http.httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    NSTimeInterval timeoutInterval = [RXNetworkingConfigManager sharedInstance].timeoutInterval;
    [[RXNetworkingConfigManager sharedInstance] configGetHttpSessionManager:http.httpSessionManager timeoutInterval:timeoutInterval parameters:parameters];
    [http.httpSessionManager GET:url parameters:parameters progress:^(NSProgress *downloadProgress) {
        // Do Noting
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [RXSimpleHttpManager resultWithResponseObject:responseObject error:nil completion:completion];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [RXSimpleHttpManager resultWithResponseObject:nil error:error completion:completion];
    }];
    [self printBaseUrl:baseUrl url:url parameters:parameters];
    return http;
}
+ (id)postActionWithBaseUrl:(NSString *)baseUrl url:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion
{
    parameters = [self mergerSuffixWithDictionary:parameters];
    RXSimpleHttpManager *http = [[self alloc] init];
    http.httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    NSTimeInterval timeoutInterval = [RXNetworkingConfigManager sharedInstance].timeoutInterval;
    [[RXNetworkingConfigManager sharedInstance] configPostHttpSessionManager:http.httpSessionManager timeoutInterval:timeoutInterval];
    [http.httpSessionManager POST:url parameters:parameters progress:^(NSProgress *uploadProgress) {
        // Do Noting
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [RXSimpleHttpManager resultWithResponseObject:responseObject error:nil completion:completion];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [RXSimpleHttpManager resultWithResponseObject:nil error:error completion:completion];
    }];
    [self printBaseUrl:baseUrl url:url parameters:parameters];
    return http;
}
+ (id)postActionWithBaseUrl:(NSString *)baseUrl url:(NSString *)url parameters:(NSDictionary *)parameters image:(UIImage *)image constructingBodyBlock:(void (^)(id<AFMultipartFormData> formData))constructingBodyBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(RXBaseResponse *response))completion
{
    parameters = [self mergerSuffixWithDictionary:parameters];
    RXSimpleHttpManager *http = [[self alloc] init];
    http.httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    
    AFHTTPResponseSerializer *responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"image/jpeg", @"text/text", nil];
    http.httpSessionManager.responseSerializer = responseSerializer;
    
    [http.httpSessionManager POST:url parameters:parameters constructingBodyWithBlock:constructingBodyBlock progress:progress success:^(NSURLSessionDataTask *task, id responseObject) {
        [RXSimpleHttpManager resultWithResponseObject:responseObject error:nil completion:completion];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [RXSimpleHttpManager resultWithResponseObject:nil error:error completion:completion];
    }];
    [self printBaseUrl:baseUrl url:url parameters:parameters];
    return http;
}


#pragma mark - Private
+ (NSDictionary *)mergerSuffixWithDictionary:(NSDictionary *)dic
{
    NSDictionary *dic1 = dic;
    NSDictionary *dic2 = [RXNetworkingConfigManager sharedInstance].suffixParameters;
    NSMutableDictionary *resultParameters = nil;
    if (dic1) {
        resultParameters = [NSMutableDictionary dictionaryWithDictionary:dic1];
    } else {
        resultParameters = [NSMutableDictionary dictionary];
    }
    if (dic2 != nil) {
        [resultParameters setValuesForKeysWithDictionary:dic2];
    }
    return resultParameters;
}

+ (void)printBaseUrl:(NSString *)baseUrl url:(NSString *)url parameters:(NSDictionary *)parameters
{
    NSString *tmp = [NSString stringWithFormat:@"%@/%@", baseUrl, url];
    NSString *str = [RXAFNetworkingGlobal parametersFromDictionary:parameters];
    RXAFnetworkingPrintUrlAndParameters(@"url:%@ paramters:%@", tmp, str);
}

#pragma mark - Public

- (void)cancel
{
    [RXNetworkingConfigManager cancelHttpSessionManager:self.httpSessionManager];
}



#pragma mark - class private

+ (void)resultWithResponseObject:(id)responseObject error:(NSError *)error completion:(void (^)(RXBaseResponse *response))completion
{
    if (completion) {
        [RXNetworkingConfigManager analysisInOtherRunLoopWithRequest:nil responseObject:responseObject error:error group:nil completion:completion];
    }

}







@end
