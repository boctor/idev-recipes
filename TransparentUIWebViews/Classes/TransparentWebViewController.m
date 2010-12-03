//
//  TransparentWebViewController.m
//  TransparentUIWebViews
//
//  Created by Peter Boctor on 12/3/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "TransparentWebViewController.h"

@interface TransparentWebViewController (PrivateMethods)
- (void)hideGradientBackground:(UIView*)theView;
@end

@implementation TransparentWebViewController
@synthesize webView;

- (void)viewDidLoad
{
  [super viewDidLoad];

  [webView setBackgroundColor:[UIColor clearColor]];
  [self hideGradientBackground:webView];

  [webView loadHTMLString:@"This is a completely transparent UIWebView. Notice the missing gradient at the top and bottom as you scroll up and down." baseURL:nil];
}

- (void) hideGradientBackground:(UIView*)theView
{
  for (UIView * subview in theView.subviews)
  {
    if ([subview isKindOfClass:[UIImageView class]])
      subview.hidden = YES;

    [self hideGradientBackground:subview];
  }
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.webView = nil;
}

- (void)dealloc
{
  [webView release];
  [super dealloc];
}

@end
