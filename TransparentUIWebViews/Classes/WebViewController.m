//
//  WebViewController.m
//  TransparentUIWebViews
//
//  Created by Peter Boctor on 12/3/10.
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
