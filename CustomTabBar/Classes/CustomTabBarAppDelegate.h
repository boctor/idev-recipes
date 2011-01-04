//
//  CustomTabBarAppDelegate.h
//  CustomTabBar
//
//  Created by Peter Boctor on 1/2/11.
//  Copyright 2011 Zumobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTabBarViewController;

@interface CustomTabBarAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CustomTabBarViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CustomTabBarViewController *viewController;

@end

