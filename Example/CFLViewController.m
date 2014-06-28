//
//  CFLViewController.m
//  CustomAlertView
//
//  Created by Caio Fukelmann Landau on 26/06/14.
//  Copyright (c) 2014 Caio Fukelmann Landau. All rights reserved.
//

#import "CFLViewController.h"
#import "CFLCustomAlertView.h"

@interface CFLViewController () <CFLCustomAlertViewDelegate> {
    CFLCustomAlertView *customAlertView;
    UIAlertView *alertView;
}

@end

@implementation CFLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)show:(UIButton*)sender {
    if (sender.tag == 0) {
        if (customAlertView == nil) {
            customAlertView = [[CFLCustomAlertView alloc] initWithTitle:@"This is a custom AlertView!" message:@"Message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Ok"]];
        }
        [customAlertView show];
    }
    else {
        if (alertView == nil) {
            alertView = [[UIAlertView alloc] initWithTitle:@"This is a default AlertView" message:@"Message" delegate:self cancelButtonTitle:@"a" otherButtonTitles:@"b", @"c", nil];
        }
        [alertView show];
    }
}


#pragma mark - CFLCustomAlertViewDelegate

-(void)customAlertView:(CFLCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"customAlertView:clickedButtonAtIndex: %d", buttonIndex);
}

-(void)customAlertView:(CFLCustomAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"customAlertView:willDismissWithButtonIndex: %d", buttonIndex);
}

-(void)customAlertView:(CFLCustomAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"customAlertView:didDismissWithButtonIndex: %d", buttonIndex);
}
@end
