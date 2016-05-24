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
    NSTimeInterval timeoutInterval = [RXNetworkingConfigManager sharedInstance].timeoutInterval;
    [[RXNetworkingConfigManager sharedInstance] configGetHttpSessionManager:http.httpSessionManager timeoutInterval:timeoutInterval parameters:parameters];
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
    NSTimeInterval timeoutInterval = [RXNetworkingConfigManager sharedInstance].timeoutInterval;
    [[RXNetworkingConfigManager sharedInstance] configPostHttpSessionManager:http.httpSessionManager timeoutInterval:timeoutInterval];

    
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
