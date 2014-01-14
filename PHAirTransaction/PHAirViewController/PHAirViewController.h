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
