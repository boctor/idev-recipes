//
//  VerticalSwipeScrollView.m
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

// Refactor by Joiningss on 04/22/14.
//
// Copyright (c) 2014 Joiningss

#import "VerticalSwipeScrollView.h"
#import "FTAnimation.h"
@interface VerticalSwipeScrollView()

@property(nonatomic, assign) CGSize contentSize;
@property(nonatomic, assign) BOOL alwaysBounceVertical;
@property(nonatomic, assign) UIEdgeInsets contentInset;
@property(nonatomic, assign) BOOL headerLoaded;
@property(nonatomic, assign) BOOL footerLoaded;
@property (nonatomic, strong) UIWebView* latestPageView;
@end

@interface VerticalSwipeScrollView (PrivateMethods)
- (void) showCurrentPage;
@end

@implementation VerticalSwipeScrollView

//disable setup by interface file.Joiningss

//// Setup for when our view is setup in a NIB
//- (void)awakeFromNib
//{
//    self.contentSize = self.frame.size;
//    [self showCurrentPage];
//}
//
//// Setup for default init method
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        [self showCurrentPage];
//        self.contentSize = self.frame.size;
//    }
//    return self;
//}

// Setup for init method with explicit values
- (id) initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets)contentInset startingAt:(NSUInteger)pageIndex delegate:(id<VerticalSwipeScrollViewDelegate,UIScrollViewDelegate>)verticalSwipeDelegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.alwaysBounceVertical = YES;
        self.delegate = verticalSwipeDelegate;
        self.currentPageIndex = pageIndex;
        self.contentInset = contentInset;
        self.contentSize = CGSizeMake(CGRectGetWidth(self.frame)-contentInset.left-contentInset.right, CGRectGetHeight(self.frame)-contentInset.top-contentInset.bottom);
        [self showCurrentPage];
    }
    return self;
}

// We override setting the delegate and:
// 1. make ourselves the delegate instead
// 2. remember the actual delegate and properly forward messages to it
-(void) setDelegate:(id<VerticalSwipeScrollViewDelegate>)newDelegate
{
    if (newDelegate != (id<VerticalSwipeScrollViewDelegate>)self)
        self.externalDelegate = newDelegate;
    //[super setDelegate:self];
}
/* header and footer view is special for each webview
 
// The header view is what appears when you pull the
// scroll view down to get to the previous page
-(void) setHeaderView:(UIView*)newValue
{
    if (headerView != newValue)
    {
        // Standard setter code
        [headerView removeFromSuperview];
        [headerView release];
        headerView = [newValue retain];
        
        // Place the header above the scroll view
        headerView.frame = CGRectMake(0, -headerView.frame.size.height, headerView.frame.size.width, headerView.frame.size.height);
        [self addSubview:headerView];
        
        // Hide the header if there is no previous page
        if (currentPageIndex <= 0)
            headerView.hidden = YES;
    }
}

// The footer view is what appears when you pull the
// scroll view up to get to the next page
-(void) setFooterView:(UIView*)newValue
{
    if (footerView != newValue)
    {
        // Standard setter code
        [footerView removeFromSuperview];
        [footerView release];
        footerView = [newValue retain];
        
        // Place the footer below the scroll view
        footerView.frame = CGRectMake(0, self.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
        [self addSubview:footerView];
        
        // Hide the footer if there is no next page
        if (currentPageIndex == [externalDelegate pageCount]-1)
            footerView.hidden = YES;
    }
}
*/
// This accessor lets you setup the initial current page to a value other than 0


// Ask the delegate for the current page and show it
- (void) showCurrentPage
{
    [self.currentPageView removeFromSuperview];
    self.currentPageView = [self.externalDelegate viewForScrollView:self atPage:self.currentPageIndex];
    [self addHeaderAndFooterForPage:self.currentPageIndex scrollView:self.currentPageView.scrollView];
    [self addSubview:self.currentPageView];
    
}
- (void)addHeaderAndFooterForPage:(NSUInteger)pageIndex scrollView:(UIScrollView *)scrollView{
    AllAroundPullView * headerView = [self.externalDelegate headerViewForScrollView:scrollView atPage:pageIndex];
    if(headerView){
        [headerView setAllAroundPullViewActionHandler:^(AllAroundPullView *view){
            NSLog(@"show previous page");
            [self showOhterPage:YES];
        }];
        [scrollView addSubview:headerView];
    }
    AllAroundPullView * footer = [self.externalDelegate footerViewForScrollView:scrollView atPage:pageIndex];
    if(footer){
        [footer setAllAroundPullViewActionHandler:^(AllAroundPullView *view){
            NSLog(@"show next page");
            [self showOhterPage:NO];
        }];
        [scrollView addSubview:footer];
    }
}

