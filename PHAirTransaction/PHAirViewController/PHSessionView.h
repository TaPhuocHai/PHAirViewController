//
//  PHSessionView.h
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/7/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHeaderTitleHeight   70

@interface PHSessionView : UIView

@property (nonatomic, strong) UILabel * label;

- (UIButton*)buttonAtIndex:(NSInteger)index;

@end
