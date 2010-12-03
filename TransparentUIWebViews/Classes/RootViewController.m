//
//  RootViewController.m
//  TransparentUIWebViews
//
//  Created by Peter Boctor on 12/3/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.title = @"TransparentUIWebViews";
  
  tableViewData = [[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Standard UIWebView", @"title", @"WebViewController", @"class", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"Transparent UIWebView", @"title", @"TransparentWebViewController", @"class", nil], nil] retain];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

  cell.textLabel.text = [[tableViewData objectAtIndex:indexPath.row] objectForKey:@"title"];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString* class = [[tableViewData objectAtIndex:indexPath.row] objectForKey:@"class"];
  Class detailClass = NSClassFromString(class);
  UIViewController* detailViewController = [[[detailClass alloc] initWithNibName:nil bundle:nil] autorelease];
  detailViewController.title = class;
  [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)dealloc
{
  [super dealloc];
  [tableViewData release];
}

@end

