//
//  RXAFNetworkingGlobal.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXAFNetworkingGlobal.h"
void RXAFnetworkingLog(NSString *format, ...)
{
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}


@implementation RXAFNetworkingGlobal



+ (NSString *)parametersFromDictionary:(NSDictionary *)dic
{
    NSMutableArray *ary = [NSMutableArray array];
    for (NSString *key in dic.allKeys) {
        NSString *value = [dic objectForKey:key];
        [ary addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    NSString *result = [ary componentsJoinedByString:@"&"];
    return result;
}




@end
