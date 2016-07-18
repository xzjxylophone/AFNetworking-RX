//
//  RXNetworkingRecordManager.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/7/15.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXNetworkingRecordManager.h"
#import "RXSimpleHttpManager.h"
#import "RXBaseRequest.h"
#import "RXBaseResponse.h"
#import "RXAFNetworkingDefine.h"
#import "RXNetworkingConfigManager.h"

@interface RXNetworkingRecordManager ()

@property (nonatomic, strong) NSMutableArray *recordArray;

@end

@implementation RXNetworkingRecordManager


- (void)addRecordWithRXData:(id)data
{
    
    
    if (![RXNetworkingConfigManager sharedInstance].isNetworkLogEnable) {
        return;
    }
    

    
    NSString *string = @"";
    if ([data isKindOfClass:[RXSimpleHttpManager class]]) {
        RXSimpleHttpManager *tmp = data;
        string = [NSString stringWithFormat:@"request:%@/%@, parameters:%@", tmp.httpSessionManager.baseURL, tmp.url, tmp.parameters];
    } else if ([data isKindOfClass:[RXBaseRequest class]]) {
        RXBaseRequest *tmp = data;
        string = [NSString stringWithFormat:@"request:%@/%@, parameters:%@", tmp.baseUrlString, tmp.requestUrlString, tmp.reallyParameters];
    } else if ([data isKindOfClass:[RXBaseResponse class]]) {
        RXBaseResponse *tmp = data;
        
        NSString *resultString = @"";
        if (tmp.resultDictionary != nil) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tmp.resultDictionary options:NSJSONWritingPrettyPrinted error:nil];
            resultString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        
        string = [NSString stringWithFormat:@"response:%@/%@, parameters:%@, resultDic:%@, error:%@", tmp.baseUrlString, tmp.requestUrlString, tmp.parameters, resultString, tmp.error];
    } else {
        return;
    }
    
    [self.recordArray addObject:string];
    
    
    
    
    
    
    

    
    
    
    
    
    
}

- (id)init
{
    if (self = [super init]) {
        self.recordArray = [NSMutableArray array];
    }
    return self;
}



+ (RXNetworkingRecordManager *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
@end
