//
//  PHAppDelegate.m
//  Demo2
//
//  Created by Ta Phuoc Hai on 2/12/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHAppDelegate.h"
#import "PHMenuViewController.h"

@implementation PHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    PHViewController * viewController = [[PHViewController alloc] init];
    UINavigationController * controller = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.label.text = @"Root view controller";
    viewController.view.backgroundColor = [UIColor greenColor];
    PHMenuViewController   * menuController = [[PHMenuViewController alloc] initWithRootViewController:controller
                                                                                           atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    self.window.rootViewController = menuController;
    [self.window makeKeyAndVisible];    
    return YES;
}

@end
