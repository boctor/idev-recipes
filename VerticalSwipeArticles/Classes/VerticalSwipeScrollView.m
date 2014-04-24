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

#import "VerticalSwipeScrollView.h"

@interface VerticalSwipeScrollView (PrivateMethods)
- (void) showCurrentPage;
@end

@implementation VerticalSwipeScrollView
@synthesize externalDelegate, headerView, footerView, currentPageIndex, currentPageView;

// Setup for when our view is setup in a NIB
- (void)awakeFromNib
{
  self.contentSize = self.frame.size;
  
  [self showCurrentPage];
}

// Setup for default init method
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    [self showCurrentPage];
    self.contentSize = self.frame.size;
  }
  return self;
}

// Setup for init method with explicit values
- (id) initWithFrame:(CGRect)frame headerView:(UIView*)theHeaderView footerView:(UIView*)theFooterView startingAt:(NSUInteger)pageIndex delegate:(id<VerticalSwipeScrollViewDelegate,UIScrollViewDelegate>)verticalSwipeDelegate
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.alwaysBounceVertical = YES;
    self.delegate = verticalSwipeDelegate;
    self.currentPageIndex = pageIndex;
    self.headerView = theHeaderView;
    self.footerView = theFooterView;
    self.contentSize = self.frame.size;
  }
  return self;
}

// We override setting the delegate and:
// 1. make ourselves the delegate instead
// 2. remember the actual delegate and properly forward messages to it
-(void) setDelegate:(id<VerticalSwipeScrollViewDelegate,UIScrollViewDelegate>)newDelegate
{
  if (newDelegate != (id<VerticalSwipeScrollViewDelegate,UIScrollViewDelegate>)self)
    externalDelegate = newDelegate;
  [super setDelegate:self];
}

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

// This accessor lets you setup the initial current page to a value other than 0
-(void) setCurrentPageIndex:(NSUInteger)newValue
{
  currentPageIndex = newValue;
  
  // Hide the header if there is no previous page
  headerView.hidden = currentPageIndex <= 0;
  // Hide the footer if there is no next page
  footerView.hidden = (currentPageIndex == [externalDelegate pageCount]-1);

  [self showCurrentPage];
}

// Ask the delegate for the current page and show it
- (void) showCurrentPage
{
  [currentPageView removeFromSuperview];
  self.currentPageView = [externalDelegate viewForScrollView:self atPage:currentPageIndex];
  [self addSubview:currentPageView];
}

// scrollViewDidScroll is where we can tell that the header or footer are fully
// in view or out of view. This is how we accomplish the animation when you pull
// up/down to see the previous/next page.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if ([externalDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    [externalDelegate scrollViewDidScroll:scrollView];
  
   // Everything we want to do is only applicable if the user is in the middle of dragging
  if (!scrollView.dragging) return;

  // The user is dragging down, we are loading/unloading the header/previous page view
  if (scrollView.contentOffset.y < 0)
  {
    // If the header is hidden, then there is no previous page and nothing for us to do
    if (headerView.hidden) return;

    // If the user has pulled down more than the height of the header
    if (scrollView.contentOffset.y < -headerView.frame.size.height)
    {
      // The header is already loaded, nothing for us to do
      if (_headerLoaded) return;
      
      // The header has been loaded
      if ([externalDelegate respondsToSelector:@selector(headerLoadedInScrollView:)])
        [externalDelegate performSelector:@selector(headerLoadedInScrollView:)];
      _headerLoaded = YES;
    }
    else // The user has pulled down less than the height of the header
    {
      // If the header isn't already loaded, nothing for us to do
      if (!_headerLoaded) return;
      
      // The header has been unloaded
      if ([externalDelegate respondsToSelector:@selector(headerUnloadedInScrollView:)])
        [externalDelegate performSelector:@selector(headerUnloadedInScrollView:)];
      _headerLoaded = NO;
    }
  }
  else // The user is dragging up, we are loading/unloading the footer/next page view
  {
    // If the footer is hidden, then there is no next page and nothing for us to do
    if (footerView.hidden) return;
    
    // If the user has pulled up more than the height of the footer
    if (scrollView.contentOffset.y > footerView.frame.size.height)
    {
      // The footer is already loaded, nothing for us to do
      if (_footerLoaded) return;
      
      // The footer has been loaded
      if ([externalDelegate respondsToSelector:@selector(footerLoadedInScrollView:)])
        [externalDelegate performSelector:@selector(footerLoadedInScrollView:)];
      _footerLoaded = YES;
    }
    else // The user has pulled up less than the height of the footer
    {
      // If the footer isn't already loaded, nothing for us to do
      if (!_footerLoaded) return;
      
      // The footer has been unloaded
      if ([externalDelegate respondsToSelector:@selector(footerUnloadedInScrollView:)])
        [externalDelegate performSelector:@selector(footerUnloadedInScrollView:)];
      _footerLoaded = NO;
    }
  }
}

