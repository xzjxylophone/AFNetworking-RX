//
//  RTSimpleHttpManager.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/20.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXSimpleHttpManager.h"

@interface RTSimpleHttpManager : RXSimpleHttpManager


+ (id)postExhibitionListWithOffset:(NSInteger)offset num:(NSInteger)num completion:(void (^)(RXBaseResponse *response))completion;


@end
