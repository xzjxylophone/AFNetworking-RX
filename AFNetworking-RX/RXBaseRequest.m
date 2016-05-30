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
#import "RXAFNetworkingDefine.h"




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
    


    NSString *str = [RXAFNetworkingGlobal parametersFromDictionary:self.reallyParameters];
    RXAFnetworkingPrintUrlAndParameters(@"url:%@/%@ parameters:%@", self.baseUrlString, self.requestUrlString, str);
    
    
    
    switch (self.e_RXRequestMethod) {
        case kE_RXRequestMethod_Get:
        {
            [[RXNetworkingConfigManager sharedInstance] configGetHttpSessionManager:self.httpSessionManager timeoutInterval:self.timeoutInterval parameters:weakSelf.reallyParameters];
            [self.httpSessionManager GET:self.requestUrlString parameters:weakSelf.reallyParameters progress:^(NSProgress * _Nonnull downloadProgress) {
                // Do Noting
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [weakSelf analysisInOtherRunLoopWithResponseObject:responseObject error:nil group:group];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [weakSelf analysisInOtherRunLoopWithResponseObject:nil error:error group:group];
            }];
        }
            break;
        case kE_RXRequestMethod_Post:
        default:
        {
            [[RXNetworkingConfigManager sharedInstance] configPostHttpSessionManager:self.httpSessionManager timeoutInterval:self.timeoutInterval];

            [self.httpSessionManager POST:self.requestUrlString parameters:self.reallyParameters constructingBodyWithBlock:self.constructingBodyBlock progress:self.uploadProgress success:^(NSURLSessionDataTask *task, id responseObject) {
                [weakSelf analysisInOtherRunLoopWithResponseObject:responseObject error:nil group:group];
            } failure:^(NSURLSessionDataTask *task, NSError * error) {
                [weakSelf analysisInOtherRunLoopWithResponseObject:nil error:error group:group];
            }];
        }
            break;
    }
    
    
}


- (void)cancel
{
    [RXNetworkingConfigManager cancelHttpSessionManager:self.httpSessionManager];
}



#pragma mark - Private

- (void)analysisInOtherRunLoopWithResponseObject:(id)responseObject error:(NSError *)error group:(dispatch_group_t)group
{
    [RXNetworkingConfigManager analysisInOtherRunLoopWithRequest:self responseObject:responseObject error:error group:group completion:nil];
}






- (void)dealloc
{
    // 可以正常释放
    RXAFnetworkingDebugLog(@"base request dealloc");
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
- (NSDictionary *)suffixParameters
{
    return [RXNetworkingConfigManager sharedInstance].suffixParameters;
}
- (NSDictionary *)reallyParameters
{
    NSDictionary *dic1 = self.requestParameters;
    NSDictionary *dic2 = self.suffixParameters;
    NSMutableDictionary *result = nil;
    if (dic1) {
        result = [NSMutableDictionary dictionaryWithDictionary:dic1];
    } else {
        result = [NSMutableDictionary dictionary];
    }
    if (dic2 != nil) {
        [result setValuesForKeysWithDictionary:dic2];
    }
    return result;
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