- (void)showOhterPage:(BOOL)showPrevious{
    float animDuration = 0.6;
    if(showPrevious){
        UIWebView * previousPage = [self.externalDelegate viewForScrollView:self atPage:self.currentPageIndex-1];
        previousPage.frame = CGRectMake(0, 0, previousPage.frame.size.width, previousPage.frame.size.height);
        [self addHeaderAndFooterForPage:self.currentPageIndex-1 scrollView:previousPage.scrollView];
        [self addSubview:previousPage];
        self.latestPageView = previousPage;
        // Start the page down animation
        [self setUserInteractionEnabled:NO];
        [self.currentPageView.scrollView setScrollEnabled:NO];
        [self.currentPageView backOutTo:kFTAnimationBottom inView:self withFade:YES duration:animDuration*0.70 delegate:nil startSelector:nil stopSelector:nil];
        [previousPage backInFrom:kFTAnimationTop inView:self withFade:YES duration:animDuration delegate:nil startSelector:nil stopSelector:nil];
        [self performSelector:@selector(pageAnimationDidStop) withObject:nil afterDelay:animDuration];
        _currentPageIndex--;
    }else{
        // Ask the delegate for the next page
        UIWebView* nextPage = [self.externalDelegate viewForScrollView:self atPage:self.currentPageIndex+1];
        // We want to animate this new page coming up, so we first
        // Set its frame to the bottom of the scroll view
        nextPage.frame = CGRectMake(0, 0, nextPage.frame.size.width, nextPage.frame.size.height);
        [self addHeaderAndFooterForPage:self.currentPageIndex+1 scrollView:nextPage.scrollView];
        [self addSubview:nextPage];
        self.latestPageView = nextPage;
        [self setUserInteractionEnabled:NO];
        [self.currentPageView.scrollView setScrollEnabled:NO];
        [self.currentPageView backOutTo:kFTAnimationTop inView:self withFade:YES duration:animDuration*0.70 delegate:nil startSelector:nil stopSelector:nil];
        [nextPage backInFrom:kFTAnimationBottom inView:self withFade:YES duration:animDuration delegate:nil startSelector:nil stopSelector:nil];
        [self performSelector:@selector(pageAnimationDidStop) withObject:nil afterDelay:animDuration];
        _currentPageIndex++;
    }
}
- (void)pageAnimationDidStop
{
    // Remove the old page
    [self.currentPageView removeFromSuperview];
    // Set the previous/next page we just animated into view as the current page
    self.currentPageView = self.latestPageView;
    [self.currentPageView.scrollView setScrollEnabled:YES];
    [self setUserInteractionEnabled:YES];
}

/*
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.externalDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [self.externalDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    // If the header is loaded, then the user wants to go to the previous page
    if (self.headerLoaded)
    {
        // Ask the delegate for the previous page
        UIView* previousPage = [self.externalDelegate viewForScrollView:self atPage:self.currentPageIndex-1];
        // We want to animate this new page coming down, so we first
        // Set its frame to the top of the scroll view
        //previousPage.frame = CGRectMake(0, -(previousPage.frame.size.height + self.contentOffset.y), previousPage.frame.size.width, previousPage.frame.size.height);
        [self addSubview:previousPage];
        
        // Start the page down animation
        [UIView beginAnimations:nil context:self.previousPage];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(pageAnimationDidStop:finished:context:)];
        [self setShowsVerticalScrollIndicator:NO];
        // When the animation is done, we want the previous page to be front and center
        previousPage.frame = CGRectMake(0, 0 , previousPage.frame.size.width, previousPage.frame.size.height);
        // We also want the existing page to animate to the bottom of the scroll view
        currentPageView.frame = CGRectMake(0, self.frame.size.height + headerView.frame.size.height, currentPageView.frame.size.width, currentPageView.frame.size.height);
        // And we also animate the header view to animate off the bottom of the screen
        headerView.frame = CGRectMake(0, self.frame.size.height, headerView.frame.size.width, headerView.frame.size.height);
        [UIView commitAnimations];
        
        // Decrement our current page
        currentPageIndex--;
    }
    else if (_footerLoaded) // If the footer is loaded, then the user wants to go to the next page
    {
        // Ask the delegate for the next page
        UIView* nextPage = [externalDelegate viewForScrollView:self atPage:currentPageIndex+1];
        // We want to animate this new page coming up, so we first
        // Set its frame to the bottom of the scroll view
        nextPage.frame = CGRectMake(0, nextPage.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self addSubview:nextPage];
        
        // Start the page u animation
        [UIView beginAnimations:nil context:nextPage];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(pageAnimationDidStop:finished:context:)];
        //hide scroll indicator when pages animed
        [self setShowsVerticalScrollIndicator:NO];
        // When the animation is done, we want the next page to be front and center
        nextPage.frame = CGRectMake(0, 0, nextPage.frame.size.width, nextPage.frame.size.height);
        // We also want the existing page to animate to the top of the scroll view
        currentPageView.frame = CGRectMake(0, -(currentPageView.frame.size.height + headerView.frame.size.height), currentPageView.frame.size.width, currentPageView.frame.size.height);
        // And we also animate the footer view to animate off the top of the screen
        footerView.frame = CGRectMake(0, -footerView.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
        [UIView commitAnimations];
        
        // Increment our current page
        currentPageIndex++;
    }
}
*/
// This method is called after the page up/down animation completes
// This is where we reset everything for the new page
/*
- (void)pageAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // Remove the old page
    [self.currentPageView removeFromSuperview];
    
    // Set the previous/next page we just animated into view as the current page
    UIView* newPage = (__bridge UIView*)context;
    self.currentPageView = newPage;
    
    // After we've switched pages, reset the header/footer loaded states
    if (_footerLoaded && [self.externalDelegate respondsToSelector:@selector(footerUnloadedInScrollView:)])
        [self.externalDelegate performSelector:@selector(footerUnloadedInScrollView:)];
    _footerLoaded = NO;
    
    if (_headerLoaded && [self.externalDelegate respondsToSelector:@selector(headerUnloadedInScrollView:)])
        [self.externalDelegate performSelector:@selector(headerUnloadedInScrollView:)];
    _headerLoaded = NO;
    
    // Force the header and footer views to their default states
    headerView.frame = CGRectMake(0, -headerView.frame.size.height, headerView.frame.size.width, headerView.frame.size.height);
    footerView.frame = CGRectMake(0, self.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
    
    // Based on the current page index, hide/show the header and footer
    headerView.hidden = currentPageIndex <= 0;
    footerView.hidden = (currentPageIndex == [externalDelegate pageCount]-1);
}
*/




@end
