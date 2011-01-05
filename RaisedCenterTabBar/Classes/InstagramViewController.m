//
//  InstagramViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
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
