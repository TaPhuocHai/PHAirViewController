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
    switch (indexPath.row) {
        case 0:
            viewController.view.backgroundColor = [UIColor greenColor];
            break;
        case 1:
            viewController.view.backgroundColor = [UIColor yellowColor];
            break;
        case 2:
            viewController.view.backgroundColor = [UIColor redColor];
            break;
    }
    return controller;
}

@end
