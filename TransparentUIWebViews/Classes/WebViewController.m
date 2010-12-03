//
//  WebViewController.m
//  TransparentUIWebViews
//
//  Created by Peter Boctor on 12/3/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController
@synthesize webView;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [webView setBackgroundColor:[UIColor clearColor]];
  
  [webView loadHTMLString:@"This is a standard UIWebView. Notice the gradient at the top and bottom as you scroll up and down." baseURL:nil];
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
