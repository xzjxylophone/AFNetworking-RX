//
//  RTExhibitionListRequest.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXBaseRequest.h"

@interface RTExhibitionListRequest : RXBaseRequest
- (id)initWithOffset:(NSInteger)offset num:(NSInteger)num;

@end
