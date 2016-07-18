//
//  RXBaseResponse.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/11.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXBaseResponse.h"
#import "RXNetworkingConfigManager.h"
#import "RXAFNetworkingGlobal.h"

@implementation RXBaseResponse

- (E_RX_ResponseType)responseType
{

    RXNetworkingConfigManager *cm = [RXNetworkingConfigManager sharedInstance];

    if (self.resultCode == cm.successResultCode) {
        return kE_RX_ResponseType_Success;
    }
    
    if (self.resultCode == cm.networkErrorCode) {
        return kE_RX_ResponseType_NetworkError;
    }
    
    if (self.resultCode == cm.networkTimeoutCode) {
        return kE_RX_ResponseType_NetworkTimeout;
    }
    
    if (self.resultCode == cm.serverInvalidJSONCode) {
        return kE_RX_ResponseType_ServerInvalidJson;
    }
    
    if (self.resultCode == cm.serverNoDataCode) {
        return kE_RX_ResponseType_ServerNoData;
    }
    
    if (self.resultCode == cm.serverInvalidFormatCode) {
        return kE_RX_ResponseType_ServerInvalidFormat;
    }
    return kE_RX_ResponseType_ClientParametersError;
    
    
}


- (id)init
{
    if (self = [super init]) {
        self.error = nil;
        self.resultDictionary = nil;
    }
    return self;
}


- (id)initWithResponseObject:(id)responseObject
{
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if (self = [self initWithDictionary:responseObject]) {
            
        }
    } else if ([responseObject isKindOfClass:[NSData class]]) {
        if (self = [self initWithData:responseObject]) {
            
        }
    } else {
        if (self = [self initWithString:responseObject]) {
            
        }
    }
    self.responseObject = responseObject;
    return self;
}


- (id)initWithString:(NSString *)str
{
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    if (self = [self initWithData:jsonData]) {
    }
    return self;
}

- (id)initWithData:(NSData *)data
{
    RXNetworkingConfigManager *cm = [RXNetworkingConfigManager sharedInstance];
    if (data.length == 0) {
        if (self = [self init]) {
            self.resultCode = cm.serverNoDataCode;
            self.resultMsg = cm.serverNoDataMsg;
        }
        return self;
    }
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (dic == nil) {
        if (self = [self init]) {
            self.resultCode = cm.serverInvalidJSONCode;
            self.resultMsg = cm.serverInvalidJSONMsg;
        }
        return self;
    } else {
        if (self = [self initWithDictionary:dic]) {
        }
        return self;
    }
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [self init]) {
        RXNetworkingConfigManager *cm = [RXNetworkingConfigManager sharedInstance];
        NSString *codeKey = cm.resultCodeKey;
        NSString *msgKey = cm.resultMsgKey;
        self.resultDictionary = dic;
        id code = dic[codeKey];
        id msg = dic[msgKey];
        
        if (code == nil) {
            self.resultCode = cm.serverInvalidFormatCode;
            self.resultMsg = cm.serverInvalidFormatMsg;
        } else {
            self.resultCode = [code integerValue];
            self.resultMsg = (NSString *)msg;
            
            if (cm.customServerResultAction != nil) {
                NSInteger code = self.resultCode;
                // 很重要一定要放在主线程去执行相关的操作
                dispatch_async(dispatch_get_main_queue(), ^{
                    cm.customServerResultAction(code);
                });
            }
            
            
            
            
            
            
        }
    }
    return self;
}

+ (id)networkErrorResponseWithError:(NSError *)error
{
    RXNetworkingConfigManager *cm = [RXNetworkingConfigManager sharedInstance];

    RXBaseResponse *response = [[RXBaseResponse alloc] init];
    response.error = error;
    switch (error.code) {
        case -1001: // 网络超时
        {
            response.resultCode = cm.networkTimeoutCode;
            response.resultMsg = cm.networkTimeoutMsg;
        }
            break;
        default:
        {
            // 404  对应的code是 -1011
            response.resultCode = cm.networkErrorCode;
            response.resultMsg = cm.networkErrorMsg;
        }
            break;
    }
    return response;
}


+ (id)responseWithResponseObject:(id)responseObject error:(NSError *)error
{
    RXBaseResponse *response = nil;
    if (error != nil) {
        RXAFnetworkingPrintErrorInfo(@"%@", error);
        response = [RXBaseResponse networkErrorResponseWithError:error];
    } else {
        response = [[RXBaseResponse alloc] initWithResponseObject:responseObject];
    }
    return response;
}

@end
