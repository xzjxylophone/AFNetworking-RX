//
//  RXNetworkingConfigManager.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXNetworkingConfigManager.h"

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
    }
    return self;
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
