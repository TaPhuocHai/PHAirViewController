//
//  PHAirViewController.m
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/7/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHAirViewController.h"

#import <QuartzCore/QuartzCore.h>

#define kMenuItemHeight 50
#define kSessionWidth   220

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

static NSString * const PHSegueRootIdentifier  = @"phair_root";

@interface PHAirViewController()
@property (nonatomic, strong) UIView * contentImageView;
@end

@implementation PHAirViewController {
    
    // number of data
    NSInteger  session;
    NSArray  * rowsOfSession;
    
    // sesion view
    NSMutableDictionary    * sessionViews;
    UIPanGestureRecognizer * panGestureRecognizer;
    
    // current index sesion view
    int        currentIndexSession;
    
    // for animation
    BOOL            isAnimation;
    PHSessionView * topSession;
    PHSessionView * middleSession;
    PHSessionView * bottomSession;
}

@synthesize contentView = _contentView, airImageView = _airImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = NO;
    
    // Init sessionViews
    sessionViews = [NSMutableDictionary dictionary];
    currentIndexSession = 0;
    
    self.delegate = self;
    
    // Init contentView
    [self.view addSubview:self.contentView];
    
    // Init airImageView
    [self.view addSubview:self.contentImageView];
    [self.contentImageView addSubview:self.airImageView];
    self.airImageView.alpha = 0;
    
    // Init root view controller
    if ( self.storyboard) {
        @try {
            [self performSegueWithIdentifier:PHSegueRootIdentifier sender:nil];
        }
        @catch(NSException *exception) {}
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // layout menu
    [self reloadData];
}

#pragma mark storyboard support

- (void)prepareForSegue:(PHAirViewControllerSegue *)segue sender:(id)sender
{
    if ( [segue isKindOfClass:[PHAirViewControllerSegue class]] && sender == nil )
    {
        if (self.fontViewController && self.fontViewController.view.superview) {
            [self.fontViewController removeFromParentViewController];
            [self.fontViewController.view removeFromSuperview];
        }
        
        segue.performBlock = ^(PHAirViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            _fontViewController = dvc;
            
            [self addChildViewController:dvc];
            
            UIView * controllerView = dvc.view;
            controllerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            controllerView.frame = self.view.bounds;
            [self.view addSubview:controllerView];
            
            [dvc didMoveToParentViewController:self];
        };
    }
}

#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // only allow gesture if no previous request is in process
    return ( gestureRecognizer == panGestureRecognizer && !isAnimation) ;
}

#pragma mark - Gesture Based Reveal

- (void)_handleRevealGesture:(UIPanGestureRecognizer *)recognizer
{
    switch ( recognizer.state )
    {
        case UIGestureRecognizerStateBegan:
            [self _handleRevealGestureStateBeganWithRecognizer:recognizer];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self _handleRevealGestureStateChangedWithRecognizer:recognizer];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self _handleRevealGestureStateEndedWithRecognizer:recognizer];
            break;
            
        case UIGestureRecognizerStateCancelled:
            [self _handleRevealGestureStateCancelledWithRecognizer:recognizer];
            break;
        default:
            break;
    }
}

- (void)_handleRevealGestureStateBeganWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
}

- (void)_handleRevealGestureStateChangedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGFloat translation = [recognizer translationInView:_contentView].y;
    self.contentView.top = -(self.view.height - kHeaderTitleHeight) + translation;
}

- (void)_handleRevealGestureStateEndedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    if (sessionViews.count == 0) {
        return;
    }
    
    int firstTop = - (self.view.height - kHeaderTitleHeight);
    int afterTop = self.contentView.top;
    
    if (afterTop - firstTop > 0) {
        if (afterTop - firstTop > self.view.height/2) {
            [self prevSession];
            NSLog(@"animation down to next");
        } else {
            [self slideCurrentSession];
            NSLog(@"animation up with current");
        }
    } else {
        if (firstTop - afterTop > self.view.height/2) {
            [self nextSession];
            NSLog(@"animation up to next");
        }  else {
            [self slideCurrentSession];
            NSLog(@"animation down with current");
        }
    }
}

- (void)_handleRevealGestureStateCancelledWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
}

- (void)nextSession
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
    {
        self.contentView.top = -(self.contentView.height/3)*2;
    } completion:^(BOOL finished) {
        currentIndexSession ++;
        if (currentIndexSession >= sessionViews.count) {
            currentIndexSession = 0;
        }
        [self layoutContaintView];
        self.contentView.top = -self.contentView.height/3;
    }];
}

- (void)prevSession
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.contentView.top = 0;
     } completion:^(BOOL finished) {
         currentIndexSession --;
         if (currentIndexSession < 0) {
             currentIndexSession = sessionViews.count - 1;
         }
         [self layoutContaintView];
         self.contentView.top = -self.contentView.height/3;
     }];
}

- (void)slideCurrentSession
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.contentView.top = -self.contentView.height/3;
     } completion:^(BOOL finished) {
     }];
}

#pragma mark - layout menu

