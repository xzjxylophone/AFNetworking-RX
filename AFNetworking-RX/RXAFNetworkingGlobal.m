//
//  RXAFNetworkingGlobal.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXAFNetworkingGlobal.h"

#import "RXAFNetworkingDefine.h"
void RXAFnetworkingDebugLog(NSString *format, ...)
{
    
#ifdef DEBUG
#if k_RX_SwitchLog_Debug
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
#endif
}

void RXAFnetworkingPrintUrlAndParameters(NSString *format, ...)
{
    
#ifdef DEBUG
#if k_RX_SwitchLog_URL_Parameter
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
#endif
}

FOUNDATION_EXPORT void RXAFnetworkingPrintErrorInfo(NSString *format, ...) NS_FORMAT_FUNCTION(1,2)
{
#ifdef DEBUG
#if k_RX_SwitchLog_Error_Print
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
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
