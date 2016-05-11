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
    return kE_RX_ResponseType_Unknow;
    
    
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
        return self;
    } else {
        if (self = [self initWithString:responseObject]) {
            
        }
        return self;
    }
}


- (id)initWithString:(NSString *)str
{
    RXNetworkingConfigManager *cm = [RXNetworkingConfigManager sharedInstance];
    if (str.length == 0) {
        if (self = [self init]) {
            self.resultCode = cm.serverNoDataCode;
            self.resultMsg = cm.serverNoDataMsg;
        }
        return self;
    }
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
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
                cm.customServerResultAction(self.resultCode);
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
#warning can distinguish timeout or error
    RXAFnetworkingLog(@"error:%@", error);
    response.resultCode = cm.networkErrorCode;
    response.resultMsg = cm.networkErrorMsg;
    return response;
}

@end
