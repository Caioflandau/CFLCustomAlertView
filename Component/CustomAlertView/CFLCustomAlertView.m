//
//  CFLCustomAlertView.m
//  CustomAlertView
//
//  Created by Caio Fukelmann Landau on 26/06/14.
//  Copyright (c) 2014 Caio Fukelmann Landau. All rights reserved.
//

#import "CFLCustomAlertView.h"
#import "CFLAlertViewTapOutsideRecognizer.h"
#import "CFLAlertButton.h"
#import <QuartzCore/QuartzCore.h>

@interface CFLCustomAlertView () <CFLAlertViewTapOutsideRecognizerDelegate> {
    BOOL isShowing;
    BOOL isViewReady;
    
    BOOL isCustomView;
    NSArray *buttonTitles;
    NSArray *buttons;
    
    CGAffineTransform startingViewTransform;
    
    NSString *title;
    NSString *message;
    
    UIDeviceOrientation currentOrientation;
}

@property (readonly) UIView *overlayView;

@property (readonly) UILabel *lblTitle;
@property (readonly) UILabel *lblMessage;

@property (readonly) UIView *viewButtonsHolder;

@end

@implementation CFLCustomAlertView

@synthesize overlayView = _overlayView;
@synthesize view = _view;
@synthesize viewButtonsHolder = _viewButtonsHolder;

@synthesize lblMessage = _lblMessage;
@synthesize messageView = _messageView;

@synthesize lblTitle = _lblTitle;
@synthesize titleView = _titleView;

@synthesize tintColor = _tintColor;

static CFLCustomAlertView *currentAlertView = nil;

-(id)initWithTitle:(NSString *)t message:(NSString *)m delegate:(id<CFLCustomAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    self = [super init];
    if (self) {
        isViewReady = NO;
        title = t;
        message = m;
        NSMutableArray *bTitles = [[NSMutableArray alloc] init];
        [bTitles addObject:cancelButtonTitle];
        for (NSString *btnTitle in otherButtonTitles) {
            [bTitles addObject:btnTitle];
        }
        buttonTitles = bTitles;
        self.delegate = delegate;
    }
    currentAlertView = self;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object:nil];
    
    return self;
}

-(void)show {
    if (isShowing)
        return;
    
    [self setupView];
    [self showInWindow:[self windowToShow]];
}

-(void)dismiss {
    if (!isShowing)
        return;
    
    [self dismissWithButtonIndex:-1];
}

-(void)dismissWithButtonIndex:(NSInteger)buttonIndex {
    [self dismissWithButtonIndex:buttonIndex completion:nil];
}

-(void)dismissWithButtonIndex:(NSInteger)buttonIndex completion:(SEL)selector {
    if (buttonIndex != -1) {
        if ([self.delegate respondsToSelector:@selector(customAlertView:willDismissWithButtonIndex:)]) {
            [self.delegate customAlertView:self willDismissWithButtonIndex:buttonIndex];
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 0;
        self.overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.f];
        self.view.transform = CGAffineTransformScale(startingViewTransform, 0.8, 0.8);
    } completion:^(BOOL finished) {
        [self.overlayView removeFromSuperview];
        isShowing = NO;
        if (buttonIndex != -1) {
            if ([self.delegate respondsToSelector:@selector(customAlertView:didDismissWithButtonIndex:)]) {
                [self.delegate customAlertView:self didDismissWithButtonIndex:buttonIndex];
            }
        }
        if ([self respondsToSelector:selector]) {
            [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
        }
        
    }];
}


-(void)showInWindow:(UIWindow*) window {
    isShowing = YES;
    self.view.alpha = 0;
    self.view.transform = CGAffineTransformScale(startingViewTransform, 1.2, 1.2);
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [[window.subviews objectAtIndex:0] addSubview:self.overlayView];
    [UIView animateWithDuration:0.2 animations:^{
        self.overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
        self.view.alpha = 1;
        self.view.transform = startingViewTransform;
    }];
}

#pragma mark - Getter/Setter
-(UIView *)overlayView {
    if (_overlayView == nil) {
        _overlayView = [[UIView alloc] initWithFrame:[self windowToShow].bounds];
        _overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        CFLAlertViewTapOutsideRecognizer *recognzier = [[CFLAlertViewTapOutsideRecognizer alloc] init];
        recognzier.tapOutsideDelegate = self;
        [_overlayView addGestureRecognizer:recognzier];
    }
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UIWindow *window = [self windowToShow];
    if (UIDeviceOrientationIsLandscape(orientation)) {
        _overlayView.frame = CGRectMake(0, 0, window.frame.size.height, window.frame.size.width);
    }
    else {
        _overlayView.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    }
    
    return _overlayView;
}

-(UIView *)titleView {
    if (_titleView == nil) {
        return self.lblTitle;
    }
    return _titleView;
}

-(void)setTitleView:(UIView *)titleView {
    _titleView = titleView;
}

