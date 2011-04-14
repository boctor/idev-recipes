//
//  SideSwipeTableViewCell.m
//  SideSwipeTableView
//
//  Created by Peter Boctor on 4/13/11.
//  Copyright 2011 Peter Boctor. All rights reserved.
//

#import "SideSwipeTableViewCell.h"

@implementation SideSwipeTableViewCell
@synthesize supressDeleteButton;

// Recursively go up the view hierarchy to find our tableView
-(UITableView*)getTableView:(UIView*)theView
{
  if (!theView.superview)
    return nil;
  
  if ([theView.superview isKindOfClass:[UITableView class]])
    return (UITableView*)theView.superview;
  
  return [self getTableView:theView.superview];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  // We suppress the Delete button by explicitly not calling
  // super's implementation
  if (supressDeleteButton)
  {
    // Reset the editing state of the table back to NO
    UITableView* tableView = [self getTableView:self];
    tableView.editing = NO;
  }
  else
    [super setEditing:editing animated:animated];
}

@end
