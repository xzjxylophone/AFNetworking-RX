//
//  RXSimpleHttpManager.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/20.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@class RXBaseResponse;

@interface RXSimpleHttpManager : NSObject

@property (nonatomic, readonly) AFHTTPSessionManager *httpSessionManager;



+ (id)exhibitionListWithOffset:(NSInteger)offset num:(NSInteger)num completion:(void (^)(RXBaseResponse *response))completion;
+ (id)uploadkkkk;


+ (id)getActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(RXBaseResponse *response))completion;
+ (id)postActionWithUrl:(NSString *)url parameters:(NSDictionary *)parameters  completion:(void (^)(RXBaseResponse *response))completion;





@end