-(UILabel *)lblTitle {
    if (_lblTitle == nil) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        _lblTitle.numberOfLines = 0;
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        CGRect titleSize = [title boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_lblTitle.font} context:nil];
        
        _lblTitle.frame = CGRectMake(15, 15, self.view.frame.size.width-30, ceil(titleSize.size.height));
        
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.text = title;
    }
    return _lblTitle;
}

-(UIView *)messageView {
    if (_messageView == nil) {
        return self.lblMessage;
    }
    return _messageView;
}

-(void)setMessageView:(UIView *)messageView {
    _messageView = messageView;
}

-(UILabel *)lblMessage {
    if (_lblMessage == nil) {
        _lblMessage = [[UILabel alloc] init];
        _lblMessage.lineBreakMode = NSLineBreakByWordWrapping;
        _lblMessage.numberOfLines = 0;
        _lblMessage.textColor = [UIColor blackColor];
        _lblMessage.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        CGRect messageSize = [message boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_lblMessage.font} context:nil];
        
        _lblMessage.frame = CGRectMake(15, 15, self.view.frame.size.width-30, ceil(messageSize.size.height));
        
        _lblMessage.textAlignment = NSTextAlignmentCenter;
        _lblMessage.contentMode = UIViewContentModeTop | UIViewContentModeCenter;
        _lblMessage.text = message;
    }
    return _lblMessage;
}

-(UIView *)view {
    if (_view == nil) {
        isCustomView = NO;
        _view = [[UIView alloc] initWithFrame:CGRectMake(0.05*self.overlayView.frame.size.width, (self.overlayView.frame.size.height / 2.0) - 100, 0.9*self.overlayView.frame.size.width, 200)];
        _view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
        [self roundView:_view withRadius:6];
        startingViewTransform = _view.transform;
    }
    return _view;
}

-(void)setView:(UIView *)view {
    if (_view == nil) {
        isCustomView = YES;
        _view = view;
        startingViewTransform = _view.transform;
    }
}

-(UIView *)viewButtonsHolder {
    if (_viewButtonsHolder == nil) {
        NSUInteger numOfButtons = buttonTitles.count;
        if (numOfButtons > 2) {
            NSUInteger height = numOfButtons * 44;
            _viewButtonsHolder = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-height, self.view.frame.size.width, height)];
        }
        else {
            _viewButtonsHolder = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
        }
        [self putButtons];
    }
    return _viewButtonsHolder;
}

-(UIColor *)tintColor {
    if (_tintColor == nil) {
        _tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }
    return _tintColor;
}

-(void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
}

#pragma mark - Inner Methods

-(UIWindow*)windowToShow {
    
    UIWindow *window;
    
    window = [UIApplication sharedApplication].keyWindow;
    
    return window;
}

-(void)setupView {
    if (isViewReady)
        return;
    
    if (!isCustomView) {
        [self.view addSubview:self.titleView];
        self.messageView.transform = CGAffineTransformMakeTranslation(0, self.titleView.frame.size.height+self.titleView.frame.origin.y);
        [self.view addSubview:self.messageView];
        [self viewButtonsHolder];
        self.view.frame = [self calculateViewFrame];
        _viewButtonsHolder = nil;
        [self.view addSubview:self.viewButtonsHolder];
    }
    [self centerView];
    [self.overlayView addSubview:self.view];
    isViewReady = YES;
}

-(void)centerView {
    CGRect frame = self.view.frame;
    NSInteger x = (CGRectGetWidth(self.overlayView.frame) - CGRectGetWidth(frame))/2.0;
    NSInteger y = (CGRectGetHeight(self.overlayView.frame) - CGRectGetHeight(frame))/2.0;
    self.view.frame = CGRectMake(x, y, frame.size.width, frame.size.height);
}

-(CGRect)calculateViewFrame {
    int width = 0.9*self.overlayView.frame.size.width;
    if (width > 288)
        width = 288;
    
    int height = 0;
    height += self.titleView.frame.size.height;
    height += self.titleView.frame.origin.y;
    height += self.messageView.frame.size.height;
    height += self.viewButtonsHolder.frame.size.height;
    
    //Margins:
    height += 25;
    if (self.messageView == _lblMessage) {
        height += 15;
    }
    
    return CGRectMake(0.05*self.overlayView.frame.size.width, (self.overlayView.frame.size.height / 2.0) - ceil((float)height / 2.0), width, height);
}

-(void)putButtons {
    if (buttonTitles.count > 2) {
        buttons = [self putButtonsVertically];
    }
    else {
        buttons = [self putButtonsHorizontally];
    }
}

