//
//  DetailViewController.h
//  VerticalSwipeArticles
//
//  Created by Peter Boctor on 12/26/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "VerticalSwipeScrollView.h"

@interface DetailViewController : UIViewController <VerticalSwipeScrollViewDelegate, UIScrollViewDelegate>
{
  IBOutlet UIView* headerView;
  IBOutlet UIImageView* headerImageView;
  IBOutlet UILabel* headerLabel;

  IBOutlet UIView* footerView;
  IBOutlet UIImageView* footerImageView;
  IBOutlet UILabel* footerLabel;
  
  VerticalSwipeScrollView* verticalSwipeScrollView;
  NSArray* appData;
  NSUInteger startIndex;
  UIWebView* previousPage;
  UIWebView* nextPage;
}

@property (nonatomic, retain) IBOutlet UIView* headerView;
@property (nonatomic, retain) IBOutlet UIImageView* headerImageView;
@property (nonatomic, retain) IBOutlet UILabel* headerLabel;
@property (nonatomic, retain) IBOutlet UIView* footerView;
@property (nonatomic, retain) IBOutlet UIImageView* footerImageView;
@property (nonatomic, retain) IBOutlet UILabel* footerLabel;
@property (nonatomic, retain) VerticalSwipeScrollView* verticalSwipeScrollView;
@property (nonatomic, retain) NSArray* appData;
@property (nonatomic) NSUInteger startIndex;
@property (nonatomic, retain) UIWebView* previousPage;
@property (nonatomic, retain) UIWebView* nextPage;

@end

