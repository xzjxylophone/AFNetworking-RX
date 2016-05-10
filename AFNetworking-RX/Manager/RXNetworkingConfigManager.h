//
//  RXNetworkingConfigManager.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RXNetworkingConfigManager : NSObject


@property (nonatomic, copy) NSString *baseUrlString;
// default 45
@property (nonatomic, assign) NSTimeInterval timeoutInterval;








+ (RXNetworkingConfigManager *)sharedInstance;
@end
