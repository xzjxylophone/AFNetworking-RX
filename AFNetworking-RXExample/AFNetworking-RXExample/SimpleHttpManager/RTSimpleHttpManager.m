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





+ (id)sendVerifyCodeWithMobile:(NSString *)mobile completion:(void (^)(RXBaseResponse *response))completion
{
    NSString *hostUrl = @"v2/9/sendVerifyCode.do";
    NSString *sourceString = [NSString stringWithFormat:@"%@=%@", @"mobile", mobile];
    NSString *sign = [sourceString rx_transform_AES128EncryptWithKey:@"yiyizuche2015"];
    NSString *signEncode = [sign rx_transform_URLEncode];
    NSDictionary *dic = @{@"mobile":mobile,
                          @"sign":signEncode};
    
    
    return [self postActionWithUrl:hostUrl parameters:dic completion:^(RXBaseResponse *response) {
        if (completion) {
            completion(response);
        }
    }];
//    NSString *param = [self parametersFromDictionary:dic];
//    
//    
//    NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //    <7369676e 3d50784b 54356c66 50717578 39253242 4e372532 4676756c 42682532 424f6f39 32474f72 4237794b 6d555243 4e455956 70302533 44266d6f 62696c65 3d313539 30313033 31393534 26636c69 656e7456 65727369 6f6e3d69 4f53322e 39>
    //    <7369676e 3d50784b 54356c66 50717578 392b4e37 2f76756c 42682b4f 6f393247 4f724237 794b6d55 52434e45 59567030 3d266d6f 62696c65 3d313539 30313033 31393534 26636c69 656e7456 65727369 6f6e3d69 4f53322e 39>
    
//    NSDictionary *dic2 = @{SKey_mobile:mobile,
//                           @"sign":sign};
//    NSString *param2 = [self parametersFromDictionary:dic2];
//    NSData *postData2 = [param2 dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSLog(@"p1:%@ p2:%@", postData, postData2);
//    
//    
//    NSString *str1 = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//    NSString *str2 = [[NSString alloc] initWithData:postData2 encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"str1:%@ str2:%@", str1, str2);
//    
//    RXHttpBlock *http = [[RXHttpBlock alloc] init];
//    http.httpClient = [http postRequestByHostUrl:hostUrl withParameters:param success:^(id contentObject) {
//        success(http, contentObject, nil);
//    } failure:^(NSError *error) {
//        success(http, @"", error);
//    }];
//    return http;
}



@end
