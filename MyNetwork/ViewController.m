//
//  ViewController.m
//  MyNetwork
//
//  Created by xiongzenghui on 14/11/20.
//  Copyright (c) 2014年 wadexiong. All rights reserved.
//

#import "ViewController.h"

#import "XZHReachabilityManager.h"

@interface ViewController () {
//    UIView * view;
}


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    XZHReachabilityManager * manager = [XZHReachabilityManager managerForDomain:@"http://www.baidu.com"];
    [manager setReachabilityChangedHandler:^(ReachabilityState changedState) {
        NSLog(@"当前状态： %d\n" , changedState);
    }];
//    [manager startMonitoring];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
