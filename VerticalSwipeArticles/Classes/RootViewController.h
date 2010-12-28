//
//  RootViewController.h
//  VerticalSwipeArticles
//
//  Created by Peter Boctor on 12/26/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//
#import "DetailViewController.h"

@interface RootViewController : UITableViewController
{
  NSArray *topApps;
  DetailViewController *detailViewController;
}

@property (nonatomic, retain) NSArray *topApps;
@property (nonatomic, retain) DetailViewController *detailViewController;

@end
