//
//  RXSimpleHttpManager.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/20.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
@class RXBaseResponse;

@interface RXSimpleHttpManager : NSObject

@property (nonatomic, readonly) AFHTTPSessionManager *httpSessionManager;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSDictionary *parameters;



+ (id)exhibitionListWithOffset:(NSInteger)offset num:(NSInteger)num completion:(void (^)(RXBaseResponse *response))completion;
+ (id)uploadWithSessionId:(NSString *)sessionId type:(NSInteger)type image:(UIImage *)image constructingBodyBlock:(void (^)(id<AFMultipartFormData> formData))constructingBodyBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(RXBaseResponse *response))completion;





#pragma mark - Class Method
+ (id)getActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion;
+ (id)postActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion;
+ (id)postActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters image:(UIImage *)image constructingBodyBlock:(void (^)(id<AFMultipartFormData> formData))constructingBodyBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(RXBaseResponse *response))completion;

+ (id)getActionWithBaseUrl:(NSString *)baseUrl url:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion;
+ (id)postActionWithBaseUrl:(NSString *)baseUrl url:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion;
+ (id)postActionWithBaseUrl:(NSString *)baseUrl url:(NSString *)url parameters:(NSDictionary *)parameters image:(UIImage *)image constructingBodyBlock:(void (^)(id<AFMultipartFormData> formData))constructingBodyBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(RXBaseResponse *response))completion;
+ (id)postActionWithBaseUrl:(NSString *)baseUrl url:(NSString *)url parameters:(NSDictionary *)parameters image:(UIImage *)image useExtraParameters:(BOOL)useExtraParameters constructingBodyBlock:(void (^)(id<AFMultipartFormData> formData))constructingBodyBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(RXBaseResponse *response))completion;




- (void)cancel;


@end
