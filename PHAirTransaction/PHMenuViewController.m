//
//  PHMenuViewController.m
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/7/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHMenuViewController.h"

@implementation PHMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - PHAirMenuDelegate

- (NSInteger)numberOfSession
{
    return 1;
}

- (NSInteger)numberOfRowsInSession:(NSInteger)sesion
{
    return 1;
}

- (NSString*)segueForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return @"";
}

- (NSString*)titleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

@end
