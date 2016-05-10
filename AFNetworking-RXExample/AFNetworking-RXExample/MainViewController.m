//
//  MainViewController.m
//  AFNetworking-RXExample
//
//  Created by ceshi on 16/5/10.
//  Copyright © 2016年 Rush. All rights reserved.
//

#import "MainViewController.h"
#import "RTExhibitionListRequest.h"







@interface MainViewController ()



@end

@implementation MainViewController


- (void)testOneRequest
{
    RTExhibitionListRequest *request = [[RTExhibitionListRequest alloc] init];
    [request startWithCompletion:^(RXBaseRequest *request, id responseObject, NSError *error) {
        NSLog(@"responseObject:%@", responseObject);
        NSLog(@"error:%@", error);
    }];
//    [request start];
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
