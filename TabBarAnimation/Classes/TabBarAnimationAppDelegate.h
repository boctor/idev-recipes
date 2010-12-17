//
//  TabBarAnimationAppDelegate.h
//  TabBarAnimation
//
//  Created by Peter Boctor on 12/16/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarAnimationAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    UIImageView* tabBarArrow;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) UIImageView* tabBarArrow;

@end
