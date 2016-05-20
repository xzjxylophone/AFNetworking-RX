//
//  RTUploadPicRequest.h
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/20.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RXBaseRequest.h"

@interface RTUploadPicRequest : RXBaseRequest

- (id)initWithSessionId:(NSString *)sessionId type:(NSInteger)type image:(UIImage *)image;


@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIImage *image;


@end
