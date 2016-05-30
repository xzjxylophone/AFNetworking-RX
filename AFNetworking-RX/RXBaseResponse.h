//
//  RXBaseResponse.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/11.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, E_RX_ResponseType) {
    
    kE_RX_ResponseType_Unknow               =           -1,
    kE_RX_ResponseType_Success              =           0,
    kE_RX_ResponseType_NetworkError,
    kE_RX_ResponseType_NetworkTimeout,
    
    kE_RX_ResponseType_ServerInvalidJson,
    kE_RX_ResponseType_ServerNoData,
    kE_RX_ResponseType_ServerInvalidFormat,
    
};







@interface RXBaseResponse : NSObject


@property (nonatomic, readonly) E_RX_ResponseType responseType;
@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, copy) NSString *resultMsg;


@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSDictionary *resultDictionary;


- (id)initWithResponseObject:(id)responseObject;

+ (id)networkErrorResponseWithError:(NSError *)error;


+ (id)responseWithResponseObject:(id)responseObject error:(NSError *)error;


@end
