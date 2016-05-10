//
//  RXNetworkingConfigManager.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXNetworkingConfigManager.h"

@implementation RXNetworkingConfigManager



- (NSTimeInterval)timeoutInterval
{
    if (_timeoutInterval == 0) {
        _timeoutInterval = 45;
    }
    return _timeoutInterval;
}



































+ (RXNetworkingConfigManager *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
@end
