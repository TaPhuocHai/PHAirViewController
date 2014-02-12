//
//  PHViewController.m
//  Demo2
//
//  Created by Ta Phuoc Hai on 2/12/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHViewController.h"

@implementation PHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 35);
    [button setTitle:@"Menu" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(leftButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    typeof(self) bself = self;
    self.phSwipeHander = ^{
        [bself.airViewController showAirViewFromViewController:bself.navigationController complete:nil];
    };
}

- (void)leftButtonTouch
{
    [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
}

- (UILabel*)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 320, 40)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:16];
        _label.textColor = [UIColor redColor];
        [self.view addSubview:_label];
    }
    return _label;
}

@end
