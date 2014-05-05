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

- (UIButton*)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 40, self.frame.size.width, kHeaderTitleHeight-40);
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_button];
    }
    return _button;
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
    [_button removeFromSuperview];
    _button = nil;
    [_containView removeFromSuperview];
    _containView = nil;
}

@end
