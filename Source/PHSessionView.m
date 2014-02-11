//
//  PHSessionView.m
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/7/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHSessionView.h"

@implementation PHSessionView

#pragma mark - property

- (UILabel*)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, kHeaderTitleHeight-40)];
        [self addSubview:_label];
    }
    return _label;
}

- (UIView*)containView
{
    if (!_containView) {
        _containView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderTitleHeight + 20, self.frame.size.width, self.frame.size.height - kHeaderTitleHeight)];
        [self addSubview:_containView];
    }
    return _containView;
}

#pragma mark - clean up

- (void)dealloc
{
    [_label removeFromSuperview];
    _label = nil;
    [_containView removeFromSuperview];
    _containView = nil;
}

@end
