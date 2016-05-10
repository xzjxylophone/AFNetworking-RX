//
//  RXAFNetworkingGlobal.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXAFNetworkingGlobal.h"

@implementation RXAFNetworkingGlobal
void RXAFnetworkingLog(NSString *format, ...)
{
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}



@end
