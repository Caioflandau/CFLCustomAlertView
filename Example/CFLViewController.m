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

-(IBAction)showRegular:(UIButton*)sender {
    CFLCustomAlertView *customAlertView = [[CFLCustomAlertView alloc] initWithTitle:@"This is a text-only AlertView"
                                                                            message:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                                                                           delegate:self cancelButtonTitle:@"Cancel"
                                                                  otherButtonTitles:@[@"Ok"]];
    [customAlertView show];

}
-(IBAction)showCustomTitle:(UIButton*)sender {
    CFLCustomAlertView *customAlertView = [[CFLCustomAlertView alloc] initWithTitle:@""
                                                                            message:@"But this message is just plain text."
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Will stack vertically"
                                                                  otherButtonTitles:@[@"More buttons", @"Three or"]];
    
    //Setting custom title view:
    customAlertView.titleView = [[[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:self options:nil] objectAtIndex:0];
    
    [customAlertView show];
}
-(IBAction)showCustomMessage:(UIButton*)sender {
    CFLCustomAlertView *customAlertView = [[CFLCustomAlertView alloc] initWithTitle:@"This title is... Yes, just PLAIN OLD TEXT!"
                                                                            message:@""
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Buttons"
                                                                  otherButtonTitles:@[@"Tinted", @"Custom"]];
    
    //Setting custom message view (in this case, an UIImageView)
    customAlertView.messageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple_logo"]];
    customAlertView.messageView.contentMode = UIViewContentModeScaleAspectFit;
    customAlertView.messageView.frame = CGRectMake(0, 10, customAlertView.view.frame.size.width, 128);
    customAlertView.tintColor = [UIColor colorWithRed:1 green:105.0/255.0 blue:0.0 alpha:1];
    
    [customAlertView show];
}
-(IBAction)showCustomTitleAndMessage:(UIButton*)sender {
    CFLCustomAlertView *customAlertView = [[CFLCustomAlertView alloc] initWithTitle:@""
                                                                            message:@""
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:@[]];
    
    customAlertView.titleView = [[[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:self options:nil] objectAtIndex:0];
    customAlertView.messageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple_logo"]];
    customAlertView.messageView.contentMode = UIViewContentModeScaleAspectFit;
    customAlertView.messageView.frame = CGRectMake(0, 10, customAlertView.view.frame.size.width, 128);
    customAlertView.tintColor = [UIColor colorWithRed:1 green:105.0/255.0 blue:0.0 alpha:1];
    [customAlertView show];
}

-(IBAction)showCustomView:(UIButton*)sender {
    CFLCustomAlertView *customAlertView = [[CFLCustomAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@[]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple_logo"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    customAlertView.view = imageView;
    [customAlertView show];
}


#pragma mark - CFLCustomAlertViewDelegate

-(void)customAlertView:(CFLCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"customAlertView:clickedButtonAtIndex: %d", (int)buttonIndex);
}

-(void)customAlertView:(CFLCustomAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"customAlertView:willDismissWithButtonIndex: %d", (int)buttonIndex);
}

-(void)customAlertView:(CFLCustomAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"customAlertView:didDismissWithButtonIndex: %d", (int)buttonIndex);
}

-(BOOL)customAlertViewShouldDismissOnTapOutside:(CFLCustomAlertView *)alertView {
    return YES;
}

-(void)customAlertViewDidDismissByTappingOutside:(CFLCustomAlertView *)alertView {
    NSLog(@"Alert was dismissed by tapping outside");
}

@end