// The scroll view sends this message when the user’s finger touches up after dragging content
// This where we start switching to the previous/next page
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  if ([externalDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    [externalDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
  
  // If the header is loaded, then the user wants to go to the previous page
  if (_headerLoaded)
  {
    // Ask the delegate for the previous page
    UIView* previousPage = [externalDelegate viewForScrollView:self atPage:currentPageIndex-1];
    // We want to animate this new page coming down, so we first
    // Set its frame to the top of the scroll view
    previousPage.frame = CGRectMake(0, -(previousPage.frame.size.height + self.contentOffset.y), self.frame.size.width, self.frame.size.height);
    [self addSubview:previousPage];
    
    // Start the page down animation
    [UIView beginAnimations:nil context:previousPage];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pageAnimationDidStop:finished:context:)];
    // When the animation is done, we want the previous page to be front and center
    previousPage.frame = self.frame;
    // We also want the existing page to animate to the bottom of the scroll view
    currentPageView.frame = CGRectMake(0, self.frame.size.height + headerView.frame.size.height, self.frame.size.width, self.frame.size.height);
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
    nextPage.frame = CGRectMake(0, nextPage.frame.size.height + self.contentOffset.y, self.frame.size.width, self.frame.size.height);
    [self addSubview:nextPage];
    
    // Start the page u animation
    [UIView beginAnimations:nil context:nextPage];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pageAnimationDidStop:finished:context:)];
    // When the animation is done, we want the next page to be front and center
    nextPage.frame = self.frame;
    // We also want the existing page to animate to the top of the scroll view
    currentPageView.frame = CGRectMake(0, -(self.frame.size.height + headerView.frame.size.height), self.frame.size.width, self.frame.size.height);
    // And we also animate the footer view to animate off the top of the screen
    footerView.frame = CGRectMake(0, -footerView.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
    [UIView commitAnimations];

    // Increment our current page
    currentPageIndex++;
  }
}

// This method is called after the page up/down animation completes
// This is where we reset everything for the new page
- (void)pageAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  // Remove the old page
  [currentPageView removeFromSuperview];
  
  // Set the previous/next page we just animated into view as the current page
  UIView* newPage = (UIView*)context;
  self.currentPageView = newPage;
  
  // After we've switched pages, reset the header/footer loaded states
  if (_footerLoaded && [externalDelegate respondsToSelector:@selector(footerUnloadedInScrollView:)])
    [externalDelegate performSelector:@selector(footerUnloadedInScrollView:)];
  _footerLoaded = NO;

  if (_headerLoaded && [externalDelegate respondsToSelector:@selector(headerUnloadedInScrollView:)])
    [externalDelegate performSelector:@selector(headerUnloadedInScrollView:)];
  _headerLoaded = NO;
  
  // Force the header and footer views to their default states
  headerView.frame = CGRectMake(0, -headerView.frame.size.height, headerView.frame.size.width, headerView.frame.size.height);
  footerView.frame = CGRectMake(0, self.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
  
  // Based on the current page index, hide/show the header and footer
  headerView.hidden = currentPageIndex <= 0;
  footerView.hidden = (currentPageIndex == [externalDelegate pageCount]-1);
}

# pragma mark UIScrollViewDelegate

// Since we set ourselves to be out UIScrollViewDelegate, we forward
// any UIScrollViewDelegate messages to the external delegate.
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if ([externalDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    [externalDelegate scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
  if ([externalDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
    [externalDelegate scrollViewWillBeginDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  if ([externalDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    [externalDelegate scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
  if ([externalDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
    [externalDelegate scrollViewDidEndScrollingAnimation:scrollView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  if ([externalDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
    return [externalDelegate viewForZoomingInScrollView:scrollView];
  else
    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
  if ([externalDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
    [externalDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
  if ([externalDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
    return [externalDelegate scrollViewShouldScrollToTop:scrollView];
  else
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
  if ([externalDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
    [externalDelegate scrollViewDidScrollToTop:scrollView];
}

- (void)dealloc
{
  [headerView release];
  [footerView release];
  [currentPageView release];

  [super dealloc];
}


@end
