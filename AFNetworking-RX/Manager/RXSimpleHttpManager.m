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





+ (id)uploadkkkk
{
    NSDictionary *dic = @{@"SESSIONID":@"38cd0cadedcdcf8e3cc252106653db3b",
                          @"type":@(1)};
    NSString *url = @"v1/uploadpic";
    
    return [self uploadActionWithUrl:url parameters:dic];
}



+ (id)uploadActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters
{
    RXSimpleHttpManager *http = [[self alloc] init];
    [http.httpSessionManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = [UIImage imageNamed:@"1024"];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        // 以文件流格式上传图片
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress *uploadProgress) {
        NSLog(@"progeresss");
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error");
    }];
    return http;
}










+ (id)getActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion
{
    RXSimpleHttpManager *http = [[self alloc] init];
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



+ (id)postActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion
{
    RXSimpleHttpManager *http = [[self alloc] init];
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