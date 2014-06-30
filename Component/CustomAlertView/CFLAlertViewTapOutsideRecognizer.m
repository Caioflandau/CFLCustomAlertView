    //
//  CFLAlertViewTapOutsideRecognizer.m
//  CustomAlertView
//
//  Created by  Caio Landau on 6/29/14.
//  Copyright (c) 2014 Caio Fukelmann Landau. All rights reserved.
//

#import "CFLAlertViewTapOutsideRecognizer.h"

@interface CFLAlertViewTapOutsideRecognizer ()

@end

@implementation CFLAlertViewTapOutsideRecognizer

-(id)init {
    self = [super initWithTarget:self action:@selector(onTap)];
    return self;
}

-(void)onTap {
    if (self.state == UIGestureRecognizerStateEnded) {
        UIView *dialogView = [self.tapOutsideDelegate dialogView];
        CGPoint location = [self locationInView:self.view];
        if (![dialogView pointInside:[dialogView convertPoint:location fromView:self.view] withEvent:nil]) {
            [self.tapOutsideDelegate didTapOutside];
        }
    }
}

@end
