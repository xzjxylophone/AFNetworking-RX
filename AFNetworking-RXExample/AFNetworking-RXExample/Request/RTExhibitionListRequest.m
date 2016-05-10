//
//  RTExhibitionListRequest.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RTExhibitionListRequest.h"

@interface RTExhibitionListRequest ()

@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger offset;

@end

@implementation RTExhibitionListRequest

- (E_RXRequestMethod)e_RXRequestMethod
{
    return kE_RXRequestMethod_Get;
}

- (NSString *)requestUrlString
{
    return @"v1/zhanhui";
}
- (id)initWithOffset:(NSInteger)offset num:(NSInteger)num
{
    if (self = [super init]) {
        self.num = num;
        self.offset = offset;
    }
    return self;
}

- (NSDictionary *)requestParameters
{
    return @{@"num":@(self.num),
             @"offset":@(self.offset)};
}


@end
