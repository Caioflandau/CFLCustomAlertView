//
//  CFLAlertButton.m
//  CustomAlertView
//
//  Created by Caio Fukelmann Landau on 08/07/14.
//  Copyright (c) 2014 Caio Fukelmann Landau. All rights reserved.
//

#import "CFLAlertButton.h"

@implementation CFLAlertButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.regularBackgroundColor = self.backgroundColor;
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        self.backgroundColor = self.highlightBackgroundColor;
    }
    else {
        self.backgroundColor = self.regularBackgroundColor;
    }
}

@end