- (void)reloadData
{
    if (!self.delegate) return;
    
    // Get number session
    session = [self.delegate numberOfSession];
    
    // Get number rows of session
    NSMutableArray * temp = [NSMutableArray array];
    for (int i = 0; i < session; i ++) {
        [temp addObject:@([self.delegate numberOfRowsInSession:i])];
    }
    rowsOfSession = [NSArray arrayWithArray:temp];
    
    // Init PHSessionView
    int sessionHeight = self.view.frame.size.height - kHeaderTitleHeight;
    for (int i = 0; i < session; i ++) {
        PHSessionView * sessionView = sessionViews[@(i)];
        if (!sessionView) {
            sessionView = [[PHSessionView alloc] initWithFrame:CGRectMake(0, 0, kSessionWidth, sessionHeight)];
            [sessionViews setObject:sessionView forKey:@(i)];
        }
        // Set title for header session
        if ([self.delegate respondsToSelector:@selector(titleForHeaderAtSession:)]) {
            sessionView.label.text = [self.delegate titleForHeaderAtSession:i];
            sessionView.label.textColor = [UIColor blackColor];
            sessionView.label.backgroundColor = [UIColor clearColor];
        }
    }
    
    // Init menu item for session
    for (int i = 0; i < session; i ++) {
        PHSessionView * sessionView = sessionViews[@(i)];
        // Remove all sub-view for contain of PHSessionView
        for (UIView * view in sessionView.containView.subviews) {
            [view removeFromSuperview];
        }

        int firstTop = (sessionView.containView.frame.size.height - [rowsOfSession[i] intValue] * 44)/2;
        if (firstTop < 0) firstTop = 0;
        for (int j = 0; j < [rowsOfSession[i] intValue]; j ++) {
            NSString * title = [self.delegate titleForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(rowDidTouch:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, firstTop + 44*j, 100, 44);
            [sessionView.containView addSubview:button];
        }
    }
    
    [self layoutContaintView];
}

#pragma mark - layout

- (void)layoutContaintView
{
    if (sessionViews.count == 0) {
        middleSession = sessionViews[@(0)];
        topSession = nil;
        bottomSession = nil;
        return;
    }
    
    // Init top/middle/bottom session view
    middleSession = sessionViews[@(currentIndexSession)];
    if (currentIndexSession == 0) {
        topSession = sessionViews[@(sessionViews.count - 1)];
    } else {
        topSession = sessionViews[@(currentIndexSession - 1)];
    }
    if (currentIndexSession + 1 >= sessionViews.count) {
        bottomSession = sessionViews[@(0)];
    } else {
        bottomSession = sessionViews[@(currentIndexSession + 1)];
    }
    
    // Pos for top/middle/bottom session
    topSession.top    = 0;
    middleSession.top = topSession.bottom;
    bottomSession.top = middleSession.bottom;
    
    if (topSession.superview)    [topSession removeFromSuperview];
    if (middleSession.superview) [middleSession removeFromSuperview];
    if (bottomSession.superview) [bottomSession removeFromSuperview];
    
    // Add top/middle/bottom to content view
    [self.contentView addSubview:topSession];
    [self.contentView addSubview:middleSession];
    [self.contentView addSubview:bottomSession];
}

#pragma mark - PHAirMenuDelegate

- (NSInteger)numberOfSession { return 0; }

- (NSInteger)numberOfRowsInSession:(NSInteger)sesion
{
    return  0;
}

- (NSString*)titleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return @"";
}

#pragma mark - button action

- (void)rowDidTouch:(id)sender
{
    NSLog(@"did touch");
}

#pragma mark - property

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, -(self.view.height - kHeaderTitleHeight), kSessionWidth, (self.view.height - kHeaderTitleHeight)*3)];
    }
    return _contentView;
}

- (UIView*)airImageView
{
    if (!_airImageView) {
        _airImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    }
    return _airImageView;
}

- (UIView*)contentImageView
{
    if (!_contentImageView) {
        _contentImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    }
    return _contentImageView;
}

#pragma mark - Show/Hide air view controller

- (void)toggleAirOnViewController:(UIViewController*)controller
{
    if (!panGestureRecognizer) {
        // Init pan
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleRevealGesture:)];
        panGestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:panGestureRecognizer];
    }
    
    // Create Image
    if (controller.navigationController) {
        _airImageView.image = [self imageWithView:controller.navigationController.view];
        [controller.navigationController setNavigationBarHidden:YES animated:NO];
    } else {
        _airImageView.image = [self imageWithView:controller.view];
    }
    _airImageView.alpha = 1;
    [self.view bringSubviewToFront:_airImageView];
    
    // Remove font view controller
    if (controller) {
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
    }
    
    // Setup animation
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -600;
    self.contentImageView.layer.sublayerTransform = rotationAndPerspectiveTransform;
    
    CGPoint anchorPoint = CGPointMake(1, 0.5);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
     CATransform3D currentTransform = _airImageView.layer.transform;
    _airImageView.layer.anchorPoint = anchorPoint;
    CGFloat newX = _airImageView.width * anchorPoint.x;
    CGFloat newY = _airImageView.height * anchorPoint.y;
    _airImageView.layer.position = CGPointMake(newX, newY);
    _airImageView.layer.transform = currentTransform;
    [CATransaction commit];
    

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CATransform3D transform = _airImageView.layer.transform;
        transform = CATransform3DRotate(transform, DegreesToRadians(-60), 0, 1, 0);
        transform = CATransform3DTranslate(transform, _airImageView.width/3, 0, -60);
        _airImageView.layer.transform = transform;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - helper

- (UIImage*)imageWithView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Clean up

- (void)dealloc
{
    [_airImageView removeFromSuperview];
    _airImageView = nil;
    [_contentView removeFromSuperview];
    _contentView = nil;
    
    rowsOfSession = nil;
}

@end


#pragma mark - UIViewController(PHAirViewController) Category

@implementation UIViewController(PHAirViewController)

- (PHAirViewController*)airViewController
{
    UIViewController *parent = self;
    Class revealClass = [PHAirViewController class];
    
    while ( nil != (parent = [parent parentViewController]) && ![parent isKindOfClass:revealClass] ) {}
    return (id)parent;
}

@end


#pragma mark - PHAirViewControllerSegue Class

@implementation PHAirViewControllerSegue

- (void)perform
{
    if ( _performBlock != nil )
    {
        _performBlock( self, self.sourceViewController, self.destinationViewController );
    }
}

@end
