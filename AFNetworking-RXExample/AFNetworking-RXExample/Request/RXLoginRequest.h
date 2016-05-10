//
//  RXLoginRequest.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXBaseRequest.h"

@interface RXLoginRequest : RXBaseRequest
- (id)initWithAccount:(NSString *)account pwd:(NSString *)pwd;

@end