-(NSArray*)putButtonsVertically {
    int buttonWidth = self.viewButtonsHolder.frame.size.width;
    int buttonHeight = 44.f;
    
    NSArray *reverseButtons = [[buttonTitles reverseObjectEnumerator] allObjects];
    
    NSMutableArray *reverseButtonsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < reverseButtons.count; i++) {
        NSString *buttonTitle = [reverseButtons objectAtIndex:i];
        
        CFLAlertButton *button = [self buttonWithDefaultStyleForTitle:buttonTitle];
        
        button.frame = CGRectMake(0, i*buttonHeight, buttonWidth, buttonHeight);
        
        CALayer *borderToAdd = [self topOnlyBorderLayerForButton:button];
        
        [button.layer addSublayer:borderToAdd];
        [reverseButtonsArray addObject:button];
        [self.viewButtonsHolder addSubview:button];
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return [[reverseButtonsArray reverseObjectEnumerator] allObjects];
}
-(NSArray*)putButtonsHorizontally {
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
    
    int buttonWidth = self.viewButtonsHolder.frame.size.width / buttonTitles.count;
    int buttonHeight = self.viewButtonsHolder.frame.size.height;
    
    for (int i = 0; i < buttonTitles.count; i++) {
        NSString *buttonTitle = [buttonTitles objectAtIndex:i];
        CFLAlertButton *button = [self buttonWithDefaultStyleForTitle:buttonTitle];
        button.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, buttonHeight);
        
        CALayer *borderToAdd;
        if (i != buttonTitles.count-1) {
            borderToAdd = [self topRightBorderLayerForButton:button];
        }
        else {
            borderToAdd = [self topOnlyBorderLayerForButton:button];
        }
        
        [button.layer addSublayer:borderToAdd];
        [buttonsArray addObject:button];
        [self.viewButtonsHolder addSubview:button];
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return buttonsArray;
}

-(CFLAlertButton*)buttonWithDefaultStyleForTitle:(NSString*)t {
    CFLAlertButton *button = [CFLAlertButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:t forState:UIControlStateNormal];
    [button setTitleColor:self.tintColor forState:UIControlStateNormal];
    button.tintColor = self.tintColor;
    button.highlightBackgroundColor = [UIColor colorWithWhite:0.85 alpha:0.5];
    button.clipsToBounds = YES;
    return button;
}

-(CALayer *)topOnlyBorderLayerForButton:(CFLAlertButton*)button {
    CALayer *borderToAdd = [CALayer layer];
    borderToAdd.borderColor = [UIColor colorWithWhite:0.66f alpha:0.85].CGColor;
    borderToAdd.borderWidth = 0.5f;
    borderToAdd.frame = CGRectMake(-0.5, 0, CGRectGetWidth(button.frame)+1.0, CGRectGetHeight(button.frame)+1.0);
    return borderToAdd;
}

-(CALayer *)topRightBorderLayerForButton:(CFLAlertButton*)button {
    CALayer *borderToAdd = [CALayer layer];
    borderToAdd.borderColor = [UIColor colorWithWhite:0.66f alpha:0.85].CGColor;
    borderToAdd.borderWidth = 0.5f;
    borderToAdd.frame = CGRectMake(-0.5, 0, CGRectGetWidth(button.frame)+0.5, CGRectGetHeight(button.frame)+1.0);
    return borderToAdd;
}

-(void)didClickButton:(id)button {
    NSInteger buttonIndex = [buttons indexOfObject:button];
    if ([self.delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)])
        [self.delegate customAlertView:self clickedButtonAtIndex:buttonIndex];
    
    [self dismissWithButtonIndex:buttonIndex];
}


#pragma mark - Orientation changes
-(void)deviceOrientationDidChange:(NSNotification *)notification {
    NSLog(@"deviceOrientationDidChange");
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (currentOrientation == orientation)
        return;
    
    currentOrientation = orientation;
    UIWindow *window = [self windowToShow];
    if (UIDeviceOrientationIsLandscape(orientation)) {
        self.overlayView.frame = CGRectMake(0, 0, window.frame.size.height, window.frame.size.width);
    }
    else {
        self.overlayView.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    }
    if (!isCustomView) {
        self.view.frame = [self calculateViewFrame];
    }
    [self centerView];
}


#pragma mark - CFLAlertViewTapOutsideRecognizerDelegate
-(UIView *)dialogView {
    return self.view;
}

-(void)didTapOutside {
    BOOL shouldDismiss = NO;
    if ([self.delegate respondsToSelector:@selector(customAlertViewShouldDismissOnTapOutside:)])
        shouldDismiss = [self.delegate customAlertViewShouldDismissOnTapOutside:self];
    
    else if (isCustomView) {
        shouldDismiss = YES;
    }
    if (shouldDismiss) {
        [self dismiss];
        if ([self.delegate respondsToSelector:@selector(customAlertViewDidDismissByTappingOutside:)])
            [self.delegate customAlertViewDidDismissByTappingOutside:self];
    }
}


#pragma mark - Utility
-(void) roundView:(UIView*)view withRadius:(int) radius
{
    view.layer.cornerRadius = radius;
    view.clipsToBounds = YES;
    view.layer.masksToBounds = YES;
}

@end
