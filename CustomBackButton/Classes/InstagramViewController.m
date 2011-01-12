//
//  InstagramViewController.m
//  CustomBackButton
//
//  Created by Peter Boctor on 1/11/11.
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

#define MAX_BACK_BUTTON_WIDTH 80.0

@implementation InstagramViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

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
  // Create a custom back button
  UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"navigationBarBackButton.png"] highlight:nil leftCapWidth:14.0];
  backButton.titleLabel.textColor = [UIColor colorWithRed:254.0/255.0 green:239.0/255.0 blue:218.0/225.0 alpha:1];
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
}

@end
