//
//  RXBaseRequest.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXBaseRequest.h"
#import "RXRequestConfigManager.h"
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
    return [RXRequestConfigManager sharedInstance].baseUrlString;
}
- (NSString *)requestUrlString
{
    return @"";
}
- (E_RXRequestMethod)e_RXRequestMethod
{
    return kE_RXRequestMethod_Post;
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
    switch (self.e_RXRequestMethod) {
        case kE_RXRequestMethod_Get:
        {
            
        }
            break;
        case kE_RXRequestMethod_Post:
        default:
        {
            [self.httpSessionManager POST:self.requestUrlString parameters:nil progress:^(NSProgress * progress) {
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [strongSelf safeBlock_completion:strongSelf responseObject:responseObject error:nil];
            } failure:^(NSURLSessionDataTask *task, NSError * error) {
                [strongSelf safeBlock_completion:strongSelf responseObject:nil error:error];
            }];
        }
            break;
    }
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
