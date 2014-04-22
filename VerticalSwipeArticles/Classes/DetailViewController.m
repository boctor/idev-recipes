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
#import "AllAroundPullView.h"
CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@interface DetailViewController (PrivateMethods)
-(void)hideGradientBackground:(UIView*)theView;
-(UIWebView*) createWebViewForIndex:(NSUInteger)index;
@end

@implementation DetailViewController{
    UIEdgeInsets contentInset;
    
}

@synthesize headerView, headerImageView, headerLabel;
@synthesize footerView, footerImageView, footerLabel;
@synthesize verticalSwipeScrollView, appData, startIndex;
@synthesize previousPage, nextPage;

- (void)viewDidLoad
{
    
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0);
    }else{
        contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

-(void)willAppearIn:(UINavigationController *)navigationController
{
    //CGRect verticalSwipeScrollViewFrame = CGRectMake(0, 64.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64.0);
    CGRect verticalSwipeScrollViewFrame = self.view.frame;
    self.verticalSwipeScrollView = [[VerticalSwipeScrollView alloc] initWithFrame:verticalSwipeScrollViewFrame contentInset:contentInset  startingAt:startIndex delegate:self];
    [self.view addSubview:verticalSwipeScrollView];
}

# pragma mark VerticalSwipeScrollViewDelegate


-(UIWebView*) viewForScrollView:(VerticalSwipeScrollView*)scrollView atPage:(NSUInteger)page
{
    UIWebView* webView = nil;
    if (page < scrollView.currentPageIndex)
        webView = previousPage;
    else if (page > scrollView.currentPageIndex)
        webView = nextPage;
    
    if (!webView)
        webView = [self createWebViewForIndex:page verticalSwipeScrollViewv:scrollView];
    
    self.previousPage = page > 0 ? [self createWebViewForIndex:page-1 verticalSwipeScrollViewv:scrollView] : nil;
    self.nextPage = (page == (appData.count-1)) ? nil : [self createWebViewForIndex:page+1 verticalSwipeScrollViewv:scrollView];
    
    self.navigationItem.title = [[[appData objectAtIndex:page] objectForKey:@"im:name"] objectForKey:@"label"];
    if (page > 0)
        headerLabel.text = [[[appData objectAtIndex:page-1] objectForKey:@"im:name"] objectForKey:@"label"];
    if (page != appData.count-1)
        footerLabel.text = [[[appData objectAtIndex:page+1] objectForKey:@"im:name"] objectForKey:@"label"];
    [webView clearsContextBeforeDrawing];
    return webView;
}

- (AllAroundPullView *)headerViewForScrollView:(UIScrollView *)scrollView atPage:(NSUInteger)page{
    AllAroundPullView *topPullView;
    if(page!=0){
        topPullView = [[AllAroundPullView alloc] initWithScrollView:scrollView position:AllAroundPullViewPositionTop action:nil];
        topPullView.hideIndicatorView = YES;
    }
    return topPullView;
}

- (AllAroundPullView *)footerViewForScrollView:(UIScrollView *)scrollView atPage:(NSUInteger)page{
    AllAroundPullView *footerPullView;
    if(page != [self pageCount]-1){
        footerPullView = [[AllAroundPullView alloc] initWithScrollView:scrollView position:AllAroundPullViewPositionBottom action:nil];
        footerPullView.hideIndicatorView = YES;
    }
    return footerPullView;
}
-(NSUInteger) pageCount
{
    return appData.count;
}

-(UIWebView*) createWebViewForIndex:(NSUInteger)index verticalSwipeScrollViewv:(VerticalSwipeScrollView*)scrollView
{
    //CGRect webViewFrame = CGRectMake(0, 0, CGRectGetWidth(scrollView.frame)-contentInset.left-contentInset.right, CGRectGetHeight(scrollView.frame)-contentInset.top-contentInset.bottom);
    CGRect webViewFrame = CGRectMake(0, 0, CGRectGetWidth(scrollView.frame),CGRectGetHeight(scrollView.frame));
    UIWebView* webView = [[UIWebView alloc] initWithFrame:webViewFrame];
    [webView.scrollView setContentInset:contentInset];
    [webView.scrollView setScrollIndicatorInsets:contentInset];
    webView.opaque = NO;
    [webView setBackgroundColor:[UIColor clearColor]];
    //[webView loadHTMLString:@"" baseURL:nil];
    [self hideGradientBackground:webView];
    
    NSString* htmlFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/DetailView.html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- title -->" withString:[[[appData objectAtIndex:index] objectForKey:@"im:name"] objectForKey:@"label"]];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- icon -->" withString:[[[[appData objectAtIndex:index] objectForKey:@"im:image"] objectAtIndex:0] objectForKey:@"label"]];
    NSMutableString * contentString = [[[[appData objectAtIndex:index] objectForKey:@"summary"] objectForKey:@"label"] mutableCopy];
    
    //creat long html page, don't forget to remove height attri in DetailView.html
    [contentString appendString:[[[appData objectAtIndex:index] objectForKey:@"summary"] objectForKey:@"label"]];
    [contentString appendString:[[[appData objectAtIndex:index] objectForKey:@"summary"] objectForKey:@"label"]];
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- content -->" withString:contentString];
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



@end
