//
//  RaisedCenterTabBarAppDelegate.h
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

@interface RaisedCenterTabBarAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate>
{
  UIWindow *window;
  UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end