//
//  PHView1ViewController.m
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/14/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHView1ViewController.h"

@implementation PHView1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 35);
    [button setTitle:@"Left" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)leftButtonTouch
{
    [self.airViewController toggleAirOnViewController:self];
}

@end
