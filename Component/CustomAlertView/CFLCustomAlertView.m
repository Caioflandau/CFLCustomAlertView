//
//  CFLCustomAlertView.m
//  CustomAlertView
//
//  Created by Caio Fukelmann Landau on 26/06/14.
//  Copyright (c) 2014 Caio Fukelmann Landau. All rights reserved.
//

#import "CFLCustomAlertView.h"
#import <QuartzCore/QuartzCore.h>

@interface CFLCustomAlertView () {
    BOOL isCustomView;
    NSArray *buttonTitles;
    NSArray *buttons;
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
@synthesize lblTitle = _lblTitle;

@synthesize tintColor = _tintColor;

static CFLCustomAlertView *currentAlertView = nil;

-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<CFLCustomAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    self = [super init];
    if (self) {
        NSMutableArray *bTitles = [[NSMutableArray alloc] init];
        [bTitles addObject:cancelButtonTitle];
        for (NSString *btnTitle in otherButtonTitles) {
            [bTitles addObject:btnTitle];
        }
        buttonTitles = bTitles;
        self.delegate = delegate;
    }
    currentAlertView = self;
    return self;
}

-(void)show {
    NSEnumerator *windows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
    
    for (UIWindow *window in windows) {
        if (window.windowLevel == UIWindowLevelNormal) {
            [self setupView];
            [window addSubview:self.overlayView];
            break;
        }
    }
}

-(void)dismiss {
    
}


#pragma mark - Getter/Setter
-(UIView *)overlayView {
    if (_overlayView == nil) {
        _overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    return _overlayView;
}

-(UILabel *)lblTitle {
    if (_lblTitle == nil) {
        _lblTitle = [[UILabel alloc] init];
    }
    return _lblTitle;
}

-(UILabel *)lblMessage {
    if (_lblMessage == nil) {
        _lblMessage = [[UILabel alloc] init];
    }
    return _lblMessage;
}

-(UIView *)view {
    if (_view == nil) {
        isCustomView = NO;
        _view = [[UIView alloc] initWithFrame:CGRectMake(0.05*self.overlayView.frame.size.width, (self.overlayView.frame.size.height / 2.0) - 100, 0.9*self.overlayView.frame.size.width, 200)];
        _view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        [self roundView:_view withRadius:8];
    }
    return _view;
}

-(void)setView:(UIView *)view {
    if (_view == nil) {
        isCustomView = YES;
        _view = view;
    }
}

-(UIView *)viewButtonsHolder {
    if (_viewButtonsHolder == nil) {
        _viewButtonsHolder = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
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
-(void)setupView {
    [self.view addSubview:self.lblTitle];
    [self.view addSubview:self.lblMessage];
    [self.view addSubview:self.viewButtonsHolder];
    
    [self.overlayView addSubview:self.view];
}

-(void)putButtons {
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
    
    int buttonWidth = self.viewButtonsHolder.frame.size.width / buttonTitles.count;
    int buttonHeight = self.viewButtonsHolder.frame.size.height;
    
    for (int i = 0; i < buttonTitles.count; i++) {
        NSString *buttonTitle = [buttonTitles objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:self.tintColor forState:UIControlStateNormal];
        button.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, buttonHeight);
        button.clipsToBounds = YES;

        CALayer *borderToAdd = [CALayer layer];
        borderToAdd.borderColor = [UIColor lightGrayColor].CGColor;
        borderToAdd.borderWidth = 1.f;
        if (i != buttonTitles.count-1) {
            borderToAdd.frame = CGRectMake(-1, 0, CGRectGetWidth(button.frame)+1, CGRectGetHeight(button.frame)+1);
        }
        else {
            borderToAdd.frame = CGRectMake(-1, 0, CGRectGetWidth(button.frame)+2, CGRectGetHeight(button.frame)+1);
        }
        
        [button.layer addSublayer:borderToAdd];
        [buttonsArray addObject:button];
        [self.viewButtonsHolder addSubview:button];
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    buttons = buttonsArray;
}

-(void)didClickButton:(id)button {
    if ([self.delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [self.delegate customAlertView:self clickedButtonAtIndex:[buttons indexOfObject:button]];
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
