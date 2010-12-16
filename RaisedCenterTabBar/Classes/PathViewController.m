//
//  PathViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "PathViewController.h"

@implementation PathViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"Today" image:[UIImage imageNamed:@"tab-today.png"]],
                            [self viewControllerWithTabTitle:@"Explore" image:[UIImage imageNamed:@"tab-explore"]],
                            [self viewControllerWithTabTitle:@"" image:nil],
                            [self viewControllerWithTabTitle:@"Friends" image:[UIImage imageNamed:@"tab-friends.png"]],
                            [self viewControllerWithTabTitle:@"Me" image:[UIImage imageNamed:@"tab-me.png"]], nil];
}

-(void)willAppearIn:(UINavigationController *)navigationController
{
  [self addCenterButtonWithImage:[UIImage imageNamed:@"capture-button.png"] highlightImage:nil];
}

@end
