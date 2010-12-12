//
//  CustomSegmentedControlsAppDelegate.h
//  CustomSegmentedControls
//
//  Created by Peter Boctor on 12/10/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSegmentedControlsViewController;

@interface CustomSegmentedControlsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CustomSegmentedControlsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CustomSegmentedControlsViewController *viewController;

@end

