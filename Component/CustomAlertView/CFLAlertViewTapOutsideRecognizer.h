//
//  CFLAlertViewTapOutsideRecognizer.h
//  CustomAlertView
//
//  Created by  Caio Landau on 6/29/14.
//  Copyright (c) 2014 Caio Fukelmann Landau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFLAlertViewTapOutsideRecognizerDelegate <NSObject>

-(void)didTapOutside;

@end

@interface CFLAlertViewTapOutsideRecognizer : UITapGestureRecognizer

@property id<CFLAlertViewTapOutsideRecognizerDelegate> tapOutsideDelegate;

-(id)init;
@end
