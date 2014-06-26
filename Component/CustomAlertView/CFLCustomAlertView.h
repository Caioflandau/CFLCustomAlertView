//
//  CFLCustomAlertView.h
//  CustomAlertView
//
//  Created by Caio Fukelmann Landau on 26/06/14.
//  Copyright (c) 2014 Caio Fukelmann Landau. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CFLCustomAlertViewDelegate;

@interface CFLCustomAlertView : NSObject

@property id<CFLCustomAlertViewDelegate> delegate;

/**
 Sets the main dialog view. Can only be set BEFORE the dialog has been shown. Setting this property after calling 'show' will have no effect.
 */
@property UIView *view;


@property UIView *titleView;
@property UIView *messageView;

@property UIColor *tintColor;


#pragma mark - Interface Methods
-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<CFLCustomAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

-(void)show;
-(void)dismiss;

@end


#pragma mark - Delegate Definition

@protocol CFLCustomAlertViewDelegate <NSObject>

-(void)customAlertView:(CFLCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end