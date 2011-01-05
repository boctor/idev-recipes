//
//  TabBarAnimationAppDelegate.m
//  TabBarAnimation
//
//  Created by Peter Boctor on 12/16/10.
//
// Copyright (c) 2011 Peter Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "TabBarAnimationAppDelegate.h"

@interface TabBarAnimationAppDelegate (PrivateMethods)
- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex;
- (void) addTabBarArrow;
@end

@implementation TabBarAnimationAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize tabBarArrow;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    tabBarController.delegate = self;
    
    // Add the tab bar controller's view to the window and display.
    [self.window addSubview:tabBarController.view];
    [self addTabBarArrow];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void) addTabBarArrow
{
  UIImage* tabBarArrowImage = [UIImage imageNamed:@"TabBarNipple.png"];
  self.tabBarArrow = [[[UIImageView alloc] initWithImage:tabBarArrowImage] autorelease];
  // To get the vertical location we start at the bottom of the window, go up by height of the tab bar, go up again by the height of arrow and then come back down 2 pixels so the arrow is slightly on top of the tab bar.
  CGFloat verticalLocation = self.window.frame.size.height - tabBarController.tabBar.frame.size.height - tabBarArrowImage.size.height + 2;
  tabBarArrow.frame = CGRectMake([self horizontalLocationFor:0], verticalLocation, tabBarArrowImage.size.width, tabBarArrowImage.size.height);

  [self.window addSubview:tabBarArrow];
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
  // A single tab item's width is the entire width of the tab bar divided by number of items
  CGFloat tabItemWidth = tabBarController.tabBar.frame.size.width / tabBarController.tabBar.items.count;
  // A half width is tabItemWidth divided by 2 minus half the width of the arrow
  CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (tabBarArrow.frame.size.width / 2.0);
  
  // The horizontal location is the index times the width plus a half width
  return (tabIndex * tabItemWidth) + halfTabItemWidth;
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  CGRect frame = tabBarArrow.frame;
  frame.origin.x = [self horizontalLocationFor:tabBarController.selectedIndex];
  tabBarArrow.frame = frame;
  [UIView commitAnimations];  
  
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarArrow release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

