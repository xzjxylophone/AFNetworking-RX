//
//  RXBatchRequestObject.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/11.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXBatchRequestObject.h"
#import "RXBaseRequest.h"
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


- (void)startWithCompletion:(void (^)(RXBatchRequestObject *batchRequest))completion
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.001", DISPATCH_QUEUE_CONCURRENT);
    for (RXBaseRequest *request in self.requestArray) {
        [request startWithCompletion:nil group:group queue:queue];
    }
    __strong __typeof(self) strongSelf = self;
    dispatch_group_notify(group, queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(strongSelf);
            }
        });
    });
    
}












@end
