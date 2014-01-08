//
//  PHAirViewController.m
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/7/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHAirViewController.h"

#define kMenuItemHeight 50

@interface PHAirViewController ()

@end

@implementation PHAirViewController {
    NSInteger  session;
    NSArray  * rowsOfSession;
    NSMutableDictionary * sessionViews;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init sessionViews
    sessionViews = [NSMutableDictionary dictionary];
    
    // layout menu
    [self reloadData];
}

#pragma mark - layout menu

- (void)reloadData
{
    if (!self.delegate) return;
    
    // Get number of session
    session = [self.delegate numberOfSession];
    // Get number rows of session
    NSMutableArray * temp = [NSMutableArray array];
    for (int i = 0; i < session; i ++) {
        [temp addObject:@([self.delegate numberOfRowsInSession:i])];
    }
    rowsOfSession = [NSArray arrayWithArray:temp];
    
    // Init PHSessionView
    for (int i = 0; i < session; i ++) {
        PHSessionView * sessionView = sessionViews[@(i)];
        if (sessionView) {
            sessionView = [[PHSessionView alloc] initWithFrame:CGRectMake(0, 0, 220, self.view.frame.size.height - kHeaderTitleHeight)];
            [sessionViews setObject:sessionView forKey:@(i)];
        }
        // Set title for header session
        if ([self.delegate respondsToSelector:@selector(titleForHeaderAtSession:)]) {
            sessionView.label.text = [self.delegate titleForHeaderAtSession:i];
        }
    }
    
    
}

#pragma mark - property

- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UIView*)airImageView
{
    if (!_airImageView) {
        _airImageView = [[UIImageView alloc] init];
    }
    return _airImageView;
}

#pragma mark - Clean up

- (void)dealloc
{
    [_airImageView removeFromSuperview];
    _airImageView = nil;
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    
    rowsOfSession = nil;
}

@end
