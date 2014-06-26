//
//  CFLViewController.m
//  CustomAlertView
//
//  Created by Caio Fukelmann Landau on 26/06/14.
//  Copyright (c) 2014 Caio Fukelmann Landau. All rights reserved.
//

#import "CFLViewController.h"
#import "CFLCustomAlertView.h"

@interface CFLViewController () <CFLCustomAlertViewDelegate>

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
- (IBAction)show:(id)sender {
    [[[CFLCustomAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@[@"Ok", @"Mais"]] show];
}


#pragma mark - CFLCustomAlertViewDelegate

-(void)customAlertView:(CFLCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"customAlertView:clickedButtonAtIndex: %d", buttonIndex);
}
@end
