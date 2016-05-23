//
//  MainViewController.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking-RXHeader.h"
#import "RTExhibitionListRequest.h"
#import "RTBaseCityRequest.h"

#import "RTLoginRequest.h"

#import "RXBatchRequestObject.h"

#import "RTSimpleHttpManager.h"
#import "RTUploadPicRequest.h"



@interface MainViewController ()


@property (nonatomic, strong) RTBaseCityRequest *rtBaseCityRequest;


@end

@implementation MainViewController

- (void)addViewToView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

- (void)testOneRequest1
{
    __weak __typeof(self) weakSelf = self;
    RTExhibitionListRequest *request = [[RTExhibitionListRequest alloc] initWithOffset:0 num:1];
    [request startWithCompletion:^(RXBaseRequest *request) {
        [weakSelf addViewToView];
    }];
}


- (void)testOneRequest2
{
    __weak __typeof(self) weakSelf = self;
    RTBaseCityRequest *request = [[RTBaseCityRequest alloc] init];
    [request startWithCompletion:^(RXBaseRequest *request) {
        [weakSelf addViewToView];
    }];
}



- (void)testOneRequest3
{
    __weak __typeof(self) weakSelf = self;
    NSString *account = @"15901031954";
    NSString *pwd = @"123456";
    RTLoginRequest *request = [[RTLoginRequest alloc] initWithAccount:account pwd:pwd];
    [request startWithCompletion:^(RXBaseRequest *request) {
        [weakSelf addViewToView];

    }];
}

- (void)testBatchRequest01
{
    RTBaseCityRequest *request1 = [[RTBaseCityRequest alloc] init];
    RTExhibitionListRequest *request2 = [[RTExhibitionListRequest alloc] initWithOffset:0 num:20];
    RXBatchRequestObject *batch = [[RXBatchRequestObject alloc] initWithRequestArray:@[request1, request2]];
    [batch startWithCompletion:^(RXBatchRequestObject *batchRequest) {
        NSLog(@"111");
        NSLog(@"1 response:%zd", request1.response.responseType);
        NSLog(@"2 response:%zd", request2.response.responseType);
    }];
}

- (void)testSimple01
{
    [RXSimpleHttpManager exhibitionListWithOffset:0 num:1 completion:^(RXBaseResponse *response) {
        NSLog(@"response:%zd", response.responseType);
    }];
}

- (void)testSimple02
{
    RTSimpleHttpManager *http = [RTSimpleHttpManager postExhibitionListWithOffset:0 num:1 completion:^(RXBaseResponse *response) {
        NSLog(@"kkk");
    }];
    NSLog(@"http:%@", NSStringFromClass([http class]));
}


- (void)testUpload01
{
    
    NSString *sessionId = @"38cd0cadedcdcf8e3cc252106653db3b";
    NSInteger type = 1;
    UIImage *image = [UIImage imageNamed:@"1024"];
    
    [RXSimpleHttpManager uploadWithSessionId:sessionId type:type image:image constructingBodyBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        // 以文件流格式上传图片
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress *progress) {
        NSLog(@"%zd %zd", progress.completedUnitCount, progress.totalUnitCount);

    } completion:^(RXBaseResponse *response) {
        NSLog(@"response:%zd", response.responseType);
    }];
}

- (void)testUpload02
{
    NSString *sessionId = @"38cd0cadedcdcf8e3cc252106653db3b";
    NSInteger type = 1;
    UIImage *image = [UIImage imageNamed:@"1024"];
    RTUploadPicRequest *requesut = [[RTUploadPicRequest alloc] initWithSessionId:sessionId type:type image:image];
    requesut.uploadProgress = ^(NSProgress *progress) {
        NSLog(@"%zd %zd", progress.completedUnitCount, progress.totalUnitCount);
    };
    [requesut startWithCompletion:^(RXBaseRequest *request) {
        
        NSLog(@"response:%zd", request.response.responseType);

        
        
    }];
}

- (void)testSendSMS001
{
    NSString *mobile = @"15901031954";
    
//    mobile = @"13720036022";
    [RTSimpleHttpManager sendVerifyCodeWithMobile:mobile completion:^(RXBaseResponse *response) {
        NSLog(@"response:%@", response.resultDictionary);
    }];
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self performSelector:@selector(testOneRequest1) withObject:nil afterDelay:1];
    
    
//    [self performSelector:@selector(testOneRequest3) withObject:nil afterDelay:1];
    
    
//    [self performSelector:@selector(testSimple01) withObject:nil afterDelay:1];
    
    
//    [self performSelector:@selector(testSimple02) withObject:nil afterDelay:1];
    
    
//    [self performSelector:@selector(testUpload01) withObject:nil afterDelay:1];
    
    
//    [self performSelector:@selector(testUpload02) withObject:nil afterDelay:1];
    
    
    [self performSelector:@selector(testSendSMS001) withObject:nil afterDelay:1];
    
    
    
//    [self performSelector:@selector(testBatchRequest01) withObject:nil afterDelay:1];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
