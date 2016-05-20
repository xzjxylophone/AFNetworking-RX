//
//  RXAFNetworkingGlobal.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>
FOUNDATION_EXPORT void RXAFnetworkingLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);



@interface RXAFNetworkingGlobal : NSObject
+ (NSString *)parametersFromDictionary:(NSDictionary *)dic;

@end
