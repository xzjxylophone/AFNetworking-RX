//
//  RXRequestConfigManager.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RXRequestConfigManager : NSObject


@property (nonatomic, copy) NSString *baseUrlString;








+ (RXRequestConfigManager *)sharedInstance;
@end
