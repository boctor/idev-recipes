//
//  VerticalSwipeScrollView.h
//  VerticalSwipeArticles
//
//  Created by Peter Boctor on 12/26/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

@class VerticalSwipeScrollView;
@protocol VerticalSwipeScrollViewDelegate
-(UIView*) viewForScrollView:(VerticalSwipeScrollView*)scrollView atPage:(NSUInteger)page;
-(NSUInteger) pageCount;
@optional
-(void) headerLoadedInScrollView:(VerticalSwipeScrollView*)scrollView;
-(void) headerUnloadedInScrollView:(VerticalSwipeScrollView*)scrollView;
-(void) footerLoadedInScrollView:(VerticalSwipeScrollView*)scrollView;
-(void) footerUnloadedInScrollView:(VerticalSwipeScrollView*)scrollView;
@end

@interface VerticalSwipeScrollView : UIScrollView <UIScrollViewDelegate>
{
  id<VerticalSwipeScrollViewDelegate,UIScrollViewDelegate> externalDelegate;

  IBOutlet UIView* headerView;
  IBOutlet UIView* footerView;
  
  BOOL _headerLoaded;
  BOOL _footerLoaded;
  
  NSUInteger currentPageIndex;
  UIView* currentPageView;
}

@property (nonatomic, assign) id<VerticalSwipeScrollViewDelegate,UIScrollViewDelegate> externalDelegate;
@property (nonatomic, retain) IBOutlet UIView* headerView;
@property (nonatomic, retain) IBOutlet UIView* footerView;
@property (nonatomic) NSUInteger currentPageIndex;
@property (nonatomic, retain) UIView* currentPageView;

- (id) initWithFrame:(CGRect)frame headerView:(UIView*)headerView footerView:(UIView*)footerView startingAt:(NSUInteger)pageIndex delegate:(id<VerticalSwipeScrollViewDelegate,UIScrollViewDelegate>)verticalSwipeDelegate;

@end
