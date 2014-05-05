//
//  PHViewController.m
//  PHAirViewController
//
//  Created by Ta Phuoc Hai on 2/11/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHViewController.h"

@interface PHViewController ()

@end

@implementation PHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = YES;
    // for ios7
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.15 green:0.61 blue:0.94 alpha:1]];
    }
    // for under ios7
    else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
