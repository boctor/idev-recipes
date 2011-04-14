//
//  SideSwipeTableViewController.h
//  SideSwipeTableView
//
//  Created by Peter Boctor on 4/13/11.
//  Copyright 2011 Peter Boctor. All rights reserved.
//


@interface SideSwipeTableViewController : UIViewController
{
  IBOutlet UITableView* tableView;
  IBOutlet UIView* sideSwipeView;
  UITableViewCell* sideSwipeCell;
  UISwipeGestureRecognizerDirection sideSwipeDirection;
  BOOL animatingSideSwipe;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UIView* sideSwipeView;
@property (nonatomic, retain) UITableViewCell* sideSwipeCell;
@property (nonatomic) UISwipeGestureRecognizerDirection sideSwipeDirection;
@property (nonatomic) BOOL animatingSideSwipe;

- (void) removeSideSwipeView:(BOOL)animated;
- (BOOL) gestureRecognizersSupported;

@end
