//
//  RXNetworkingRecordManager.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/7/15.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RXNetworkingRecordManager : NSObject

@property (nonatomic, readonly) NSMutableArray *recordArray;


- (void)addRecordWithRXData:(id)data;



+ (RXNetworkingRecordManager *)sharedInstance;

@end
