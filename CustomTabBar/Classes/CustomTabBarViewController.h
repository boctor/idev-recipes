//
//  CustomTabBarViewController.h
//  CustomTabBar
//
//  Created by Peter Boctor on 1/2/11.
//  Copyright 2011 Zumobi. All rights reserved.
//

#import "CustomTabBar.h"

@interface CustomTabBarViewController : UIViewController <CustomTabBarDelegate>
{
  CustomTabBar* tabBar;
}

@property (nonatomic, retain) CustomTabBar* tabBar;

@end

