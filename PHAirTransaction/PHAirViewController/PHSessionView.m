//
//  PHSessionView.m
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/7/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHSessionView.h"

@implementation PHSessionView {
    NSArray * buttons;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = CGRectMake(0, 0, self.frame.size.width, kHeaderTitleHeight);
}

#pragma mark - helper

- (UIButton*)buttonAtIndex:(NSInteger)index
{
    if (index < buttons.count) {
        return buttons[index];
    }
    return nil;
}

#pragma mark - property

- (UILabel*)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_label];
    }
    return _label;
}

#pragma mark - clean up

- (void)dealloc
{
    [_label removeFromSuperview];
    _label = nil;
}

@end
