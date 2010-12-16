//
//  DailyBoothViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "DailyBoothViewController.h"

@implementation DailyBoothViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"Home" image:[UIImage imageNamed:@"tab_feed.png"]],
                            [self viewControllerWithTabTitle:@"Live" image:[UIImage imageNamed:@"tab_live"]],
                            [self viewControllerWithTabTitle:@"" image:nil],
                            [self viewControllerWithTabTitle:@"Profile" image:[UIImage imageNamed:@"tab_feed_profile.png"]],
                            [self viewControllerWithTabTitle:@"Messages" image:[UIImage imageNamed:@"tab_messages.png"]], nil];
}

-(void)willAppearIn:(UINavigationController *)navigationController
{
  [self addCenterButtonWithImage:[UIImage imageNamed:@"camera_button_take.png"] highlightImage:[UIImage imageNamed:@"tabBar_cameraButton_ready_matte.png"]];
}

@end
