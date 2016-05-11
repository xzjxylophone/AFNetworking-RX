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

#import "RXLoginRequest.h"






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

- (void)testOneRequest
{
    __weak __typeof(self) weakSelf = self;
    RTExhibitionListRequest *request = [[RTExhibitionListRequest alloc] initWithOffset:0 num:20];
    [request startWithCompletion:^(RXBaseRequest *request, RXBaseResponse *response) {
        [weakSelf addViewToView];
    }];
}


- (void)testOneRequest2
{
    __weak __typeof(self) weakSelf = self;
    RTBaseCityRequest *request = [[RTBaseCityRequest alloc] init];
    [request startWithCompletion:^(RXBaseRequest *request, RXBaseResponse *response) {
        [weakSelf addViewToView];
        weakSelf.rtBaseCityRequest = nil;
    }];
    self.rtBaseCityRequest = request;
}



- (void)testOneRequest3
{
    NSString *account = @"15901031954";
    NSString *pwd = @"123456";
    __weak __typeof(self) weakSelf = self;
    RXLoginRequest *request = [[RXLoginRequest alloc] initWithAccount:account pwd:pwd];
    [request startWithCompletion:^(RXBaseRequest *request, RXBaseResponse *response) {
        [weakSelf addViewToView];
    }];
}



#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self performSelector:@selector(testOneRequest) withObject:nil afterDelay:1];
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
