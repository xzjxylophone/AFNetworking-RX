//
//  RXNetworkingConfigManager.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
@class RXBaseRequest;
@class RXBatchRequestObject;
@class RXBaseResponse;

typedef NS_ENUM(NSInteger, E_RX_NetworkExceptionType) {
    kE_RX_NetworkExceptionType_NetworkError         =           400400,
    kE_RX_NetworkExceptionType_NetworkTimeout       =           400401,
    
    kE_RX_NetworkExceptionType_ServerInvalidJSON    =           400500,
    kE_RX_NetworkExceptionType_ServerNoData         =           400501,
    kE_RX_NetworkExceptionType_ServerInvalidFormat  =           400502,
    
};


@interface RXNetworkingConfigManager : NSObject

// 基础的URL
@property (nonatomic, copy) NSString *baseUrlString;
// default 45
@property (nonatomic, assign) NSTimeInterval timeoutInterval;



// resultCodeKey default @"code"
@property (nonatomic, copy) NSString *resultCodeKey;
// resultMsgKey  default @"msg"
@property (nonatomic, copy) NSString *resultMsgKey;

// defautl [NSDictionary dictionary]
@property (nonatomic, strong) NSDictionary *suffixParameters;



// 正确的返回值, default 0
@property (nonatomic, assign) NSInteger successResultCode;

// 是否开启网络log日志,默认在Debug模式是开启,在Release是关闭的,可以控制
@property (nonatomic, assign) BOOL isNetworkLogEnable;


// 当网络错误
@property (nonatomic, copy) NSString *networkErrorMsg;
@property (nonatomic, assign) NSInteger networkErrorCode;

// 当网络超时
@property (nonatomic, copy) NSString *networkTimeoutMsg;
@property (nonatomic, assign) NSInteger networkTimeoutCode;

// 当服务端返回不是一个有效的JSON字符串
@property (nonatomic, copy) NSString *serverInvalidJSONMsg;
@property (nonatomic, assign) NSInteger serverInvalidJSONCode;

// 当服务端返回空数据
@property (nonatomic, copy) NSString *serverNoDataMsg;
@property (nonatomic, assign) NSInteger serverNoDataCode;

// 当服务端返回格式错误
@property (nonatomic, copy) NSString *serverInvalidFormatMsg;
@property (nonatomic, assign) NSInteger serverInvalidFormatCode;


// 执行无效的用户token的时候的操作
@property (nonatomic, copy) void (^customServerResultAction)(NSInteger);

// 自定义的配置post http
@property (nonatomic, copy) void (^customConfigPostHttpSessionManager)(AFHTTPSessionManager *httpSessionManager, NSTimeInterval timeoutIntervale);
// 自定义配置get http
@property (nonatomic, copy) void (^customConfigGetHttpSessionManager)(AFHTTPSessionManager *httpSessionManager, NSTimeInterval timeoutIntervale, NSDictionary *parameters);


// 自定义配置的解析返回通用公共集合
@property (nonatomic, copy) void (^customAnalysisCodeAndMsg)(NSInteger *code, NSString **msg, NSDictionary *dic);







@property (nonatomic, readonly) NSMutableArray *requestArray;
@property (nonatomic, readonly) NSMutableArray *batchRequestArray;

- (void)addRequest:(RXBaseRequest *)request;
- (void)removeRequest:(RXBaseRequest *)request;


- (void)addBatchRequest:(RXBatchRequestObject *)batchRequest;
- (void)removeBatchRequest:(RXBatchRequestObject *)batchRequest;

- (void)configPostHttpSessionManager:(AFHTTPSessionManager *)httpSessionManager timeoutInterval:(NSTimeInterval)timeoutInterval;
- (void)configGetHttpSessionManager:(AFHTTPSessionManager *)httpSessionManager timeoutInterval:(NSTimeInterval)timeoutInterval parameters:(NSDictionary *)parameters;

+ (void)cancelHttpSessionManager:(AFHTTPSessionManager *)httpSessionManager;

+ (void)analysisInOtherRunLoopWithRequestOrManager:(id)data responseObject:(id)responseObject error:(NSError *)error group:(dispatch_group_t)group completion:(void (^)(RXBaseResponse *response))completion;


+ (RXNetworkingConfigManager *)sharedInstance;
@end
