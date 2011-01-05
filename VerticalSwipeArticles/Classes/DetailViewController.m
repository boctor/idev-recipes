//
//  DetailViewController.m
//  VerticalSwipeArticles
//
//  Created by Peter Boctor on 12/26/10.
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

#import "DetailViewController.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@interface DetailViewController (PrivateMethods)
-(void)hideGradientBackground:(UIView*)theView;
-(UIWebView*) createWebViewForIndex:(NSUInteger)index;
@end

@implementation DetailViewController

@synthesize headerView, headerImageView, headerLabel;
@synthesize footerView, footerImageView, footerLabel;
@synthesize verticalSwipeScrollView, appData, startIndex;
@synthesize previousPage, nextPage;

- (void)viewDidLoad
{
  headerImageView.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
}

-(void)willAppearIn:(UINavigationController *)navigationController
{
  self.verticalSwipeScrollView = [[[VerticalSwipeScrollView alloc] initWithFrame:self.view.frame headerView:headerView footerView:footerView startingAt:startIndex delegate:self] autorelease];
  [self.view addSubview:verticalSwipeScrollView];
}

- (void) rotateImageView:(UIImageView*)imageView angle:(CGFloat)angle
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  imageView.transform = CGAffineTransformMakeRotation(DegreesToRadians(angle));
  [UIView commitAnimations];
}

# pragma mark VerticalSwipeScrollViewDelegate

-(void) headerLoadedInScrollView:(VerticalSwipeScrollView*)scrollView
{
  [self rotateImageView:headerImageView angle:0];
}

-(void) headerUnloadedInScrollView:(VerticalSwipeScrollView*)scrollView
{
  [self rotateImageView:headerImageView angle:180];
}

-(void) footerLoadedInScrollView:(VerticalSwipeScrollView*)scrollView
{
  [self rotateImageView:footerImageView angle:180];
}

-(void) footerUnloadedInScrollView:(VerticalSwipeScrollView*)scrollView
{
  [self rotateImageView:footerImageView angle:0];
}

-(UIView*) viewForScrollView:(VerticalSwipeScrollView*)scrollView atPage:(NSUInteger)page
{
  UIWebView* webView = nil;
  
  if (page < scrollView.currentPageIndex)
    webView = [[previousPage retain] autorelease];
  else if (page > scrollView.currentPageIndex)
    webView = [[nextPage retain] autorelease];
  
  if (!webView)
    webView = [self createWebViewForIndex:page];
  
  self.previousPage = page > 0 ? [self createWebViewForIndex:page-1] : nil;
  self.nextPage = (page == (appData.count-1)) ? nil : [self createWebViewForIndex:page+1];
  
  self.navigationItem.title = [[[appData objectAtIndex:page] objectForKey:@"im:name"] objectForKey:@"label"];
  if (page > 0)
    headerLabel.text = [[[appData objectAtIndex:page-1] objectForKey:@"im:name"] objectForKey:@"label"];
  if (page != appData.count-1)
    footerLabel.text = [[[appData objectAtIndex:page+1] objectForKey:@"im:name"] objectForKey:@"label"];

  return webView;
}

-(NSUInteger) pageCount
{
  return appData.count;
}

-(UIWebView*) createWebViewForIndex:(NSUInteger)index
{
  UIWebView* webView = [[[UIWebView alloc] initWithFrame:self.view.frame] autorelease];
  webView.opaque = NO;
  [webView setBackgroundColor:[UIColor clearColor]];
  [self hideGradientBackground:webView];

  NSString* htmlFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/DetailView.html"];
  NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
  htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- title -->" withString:[[[appData objectAtIndex:index] objectForKey:@"im:name"] objectForKey:@"label"]];
  htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- icon -->" withString:[[[[appData objectAtIndex:index] objectForKey:@"im:image"] objectAtIndex:0] objectForKey:@"label"]];
  htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- content -->" withString:[[[appData objectAtIndex:index] objectForKey:@"summary"] objectForKey:@"label"]];
  [webView loadHTMLString:htmlString baseURL:nil];
  
  return webView;
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
  self.headerView = nil;
  self.headerImageView = nil;
  self.headerLabel = nil;

  self.footerView = nil;
  self.footerImageView = nil;
  self.footerLabel = nil;
}

- (void)dealloc
{
  [headerView release];
  [headerImageView release];
  [headerLabel release];

  [footerView release];
  [footerImageView release];
  [footerLabel release];

  [verticalSwipeScrollView release];
  [appData release];
  [previousPage release];
  [nextPage release];

  [super dealloc];
}

@end
