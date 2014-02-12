//
//  PHMenuViewController.m
//  Demo2
//
//  Created by Ta Phuoc Hai on 2/12/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHMenuViewController.h"

@implementation PHMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - PHAirMenuDelegate & DataSource

- (NSInteger)numberOfSession
{
    return 2;
}

- (NSInteger)numberOfRowsInSession:(NSInteger)sesion
{
    return 3;
}

- (NSString*)titleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [NSString stringWithFormat:@"Row %ld in %ld", (long)indexPath.row, (long)indexPath.section];
}

- (NSString*)titleForHeaderAtSession:(NSInteger)session
{
    return [NSString stringWithFormat:@"Session %ld", (long)session];
}

- (UIViewController*)viewControllerForIndexPath:(NSIndexPath*)indexPath
{
    PHViewController * viewController = [[PHViewController alloc] init];
    UINavigationController * controller = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.label.text = [NSString stringWithFormat:@"View controller %d in session %d", indexPath.row, indexPath.section];
    viewController.view.backgroundColor = [UIColor colorWithRed:indexPath.row/(float)3 green:1 blue:indexPath.row/(float)3 alpha:1];
    return controller;
}

@end
