//
//  RXBatchRequestObject.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/11.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXBatchRequestObject.h"
#import "RXBaseRequest.h"
#import "RXNetworkingConfigManager.h"
#import "RXAFNetworkingGlobal.h"

@interface RXBatchRequestObject ()
@property (nonatomic, strong) NSArray *requestArray;

@end

@implementation RXBatchRequestObject








- (id)initWithRequestArray:(NSArray *)requestArray
{
    if (self = [self init]) {
        self.requestArray = requestArray;
    }
    return self;
}
- (void)dealloc
{
    RXAFnetworkingDebugLog(@"batch request object dealloc");
}

- (void)startWithCompletion:(void (^)(RXBatchRequestObject *batchRequest))completion
{
    [[RXNetworkingConfigManager sharedInstance] addBatchRequest:self];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.001", DISPATCH_QUEUE_CONCURRENT);
    for (RXBaseRequest *request in self.requestArray) {
        [request startWithCompletion:nil group:group queue:queue];
    }
    __weak __typeof(self) weakSelf = self;
    dispatch_group_notify(group, queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(weakSelf);
            }
            [[RXNetworkingConfigManager sharedInstance] removeBatchRequest:weakSelf];
        });
    });
    
}












@end
