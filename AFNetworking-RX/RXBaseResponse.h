//
//  RXBaseResponse.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/11.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, E_RX_ResponseType) {
    
    kE_RX_ResponseType_ClientParametersError               =           -1, // 客户端传入的参数有问题,例如,密码错误,账号不存在等等
    kE_RX_ResponseType_Success              =           0,
    kE_RX_ResponseType_NetworkError,
    kE_RX_ResponseType_NetworkTimeout,
    
    kE_RX_ResponseType_ServerInvalidJson,
    kE_RX_ResponseType_ServerNoData,
    kE_RX_ResponseType_ServerInvalidFormat,
    
};







@interface RXBaseResponse : NSObject

@property (nonatomic, copy) NSString *baseUrlString;
@property (nonatomic, copy) NSString *requestUrlString;
@property (nonatomic, strong) NSDictionary *parameters;




@property (nonatomic, readonly) E_RX_ResponseType responseType;
@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, copy) NSString *resultMsg;


@property (nonatomic, readonly) NSError *customError;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSDictionary *resultDictionary;


@property (nonatomic, strong) id responseObject;


- (id)initWithResponseObject:(id)responseObject;

+ (id)networkErrorResponseWithError:(NSError *)error;


+ (id)responseWithResponseObject:(id)responseObject error:(NSError *)error;


@end
