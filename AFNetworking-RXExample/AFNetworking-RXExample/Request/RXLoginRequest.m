//
//  RXLoginRequest.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXLoginRequest.h"

@interface RXLoginRequest ()

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *pwd;

@end

@implementation RXLoginRequest

- (NSString *)requestUrlString
{
    return @"v1/user/login";
}

- (NSDictionary *)requestParameters
{
    return @{@"account":self.account,
             @"password":[self.pwd rx_transform_MD5],
             @"pushtoken":@""};
}


- (id)initWithAccount:(NSString *)account pwd:(NSString *)pwd
{
    if (self = [super init]) {
        self.account = account;
        self.pwd = pwd;
    }
    return self;
}

@end
