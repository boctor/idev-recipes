//
//  RootViewController.m
//  VerticalSwipeArticles
//
//  Created by Peter Boctor on 12/26/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize topApps, detailViewController;

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Top Paid Apps";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return topApps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

  cell.textLabel.numberOfLines = 2;
  cell.textLabel.text = [[[topApps objectAtIndex:indexPath.row] objectForKey:@"im:name"] objectForKey:@"label"];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  self.detailViewController = [[[DetailViewController alloc] initWithNibName:nil bundle:nil] autorelease];
  detailViewController.appData = topApps;
  detailViewController.startIndex = indexPath.row;
  [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)dealloc
{
  [topApps release];
  [detailViewController release];
  [super dealloc];
}


@end

