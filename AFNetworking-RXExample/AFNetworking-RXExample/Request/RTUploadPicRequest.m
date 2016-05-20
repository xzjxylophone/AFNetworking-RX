//
//  RTUploadPicRequest.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/20.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "RTUploadPicRequest.h"

@implementation RTUploadPicRequest

- (id)initWithSessionId:(NSString *)sessionId type:(NSInteger)type image:(UIImage *)image
{
    if (self = [self init]) {
        self.sessionId = sessionId;
        self.type = type;
        self.image = image;
    }
    return self;
}

- (NSString *)requestUrlString
{
    // 测试404
//    return @"v1/uploadpic1";
    return @"v1/uploadpic";
}

- (NSDictionary *)requestParameters
{
    return @{@"SESSIONID":self.sessionId,
             @"type":@(self.type)};
}
// 测试超时
//- (NSTimeInterval)timeoutInterval
//{
//    return 0.01;
//}

- (void (^)(id<AFMultipartFormData> formData))constructingBodyBlock
{
    __weak __typeof(self) weakSelf = self;
    return ^(id<AFMultipartFormData> formData) {
        UIImage *image = weakSelf.image;
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        // 以文件流格式上传图片
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpeg"];
    };
}
@end
