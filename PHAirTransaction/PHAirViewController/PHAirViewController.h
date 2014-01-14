//
//  PHAirViewController.h
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/7/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PHSessionView.h"
#import "PHMenuItemView.h"

@protocol PHAirMenuDelegate <NSObject>
@required
- (NSInteger)numberOfSession;
- (NSInteger)numberOfRowsInSession:(NSInteger)sesion;
- (NSString*)titleForRowAtIndexPath:(NSIndexPath*)indexPath;
@optional
- (NSString*)segueForRowAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)titleForHeaderAtSession:(NSInteger)session;
@end

@interface PHAirViewController : UIViewController <PHAirMenuDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) id <PHAirMenuDelegate> delegate;

@property (nonatomic, strong)   UIView       * contentView;
@property (nonatomic, strong)   UIImageView  * airImageView;

- (void)reloadData;
- (void)toggleAirOnViewController:(UIViewController*)controller;

@end

#pragma mark - PHAirViewControllerDelegate Protocol

@protocol PHAirViewControllerDelegate<NSObject>
@optional
@end


#pragma mark - UIViewController(PHAirViewController) Category

// We add a category of UIViewController to let childViewControllers easily access their parent PHAirViewController
@interface UIViewController(PHAirViewController)
- (PHAirViewController*)airViewController;
@end


// This will allow the class to be defined on a storyboard
#pragma mark - PHAirViewControllerSegue

@interface PHAirViewControllerSegue : UIStoryboardSegue
@property (strong) void(^performBlock)( PHAirViewControllerSegue * segue, UIViewController * svc, UIViewController * dvc );
@end