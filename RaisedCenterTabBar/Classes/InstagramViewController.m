//
//  InstagramViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "InstagramViewController.h"

@implementation InstagramViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"Feed" image:[UIImage imageNamed:@"112-group.png"]],
                            [self viewControllerWithTabTitle:@"Popular" image:[UIImage imageNamed:@"29-heart.png"]],
                            [self viewControllerWithTabTitle:@"Share" image:nil],
                            [self viewControllerWithTabTitle:@"News" image:[UIImage imageNamed:@"news.png"]],
                            [self viewControllerWithTabTitle:@"@user" image:[UIImage imageNamed:@"123-id-card.png"]], nil];
}

-(void)willAppearIn:(UINavigationController *)navigationController
{
  [self addCenterButtonWithImage:[UIImage imageNamed:@"cameraTabBarItem.png"] highlightImage:nil];
}

@end
