//
//  RXBaseResponse.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/11.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RXBaseResponse : NSObject


@property (nonatomic, readonly) BOOL success;

@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, copy) NSString *resultMsg;




@end
