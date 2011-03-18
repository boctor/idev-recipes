//
//  BaseLoadingViewController.m
//  WordPressReimagined
//
//  Created by Peter Boctor on 3/17/11.
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

#import "BaseLoadingViewController.h"

@implementation BaseLoadingViewController
@synthesize loadingView, loadingLabel, messageLabel, activityIndicator;

- (void)viewDidLoad
{
  [super viewDidLoad];

  if (!self.loadingView)
  {
    [[NSBundle mainBundle] loadNibNamed:@"BaseLoadingViewController" owner:self options:nil];
    [self.view addSubview:self.loadingView];
  }
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  self.loadingView.center = [self centerForLoading];
}

- (CGPoint) centerForLoading
{
  return [UIApplication sharedApplication].keyWindow.center;
}

- (void) showLoading
{
  loadingLabel.hidden= NO;
  activityIndicator.hidden = NO;
  messageLabel.hidden = YES;

  [self prepareForLoadingOrMessage];
}

- (void) hideLoading
{
  loadingLabel.hidden = YES;
  activityIndicator.hidden = YES;
  messageLabel.hidden = YES;
}

- (void) prepareForLoadingOrMessage
{
  // Empty implementation. Sub-classes can override to hide UI elements in preparation
}

- (void) errorMessage:(NSString*) message
{
  NSString* messageString = message;
  if (!message)
    messageString = @"Unable to load. Please try again.";

  messageLabel.text = messageString;
  messageLabel.hidden = NO;
  loadingLabel.hidden = YES;
  activityIndicator.hidden = YES;

  [self prepareForLoadingOrMessage];
}

- (void) defaultErrorMessage
{
  [self errorMessage:nil];
}

- (void) clearError
{
  messageLabel.text = @"";
}

- (void)viewDidUnload
{
  self.loadingView = nil;
  self.loadingLabel = nil;
  self.messageLabel = nil;
  self.activityIndicator = nil;
}

- (void)dealloc
{
  [loadingView release], loadingView = nil;
  [loadingLabel release], loadingLabel = nil;
  [messageLabel release], messageLabel = nil;
  [activityIndicator release], activityIndicator = nil;

  [super dealloc];
}

@end
