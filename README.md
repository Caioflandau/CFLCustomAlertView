#CFLCustomAlertView

CFLCustomAlertView is a customizable AlertView for iOS.
It tries to resemble native UIAlertView as much as possible to make the transition easier.

##Main features
* Custom views for title and/or message
* Custom tint color for dialog buttons
* Access to the root dialog view so you can change background color, etc
* Tap outside to dismiss (disabled by default).

##Easy to install
1. Clone/download this repository
2. Include the content of cloned `Component` folder in your project
3. `#import "CFLCustomAlertView.h"` in your ViewController or where you will be showing the alert

##Simple Usage
Anyone who has ever used UIAlertView should have no problems:
```Objective-c
CFLCustomAlertView *customAlertView = [[CFLCustomAlertView alloc] initWithTitle:@""
                                                                            message:@"But this message is just plain text."
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Will stack vertically"
                                                                  otherButtonTitles:@[@"More buttons", @"Three or"]];

//Setting custom title and message view:
customAlertView.titleView = <UIView object>;
customAlertView.messageView = <UIView object>;

[customAlertView show];

```

If you need the delegate methods (`customAlertView:clickedButtonAtIndex:` for instance), just make your ViewController conform to the `CFLCustomAlertViewDelegate` protocol.

For more examples and options, please check the Example project in the repository
