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

#define kDegreesRotate  -40.0f
#define kTranslateY     -20.0f
#define kTranslateZ     -300.0f
#define kAnimationDuraction 0.3f

#define kDegressRotateToOut  -54.0f
#define kTranslateYToOut     -20.0f
#define kTranslateZToOut     -300.0f

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

static NSString * const PHSegueRootIdentifier  = @"phair_root";

@interface PHAirViewController()

@property (nonatomic, strong) UIView      * contentImageView;
@property (nonatomic, strong) NSString    * lastSegue;
@property (nonatomic, strong) NSIndexPath * lastIndexPath;
@property (nonatomic, strong) UIViewController * lastViewController;

@property (nonatomic)         CATransform3D airNomalTransform;
@property (nonatomic)         float         lastDeegreesRotateTransform;

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
            self.lastSegue = PHSegueRootIdentifier;
        }
        @catch(NSException *exception) {}
    }
    
    // Init tap on contentView
    UIPanGestureRecognizer * tap = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(handleRevealGestureOnAirImageView:)];
    self.airImageView.backgroundColor = [UIColor greenColor];
    [self.airImageView addGestureRecognizer:tap];
    
    // Setup animation
    [self setupAnimation];
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

#pragma mark - ContentView

- (void)contentViewDidTap:(UITapGestureRecognizer *)recognizer
{
    if (_airImageView.tag == 1) {
        [self hideAirView];
    }
}

#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // only allow gesture if no previous request is in process
    return ( gestureRecognizer == panGestureRecognizer && !isAnimation) ;
}

#pragma mark - AirImageView gesture

- (void)handleRevealGestureOnAirImageView:(UIPanGestureRecognizer *)recognizer
{
    switch ( recognizer.state )
    {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
            break;
            
        case UIGestureRecognizerStateEnded:
            break;
            
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
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
    
    // Vị trí y của contentView khi ở chế độ bình thường
    int firstTop = - (self.view.height - kHeaderTitleHeight);
    // Vị trí y hiện tại của contentView khi scroll
    int afterTop = self.contentView.top;
    
    // Điểm center bình thường của contentView : self.view.height/2
    // Khi scroll lên và scroll xuống thì độ chênh lệch của contentView là self.view.height/2
    
    int sessionViewHeight = self.view.height - kHeaderTitleHeight;
    int distanceScroll = 0;
    // Nếu là kéo xuống
    if (afterTop - firstTop > 0) {
        int topMiddleSessionView = self.contentView.top + sessionViewHeight;
        // Nếu điểm top của middleSession trên contentView nằm phía trên của giữa màn hình (theo trục y)
        if (topMiddleSessionView < self.view.height/2) {
            distanceScroll = self.view.height/2 - topMiddleSessionView;
        }
        // Nếu điểm top của middleSession trên contentView nằm phía dưới của giữa màn hình (theo trục y)
        else {
            distanceScroll = topMiddleSessionView - self.view.height/2;
        }
    }
    // Nếu là kéo lên
    else {
        int bottomMiddleSessionView = self.contentView.top + sessionViewHeight*2;
        if (bottomMiddleSessionView > self.view.height/2) {
            distanceScroll = bottomMiddleSessionView - self.view.height/2;
        } else {
            distanceScroll = self.view.height/2 - bottomMiddleSessionView;
        }
    }
    
    distanceScroll = abs(self.view.height/2 - distanceScroll);
    
    // Tính độ xoay
    // 0 tương ứng 0
    // distanceScroll ---> ?
    // max : self.view.height/2 tương ứng với abs(kDegressRotateToOut - kDegreesRotate)
    float rotateDegress = (distanceScroll * abs(kDegressRotateToOut - kDegreesRotate))/(self.view.height/2);
    self.lastDeegreesRotateTransform = rotateDegress;
    
    NSLog(@"last de = %f",self.lastDeegreesRotateTransform);
    
    [self resetIdentityTransform];
    [self rotateWithDegrees:(kDegreesRotate - rotateDegress)
              andTranslateX: _airImageView.width/3
                 translateY:kTranslateY
                 translateZ:kTranslateZ
                  duraction:0
                   complete:nil];
}

- (void)_handleRevealGestureStateEndedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    if (sessionViews.count == 0) {
        return;
    }
    
    // Vị trí y của contentView khi ở chế độ bình thường
    int firstTop = - (self.view.height - kHeaderTitleHeight);
    // Vị trí y hiện tại của contentView khi scroll
    int afterTop = self.contentView.top;
    
    // Nếu là kéo xuống
    if (afterTop - firstTop > 0) {
        if (afterTop - firstTop > self.view.height/2) {
            // Đã kéo đủ một chiều cao cần thiết
            // Run animation down to next
            [self prevSession];
        } else {
            // Chưa kéo đủ một chiều cao cần thiết
            // Run animation up with current
            [self slideCurrentSession];
        }
    }
    // Nếu là kéo lên
    else {
        if (firstTop - afterTop > self.view.height/2) {
            // Run animation up to next
            [self nextSession];
        }  else {
            // Run animation down with current
            [self slideCurrentSession];
        }
    }
}

- (void)_handleRevealGestureStateCancelledWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
}

#pragma mark -

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
    [self rotateAirImage];
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
    [self rotateAirImage];
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
    [self rotateAirImage];
}

