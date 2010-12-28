//
//  VerticalSwipeArticlesAppDelegate.h
//  VerticalSwipeArticles
//
//  Created by Peter Boctor on 12/26/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

@interface VerticalSwipeArticlesAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate>
{
  UIWindow *window;
  UINavigationController *navigationController;
  UIView *loadingView;
  NSMutableData *topAppsData;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) NSMutableData *topAppsData;


@end

