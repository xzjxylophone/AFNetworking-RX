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
#import "RXBaseResponse.h"
#import "RXAFNetworkingDefine.h"
#import "RXSimpleHttpManager.h"
#import "RXNetworkingRecordManager.h"


// 调试信息
#define k_RX_RunloopDebug       0

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
        self.suffixParameters = [NSDictionary dictionary];
        
        
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
        
#if DEBUG
        self.isNetworkLogEnable = YES;
#else
        self.isNetworkLogEnable = NO;
#endif
        
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


+ (void)cancelHttpSessionManager:(AFHTTPSessionManager *)httpSessionManager
{
    for (NSURLSessionTask *task in httpSessionManager.tasks) {
        [task cancel];
    }
}




#pragma mark -

+ (void)networkResponseAnalysisThreadEntryPoint
{
    @autoreleasepool {
        [[NSThread currentThread] setName:@"AFNetworking+RX"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}


+ (NSThread *)networkResponseAnalysisThread
{
    static NSThread *_thread = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(networkResponseAnalysisThreadEntryPoint) object:nil];
        [_thread start];
    });
    return _thread;
}



#pragma mark - Private
+ (void)performInOtherRunLoopWithDictionary:(NSDictionary *)dic
{
    @autoreleasepool {
        RXBaseRequest *request = nil;
        RXSimpleHttpManager *http = nil;
        id responseObject = nil;
        NSError *error = nil;
        dispatch_group_t group = NULL;
        void (^completion)(RXBaseResponse *response) = nil;
        
        id idRequest = dic[@"request"];
        if ([idRequest isKindOfClass:[RXBaseRequest class]]) {
            request = idRequest;
        } else {
            http = idRequest;
        }
        id idResponseObject = dic[@"responseObject"];
        if (![idResponseObject isKindOfClass:[NSNull class]]) {
            responseObject = idResponseObject;
        }
        id idError = dic[@"error"];
        if (![idError isKindOfClass:[NSNull class]]) {
            error = idError;
        }
        id idGroup = dic[@"group"];
        if (![idGroup isKindOfClass:[NSNull class]]) {
            group = idGroup;
        }
        
        id idCompletion = dic[@"completion"];
        if (![idCompletion isKindOfClass:[NSNull class]]) {
            completion = (void (^)(RXBaseResponse *response))idCompletion;
        }
        [self printMainAndCurrentRunLoopInfoWithDes:@"performInOtherRunLoopWithDictionary"];
        
        if (request) {
            request.response = [RXBaseResponse responseWithResponseObject:responseObject error:error];
            request.response.baseUrlString = request.baseUrlString;
            request.response.requestUrlString = request.requestUrlString;
            request.response.parameters = request.reallyParameters;
            [[RXNetworkingRecordManager sharedInstance] addRecordWithRXData:request.response];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (request.completion != nil) {
                    [self printMainAndCurrentRunLoopInfoWithDes:@"dispatch_async"];
                    request.completion(request);
                    request.completion = nil;
                }
                if (group) {
                    dispatch_group_leave(group);
                }
                [[RXNetworkingConfigManager sharedInstance] removeRequest:request];
            });
        } else if (completion) {
            RXBaseResponse *response = [RXBaseResponse responseWithResponseObject:responseObject error:error];
            response.baseUrlString = [NSString stringWithFormat:@"%@", http.httpSessionManager.baseURL];
            response.requestUrlString = http.url;
            response.parameters = http.parameters;
            [[RXNetworkingRecordManager sharedInstance] addRecordWithRXData:response];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self printMainAndCurrentRunLoopInfoWithDes:@"dispatch_async"];
                completion(response);
            });
        } else {
            // Do Nothing
        }
    }
}

+ (void)analysisInOtherRunLoopWithRequestOrManager:(id)data responseObject:(id)responseObject error:(NSError *)error group:(dispatch_group_t)group completion:(void (^)(RXBaseResponse *response))completion
{
    
    NSThread *thread = [self networkResponseAnalysisThread];
    NSDictionary *dic = @{@"request":data,
                          @"responseObject":responseObject ? responseObject : [NSNull null],
                          @"error":error ? error : [NSNull null],
                          @"group":group ? group : [NSNull null]};
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (completion) {
        [mutDic setValue:completion forKey:@"completion"];
    } else {
        [mutDic setValue:[NSNull null] forKey:@"completion"];

    }
    [self printMainAndCurrentRunLoopInfoWithDes:@"safeBlock_completion"];
    

    // TODD: 内存泄漏或者什么其他的问题？
    
    // 方法1:
//    [self performInOtherRunLoopWithDictionary:mutDic];
    
    // 放到其他的RunLoop中去
    // 方法2:
    [self performSelector:@selector(performInOtherRunLoopWithDictionary:) onThread:thread withObject:mutDic waitUntilDone:YES modes:@[NSDefaultRunLoopMode]];
}

+ (void)printMainAndCurrentRunLoopInfoWithDes:(NSString *)des
{
    
#if k_RX_RunloopDebug
    CFRunLoopRef mainRunLoopRef = CFRunLoopGetMain();
    CFStringRef mainStringRef = CFRunLoopCopyCurrentMode(mainRunLoopRef);
    CFRunLoopRef curRunLoopRef = CFRunLoopGetCurrent();
    CFStringRef curStringRef = CFRunLoopCopyCurrentMode(curRunLoopRef);
    NSLog(@"%@ main:%p:%@ cur:%p:%@", des, mainRunLoopRef, (__bridge NSString *)mainStringRef, curRunLoopRef, (__bridge NSString *)curStringRef);
#endif
    
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
