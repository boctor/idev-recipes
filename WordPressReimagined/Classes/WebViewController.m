//
//  WebViewController.m
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

#import "WebViewController.h"

#define backIndex 0
#define forwardIndex 2
#define reloadIndex 4
#define shareIndex 5

@interface WebViewController (PrivateMethods)
- (void) showLoading;
- (void) hideLoading;
@end

@implementation WebViewController
@synthesize webView, toolbar, url;

- (void) viewWillAppear:(BOOL)animated
{
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  
  [self showLoading];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  [webView loadRequest:request];
  
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];

  [super viewWillDisappear:animated];
}

// - (CGPoint) centerForLoading
// {
//   return CGPointMake(self.view.frame.size.width/2,  (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)/2);
// }

- (IBAction) goBack:sender
{
  [webView goBack];
}

- (IBAction) goForward:sender
{
  [webView goForward];
}

- (IBAction) reload:sender
{
  [webView reload];
}

- (IBAction) shareLink:sender
{
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                  delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
  actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
  [actionSheet addButtonWithTitle:NSLocalizedString(@"Open in Safari", nil)];
  [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
  [actionSheet setCancelButtonIndex:1];
  [actionSheet showInView:self.view];
  [actionSheet release];
}

#pragma mark UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  NSString * title = [actionSheet buttonTitleAtIndex:buttonIndex];

  if ([title isEqualToString:NSLocalizedString(@"Cancel", nil)])
    return;

  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark UIWebViewDelegate
//- (void)webView:(UIWebView *)theWebView didFailLoadWithError:(NSError *)error
//{
//  [self defaultErrorMessage];
//}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
  [self hideLoading];
  theWebView.backgroundColor = [UIColor whiteColor];
  
  NSString* pageTitle = [theWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
  self.navigationItem.title = pageTitle;
  
  UIBarItem* back = [toolbar.items objectAtIndex:backIndex];
  back.enabled = [theWebView canGoBack];
    
  UIBarItem* forward = [toolbar.items objectAtIndex:forwardIndex];
  forward.enabled = [theWebView canGoForward];
}

- (void) showLoading
{
  UIActivityIndicatorView* activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
  [activityIndicator startAnimating];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
}

- (void) hideLoading
{
  self.navigationItem.rightBarButtonItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [[UIApplication sharedApplication] setStatusBarHidden:(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) ? YES : NO animated:YES];
}

#pragma mark Memory Management
- (void)viewDidUnload
{
  self.webView = nil;
  self.toolbar = nil;
}

- (void)dealloc
{
  [webView release], webView = nil;
  [toolbar release], toolbar = nil;

  [super dealloc];
}


@end
