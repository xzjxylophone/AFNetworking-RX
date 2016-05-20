//
//  RTSimpleHttpManager.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/20.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RTSimpleHttpManager.h"

@implementation RTSimpleHttpManager

+ (id)postExhibitionListWithOffset:(NSInteger)offset num:(NSInteger)num completion:(void (^)(RXBaseResponse *response))completion
{
    NSString *url = @"v1/zhanhui";
    NSDictionary *dic = @{@"num":@(num),
                          @"offset":@(offset)};
    id http = [self postActionWithUrl:url parameters:dic completion:completion];
    return http;
}


@end
