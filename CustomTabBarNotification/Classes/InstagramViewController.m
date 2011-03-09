//
//  InstagramViewController.m
//  CustomTabBarNotification
//
//  Created by Peter Boctor on 3/7/11.
//
//  Copyright (c) 2011 Peter Boctor
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE

#import "InstagramViewController.h"
#import "CustomNavigationBar.h"

@interface InstagramViewController (PrivateMethods)
-(UIButton*) buttonWithText:(NSString*) text;
@end

@implementation InstagramViewController
@synthesize notificationView, commentCountLabel, likeCountLabel, followerCountLabel, showButton, hideButton;

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"Feed" image:[UIImage imageNamed:@"112-group.png"]],
                            [self viewControllerWithTabTitle:@"Popular" image:[UIImage imageNamed:@"29-heart.png"]],
                            [self viewControllerWithTabTitle:@"Share" image:nil],
                            [self viewControllerWithTabTitle:@"News" image:[UIImage imageNamed:@"news.png"]],
                            [self viewControllerWithTabTitle:@"@user" image:[UIImage imageNamed:@"123-id-card.png"]], nil];

  // Set the title view to the Instagram logo
  UIImage* titleImage = [UIImage imageNamed:@"navigationBarLogo.png"];
  UIView* titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,titleImage.size.width, self.navigationController.navigationBar.frame.size.height)];
  UIImageView* titleImageView = [[UIImageView alloc] initWithImage:titleImage];
  [titleView addSubview:titleImageView];
  titleImageView.center = titleView.center;
  CGRect titleImageViewFrame = titleImageView.frame;
  // Offset the logo up a bit
  titleImageViewFrame.origin.y = titleImageViewFrame.origin.y + 3.0;
  titleImageView.frame = titleImageViewFrame;
  self.navigationItem.titleView = titleView;

  // Get our custom nav bar
  CustomNavigationBar* customNavigationBar = (CustomNavigationBar*)self.navigationController.navigationBar;

  // Set the nav bar's background
  [customNavigationBar setBackgroundWith:[UIImage imageNamed:@"navigationBarBackgroundRetro.png"]];
}

-(void)willAppearIn:(UINavigationController *)navigationController
{
  [self addCenterButtonWithImage:[UIImage imageNamed:@"cameraTabBarItem.png"] highlightImage:nil];

  // Setup show/hide buttons
  self.showButton = [self buttonWithText:@"Show Notification"];
  [showButton addTarget:self action:@selector(showNotificationView:) forControlEvents:UIControlEventTouchUpInside];
  showButton.center = self.view.center;
  CGRect frame = showButton.frame;
  frame.origin.y = self.view.frame.size.height / 4.0;
  showButton.frame = frame;
  [self.view addSubview:showButton];
  
  self.hideButton = [self buttonWithText:@"Hide Notification"];
  [hideButton addTarget:self action:@selector(hideNotificationView:) forControlEvents:UIControlEventTouchUpInside];
  hideButton.center = self.view.center;
  frame = hideButton.frame;
  frame.origin.y = self.view.frame.size.height / 2.0;
  hideButton.frame = frame;
  [self.view addSubview:hideButton];
 
  showButton.enabled = YES;
  hideButton.enabled = NO;
}

-(UIButton*) buttonWithText:(NSString*) text
{
  UIImage* buttonImage = [UIImage imageNamed:@"button-normal.png"];
  UIImage* buttonPressedImage = [UIImage imageNamed:@"button-highlighted.png"];
  UIImage* buttonDisabledImage = [UIImage imageNamed:@"button-disabled.png"];
  
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);

  [button setTitle:text forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];

  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
  [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
  [button setBackgroundImage:buttonDisabledImage forState:UIControlStateDisabled];
  
  return button;
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
  // A single tab item's width is the entire width of the tab bar divided by number of items
  CGFloat tabItemWidth = self.tabBar.frame.size.width / self.tabBar.items.count;
  // A half width is tabItemWidth divided by 2 minus half the width of the notification view
  CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (notificationView.frame.size.width / 2.0);
  
  // The horizontal location is the index times the width plus a half width
  return (tabIndex * tabItemWidth) + halfTabItemWidth;
}

- (void) showNotificationViewFor:(NSUInteger)tabIndex
{
  // To get the vertical location we start at the top of the tab bar (0), go up by the height of the notification view, then go up another 2 pixels so our view is slightly above the tab bar
  CGFloat verticalLocation = - notificationView.frame.size.height - 2.0;
  notificationView.frame = CGRectMake([self horizontalLocationFor:tabIndex], verticalLocation, notificationView.frame.size.width, notificationView.frame.size.height);

  if (!notificationView.superview)
    [self.tabBar addSubview:notificationView];

  notificationView.alpha = 0.0;

  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.5];
  notificationView.alpha = 1.0;
  [UIView commitAnimations];
}

- (IBAction)showNotificationView:(id)sender
{
  showButton.enabled = NO;
  hideButton.enabled = YES;
  
  // Set the values for the number of comments, likes and followers
  commentCountLabel.text = @"2";
  likeCountLabel.text = @"1";
  followerCountLabel.text = @"3";
  
  // Show the notification view over the 3rd tab bar item
  [self showNotificationViewFor:3];
}

- (IBAction)hideNotificationView:(id)sender
{
  showButton.enabled = YES;
  hideButton.enabled = NO;
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.5];
  notificationView.alpha = 0.0;
  [UIView commitAnimations];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.notificationView = nil;
  self.commentCountLabel = nil;
  self.likeCountLabel = nil;
  self.followerCountLabel = nil;
}

- (void)dealloc
{
  [notificationView release];
  [commentCountLabel release];
  [likeCountLabel release];
  [followerCountLabel release];
  [showButton release];
  [hideButton release];
  [super dealloc];
}


@end
