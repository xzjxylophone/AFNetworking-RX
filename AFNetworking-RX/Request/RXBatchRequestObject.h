//
//  RXBatchRequestObject.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/11.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RXBatchRequestObject : NSObject




@property (nonatomic, readonly) NSArray *requestArray;






- (id)initWithRequestArray:(NSArray *)requestArray;

- (void)startWithCompletion:(void (^)(RXBatchRequestObject *batchRequest))completion;









@end
