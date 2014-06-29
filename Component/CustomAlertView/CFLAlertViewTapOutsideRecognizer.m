//
//  CFLAlertViewTapOutsideRecognizer.m
//  CustomAlertView
//
//  Created by  Caio Landau on 6/29/14.
//  Copyright (c) 2014 Caio Fukelmann Landau. All rights reserved.
//

#import "CFLAlertViewTapOutsideRecognizer.h"

@implementation CFLAlertViewTapOutsideRecognizer

-(id)init {
    self = [super initWithTarget:self action:@selector(onTap)];
    return self;
}

-(void)onTap {
    UIView *viewTapped = [self.view hitTest:[self locationInView:self.view] withEvent:nil];
    if (viewTapped == self.view) {
        [self.tapOutsideDelegate didTapOutside];
    }
}

@end
