//
//  RXNetworkingConfigManager.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, E_RX_NetworkExceptionType) {
    kE_RX_NetworkExceptionType_NetworkError         =           400400,
    kE_RX_NetworkExceptionType_NetworkTimeout       =           400401,
    
    kE_RX_NetworkExceptionType_ServerInvalidJSON    =           400500,
    kE_RX_NetworkExceptionType_ServerNoData         =           400501,
    kE_RX_NetworkExceptionType_ServerInvalidFormat    =           400502,
    
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



// 正确的返回值, default 0
@property (nonatomic, assign) NSInteger successResultCode;


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






+ (RXNetworkingConfigManager *)sharedInstance;
@end
