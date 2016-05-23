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
#import "RXBaseResponse.h"


@interface RXBaseRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;


@end



@implementation RXBaseRequest


#pragma mark - Public
- (void)startWithCompletion:(RXRequestCompletionBlock)completion
{
    [self startWithCompletion:completion group:NULL queue:NULL];
}

- (void)start
{
    [self startWithCompletion:nil group:NULL queue:NULL];
}


- (void)startWithCompletion:(RXRequestCompletionBlock)completion group:(dispatch_group_t)group queue:(dispatch_queue_t)queue;
{
    
    [[RXNetworkingConfigManager sharedInstance] addRequest:self];
    
    self.completion = completion;
    // 这里如何使用__strong 而不使用一个RequestArray 会无法释放
    __weak __typeof(self) weakSelf = self;
    
    
    
    
    
    if (group) {
        dispatch_group_enter(group);
        self.httpSessionManager.completionGroup = group;
    }
    if (queue) {
        self.httpSessionManager.completionQueue = queue;
    }
    
    switch (self.e_RXRequestMethod) {
        case kE_RXRequestMethod_Get:
        {
            [[RXNetworkingConfigManager sharedInstance] configGetHttpSessionManager:self.httpSessionManager timeoutInterval:self.timeoutInterval parameters:weakSelf.requestParameters];
            [self.httpSessionManager GET:self.requestUrlString parameters:weakSelf.requestParameters progress:^(NSProgress * _Nonnull downloadProgress) {
                // Do Noting
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [weakSelf safeBlock_completion:weakSelf responseObject:responseObject error:nil group:group];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [weakSelf safeBlock_completion:weakSelf responseObject:nil error:error group:group];
            }];
        }
            break;
        case kE_RXRequestMethod_Post:
        default:
        {
            [[RXNetworkingConfigManager sharedInstance] configPostHttpSessionManager:self.httpSessionManager timeoutInterval:self.timeoutInterval];

            [self.httpSessionManager POST:self.requestUrlString parameters:self.requestParameters constructingBodyWithBlock:self.constructingBodyBlock progress:self.uploadProgress success:^(NSURLSessionDataTask *task, id responseObject) {
                [weakSelf safeBlock_completion:weakSelf responseObject:responseObject error:nil group:group];
            } failure:^(NSURLSessionDataTask *task, NSError * error) {
                [weakSelf safeBlock_completion:weakSelf responseObject:nil error:error group:group];
            }];
        }
            break;
    }
}


- (void)cancel
{
    [RXNetworkingConfigManager cancelHttpSessionManager:self.httpSessionManager];
}




#pragma mark - Safe Block
- (void)safeBlock_completion:(RXBaseRequest *)request responseObject:(id)responseObject error:(NSError *)error group:(dispatch_group_t)group
{
    // 全部放在主线程
    self.response = [RXBaseResponse responseWithResponseObject:responseObject error:error];
    
    if (self.completion != nil) {
        self.completion(self);
        self.completion = nil;
    }
    
    if (group) {
        dispatch_group_leave(group);
    }
    [[RXNetworkingConfigManager sharedInstance] removeRequest:self];

    
}




- (void)dealloc
{
    // 可以正常释放
    RXAFnetworkingLog(@"base request dealloc");
}






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

- (void (^)(id<AFMultipartFormData> formData))constructingBodyBlock
{
    return nil;
}

























@end
