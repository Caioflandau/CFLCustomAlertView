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


/**
 View to show as the dialog's title in place of a simple UILabel
 This property only works if not using a custom view
 */
@property UIView *titleView;


/**
 View to show as the dialog's message in place of a simple UILabel
 This property only works if not using a custom view
 */
@property UIView *messageView;


/**
 Set this property to change the buttons' text color
*/
@property UIColor *tintColor;


#pragma mark - Interface Methods
-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<CFLCustomAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

-(void)show;
-(void)dismiss;

@end


#pragma mark - Delegate Definition

@protocol CFLCustomAlertViewDelegate <NSObject>
@optional

-(void)customAlertView:(CFLCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void)customAlertView:(CFLCustomAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;
-(void)customAlertView:(CFLCustomAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

-(void)customAlertViewDidDismissByTappingOutside:(CFLCustomAlertView *)alertView;

/**
 Ask the delegate if tapping outside the AlerView should dismiss it. Defaults to NO, unless using a custom view.
 
 If using a custom view, implement this method to avoid dismissing when tapping outside.
 */
-(BOOL)customAlertViewShouldDismissOnTapOutside:(CFLCustomAlertView *)alertView;

@end