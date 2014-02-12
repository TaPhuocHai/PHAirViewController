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
    self.view.backgroundColor = [UIColor yellowColor];
    
    // Init menu data
    NSArray * session1 = [NSArray arrayWithObjects:@"phair_root",@"segue1", nil];
    NSArray * session2 = [NSArray arrayWithObjects:@"segue2",@"segue3", nil];
    data = [NSArray arrayWithObjects:session1, session2, nil];
}

#pragma mark - PHAirMenuDelegate

- (NSInteger)numberOfSession
{
    return data.count;
}

- (NSInteger)numberOfRowsInSession:(NSInteger)sesion
{
    return ((NSArray*)data[sesion]).count;
}

- (NSString*)titleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [NSString stringWithFormat:@"Row %ld in %ld", (long)indexPath.row, (long)indexPath.section];
}

- (NSString*)titleForHeaderAtSession:(NSInteger)session
{
    return [NSString stringWithFormat:@"Session %ld", (long)session];
}

- (NSString*)segueForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return data[indexPath.section][indexPath.row];
}

- (UIImage*)thumbnailImageAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

@end
