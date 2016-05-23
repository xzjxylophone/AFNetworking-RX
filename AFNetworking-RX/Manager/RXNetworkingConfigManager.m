//
//  RXNetworkingConfigManager.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXNetworkingConfigManager.h"
#import "RXBaseRequest.h"
#import "RXAFNetworkingGlobal.h"
@interface RXNetworkingConfigManager ()

@property (nonatomic, strong) NSMutableArray *requestArray;
@property (nonatomic, strong) NSMutableArray *batchRequestArray;

@end

@implementation RXNetworkingConfigManager





- (id)init
{
    if (self = [super init]) {
        self.timeoutInterval = 45;
        self.resultMsgKey = @"msg";
        self.resultCodeKey = @"code";
        self.successResultCode = 0;
        
        
        self.networkErrorMsg = @"网络错误";
        self.networkErrorCode = kE_RX_NetworkExceptionType_NetworkError;
        
        self.networkTimeoutMsg = @"网络超时";
        self.networkTimeoutCode = kE_RX_NetworkExceptionType_NetworkTimeout;
        
        self.serverInvalidJSONMsg = @"服务端返回不是一个有效的JSON格式";
        self.serverInvalidJSONCode = kE_RX_NetworkExceptionType_ServerInvalidJSON;
        
        self.serverNoDataMsg = @"服务端返回空数据";
        self.serverNoDataCode = kE_RX_NetworkExceptionType_ServerNoData;
        
        self.serverInvalidFormatMsg = @"服务端返回的格式错误,主要是code/msg";
        self.serverInvalidFormatCode = kE_RX_NetworkExceptionType_ServerInvalidFormat;
        
        self.customServerResultAction = nil;
        
        self.requestArray = [NSMutableArray array];
        self.batchRequestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addRequest:(RXBaseRequest *)request
{
    [self.requestArray addObject:request];
}
- (void)removeRequest:(RXBaseRequest *)request
{
    [self.requestArray removeObject:request];
}




- (void)addBatchRequest:(RXBatchRequestObject *)batchRequest
{
    [self.batchRequestArray addObject:batchRequest];
}
- (void)removeBatchRequest:(RXBatchRequestObject *)batchRequest
{
    [self.batchRequestArray removeObject:batchRequest];
}











- (void)configPostHttpSessionManager:(AFHTTPSessionManager *)httpSessionManager timeoutInterval:(NSTimeInterval)timeoutInterval
{
    
    if (self.customConfigPostHttpSessionManager) {
        self.customConfigPostHttpSessionManager(httpSessionManager, timeoutInterval);
    } else {
        AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
        requestSerializer.timeoutInterval = timeoutInterval;
        httpSessionManager.requestSerializer = requestSerializer;
        
        AFHTTPResponseSerializer *responseSerializer = [[AFHTTPResponseSerializer alloc] init];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
        httpSessionManager.responseSerializer = responseSerializer;
    }
}

- (void)configGetHttpSessionManager:(AFHTTPSessionManager *)httpSessionManager timeoutInterval:(NSTimeInterval)timeoutInterval parameters:(NSDictionary *)parameters
{
    if (self.customConfigGetHttpSessionManager) {
        self.customConfigGetHttpSessionManager(httpSessionManager, timeoutInterval, parameters);
    } else {
        AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
        requestSerializer.timeoutInterval = timeoutInterval;
        [requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError **error) {
            // 注意此处的参数: parameters 跟 函数的parameters是不一样的,也许值是一样的
            return [RXAFNetworkingGlobal parametersFromDictionary:parameters];
        }];
        
        AFHTTPResponseSerializer *responseSerializer = [[AFHTTPResponseSerializer alloc] init];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
        httpSessionManager.requestSerializer = requestSerializer;
        httpSessionManager.responseSerializer = responseSerializer;
    }
    
    
    
    
}






+ (RXNetworkingConfigManager *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
@end
