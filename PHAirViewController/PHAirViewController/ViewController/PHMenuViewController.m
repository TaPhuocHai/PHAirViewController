//
//  PHMenuViewController.m
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/7/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHMenuViewController.h"

@implementation PHMenuViewController{
    NSArray * data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init menu data
    
}

#pragma mark - PHAirMenuDelegate

- (NSInteger)numberOfSession
{
    return 2;
}

- (NSInteger)numberOfRowsInSession:(NSInteger)sesion
{
    return 4;
}

- (NSString*)titleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [NSString stringWithFormat:@"Row %ld in %d", (long)indexPath.row, indexPath.section];
}

- (NSString*)titleForHeaderAtSession:(NSInteger)session
{
    return [NSString stringWithFormat:@"Session %ld", (long)session];
}

- (NSString*)segueForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return @"phair_root";
}

- (UIImage*)thumbnailImageAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

@end
