//
//  VerticalSwipeScrollView.h
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

#import "AllAroundPullView.h"
@class VerticalSwipeScrollView;
@protocol VerticalSwipeScrollViewDelegate
-(UIWebView *) viewForScrollView:(VerticalSwipeScrollView*)scrollView atPage:(NSUInteger)page;
-(AllAroundPullView *) headerViewForScrollView:(UIScrollView *)scrollView atPage:(NSUInteger)page;
-(AllAroundPullView *) footerViewForScrollView:(UIScrollView*)scrollView atPage:(NSUInteger)page;
-(NSUInteger) pageCount;
@optional
-(void) headerLoadedInScrollView:(VerticalSwipeScrollView*)scrollView;
-(void) headerUnloadedInScrollView:(VerticalSwipeScrollView*)scrollView;
-(void) footerLoadedInScrollView:(VerticalSwipeScrollView*)scrollView;
-(void) footerUnloadedInScrollView:(VerticalSwipeScrollView*)scrollView;
@end

@interface VerticalSwipeScrollView : UIView
@property (nonatomic) NSUInteger currentPageIndex;
@property (nonatomic, strong) UIWebView* currentPageView;
@property (nonatomic, assign) id<VerticalSwipeScrollViewDelegate> externalDelegate;
- (id) initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets)contentInset startingAt:(NSUInteger)pageIndex delegate:(id<VerticalSwipeScrollViewDelegate>)verticalSwipeDelegate;
- (void)showCurrentPage;
@end