- (void)rotateAirImage
{
    [self rotateWithDegrees:self.lastDeegreesRotateTransform*2
              andTranslateX:0 translateY:0 translateZ:0 duraction:0.2 complete:^{
                  [self resetIdentityTransform];
                  [self rotateWithDegrees:kDegreesRotate
                            andTranslateX: _airImageView.width/3
                               translateY:kTranslateY
                               translateZ:kTranslateZ
                                duraction:0
                                 complete:nil];
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
            button.tag = j;
            sessionView.containView.tag = i;
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

- (NSInteger)numberOfRowsInSession:(NSInteger)sesion { return  0; }

- (NSString*)titleForHeaderAtSession:(NSInteger)session { return @""; }

- (NSString*)titleForRowAtIndexPath:(NSIndexPath*)indexPath { return @""; }

- (UIImage*)thumbnailImageAtIndexPath:(NSIndexPath*)indexPath { return nil; }

#pragma mark - button action

- (void)rowDidTouch:(UIButton*)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(segueForRowAtIndexPath:)]) {
        NSString * segue = [self.delegate segueForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag
                                                                                    inSection:button.superview.tag]];
        if (segue.length) {
            // Show  animation
            [self performSegueWithIdentifier:segue sender:nil];
        }
    }
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
        _airImageView.userInteractionEnabled = YES;
    }
    return _airImageView;
}

- (UIView*)contentImageView
{
    if (!_contentImageView) {
        _contentImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _contentImageView.userInteractionEnabled = YES;
    }
    return _contentImageView;
}

#pragma mark - Show/Hide air view controller

- (void)showAirViewFromViewController:(UIViewController*)controller
{
    // Khởi tạo panGestureRecognizer để scroll các session
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleRevealGesture:)];
        panGestureRecognizer.delegate = self;
        [self.contentView addGestureRecognizer:panGestureRecognizer];
    }
    
    // Create Image for airImageView
    if (controller.navigationController) {
        _airImageView.image = [self imageWithView:controller.navigationController.view];
        [controller.navigationController setNavigationBarHidden:YES animated:NO];
    } else {
        _airImageView.image = [self imageWithView:controller.view];
    }
    _airImageView.alpha = 1;
    [self.view bringSubviewToFront:self.contentImageView];
    [self.view bringSubviewToFront:self.contentView];
    
    // Remove font view controller
    if (controller) {
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
    }
    
    // Setup animation
    [self resetIdentityTransform];

    // Run animatin to show airView
    [self rotateWithDegrees:kDegreesRotate
              andTranslateX: _airImageView.width/3
                 translateY:kTranslateY
                 translateZ:kTranslateZ
                  duraction:kAnimationDuraction
                   complete:nil];
    
    _airImageView.tag = 1;
}

- (void)hideAirView
{
    // Setup animation
    [UIView animateWithDuration:kAnimationDuraction
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         CATransform3D transform = _airImageView.layer.transform;
         transform = CATransform3DTranslate(transform,- _airImageView.width/3, -kTranslateY, -kTranslateZ);
         transform = CATransform3DRotate(transform, -DegreesToRadians(kDegreesRotate), 0, 1, 0);
         transform = CATransform3DTranslate(transform,-19,0,-15);
         _airImageView.layer.transform = transform;
     } completion:^(BOOL finished) {
         _airImageView.alpha = 0;
         if (self.lastSegue.length) {
             [self performSegueWithIdentifier:self.lastSegue sender:nil];
         }
     }];
    
    _airImageView.tag = 0;
}

#pragma mark - animation

- (void)setupAnimation
{
    // Save nomal transform
    self.airNomalTransform = _airImageView.layer.transform;
    
    // Setup syblayerTransform
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -600;
    self.contentImageView.layer.sublayerTransform = rotationAndPerspectiveTransform;
    
    // AnchorPoint and nomal pos
    CGPoint anchorPoint = CGPointMake(1.5, 0.5);
    CGFloat newX = _airImageView.width * anchorPoint.x;
    CGFloat newY = _airImageView.height * anchorPoint.y;
    _airImageView.layer.position = CGPointMake(newX, newY);
    _airImageView.layer.anchorPoint = anchorPoint;
}

- (void)resetIdentityTransform
{
    _airImageView.layer.transform = self.airNomalTransform;
}

- (void)rotateWithDegrees:(float)degrees
            andTranslateX:(float)x
               translateY:(float)y
               translateZ:(float)z
                duraction:(float)duraction
                 complete:(void (^)(void))complete
{
    if (duraction) {
        [UIView animateWithDuration:duraction
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             CATransform3D transform = _airImageView.layer.transform;
             transform = CATransform3DRotate(transform, DegreesToRadians(degrees), 0, 1, 0);
             //transform = CATransform3DTranslate(transform, x, y, z);
             _airImageView.layer.transform = transform;
         } completion:^(BOOL finished) {
             if (complete) complete();
         }];
    } else {
        CATransform3D transform = _airImageView.layer.transform;
        transform = CATransform3DRotate(transform, DegreesToRadians(degrees), 0, 1, 0);
        //transform = CATransform3DTranslate(transform, x, y, z);
        _airImageView.layer.transform = transform;
        if (complete) complete();
    }
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
