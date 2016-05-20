//
//  RXBaseRequest.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>



@class RXBaseResponse;
@class RXBaseRequest;

typedef NS_ENUM(NSInteger, E_RXRequestMethod) {
    kE_RXRequestMethod_Get,
    kE_RXRequestMethod_Post,
};




typedef void(^RXRequestCompletionBlock)(RXBaseRequest *request);


@interface RXBaseRequest : NSObject

#pragma mark - Block
@property (nonatomic, copy) RXRequestCompletionBlock completion;

#pragma mark - Property
@property (nonatomic, readonly) AFHTTPSessionManager *httpSessionManager;



#pragma mark - Need To Override
// default 0
@property (nonatomic, readonly) NSInteger tag;
// default RXNetworkingConfigManager timeoutInterval
@property (nonatomic, readonly) NSTimeInterval timeoutInterval;
// default RXNetworkingConfigManager baseUrlString
@property (nonatomic, readonly) NSString *baseUrlString;
// default @""
@property (nonatomic, readonly) NSString *requestUrlString;
// default kE_RXRequestMethod_Post
@property (nonatomic, readonly) E_RXRequestMethod e_RXRequestMethod;
// default [NSDictionary dictionary]
@property (nonatomic, readonly) NSDictionary *requestParameters;


@property (nonatomic, strong) RXBaseResponse *response;


#pragma mark - Upload
@property (nonatomic, readonly) void (^constructingBodyBlock)(id<AFMultipartFormData> formData);
@property (nonatomic, copy) void (^uploadProgress)(NSProgress *progress);


#pragma mark - Public

- (void)startWithCompletion:(RXRequestCompletionBlock)completion;
- (void)start;


- (void)startWithCompletion:(RXRequestCompletionBlock)completion group:(dispatch_group_t)group queue:(dispatch_queue_t)queue;

@end
