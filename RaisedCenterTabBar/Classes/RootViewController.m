//
//  RootViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//  Copyright 2010 Boctor Design. All rights reserved.
//

#import "RootViewController.h"
#import "InstagramViewController.h"
#import "PathViewController.h"
#import "DailyBoothViewController.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Home";
    self.tableView.rowHeight = 57.0;

    tableViewData = [[NSArray arrayWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Instagram", @"title", @"InstagramViewController", @"class", @"Icon.png", @"image", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Path™", @"title", @"PathViewController", @"class", @"app-icon-114.png", @"image", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"DailyBooth", @"title", @"DailyBoothViewController", @"class", @"DailyBoothIcon.png", @"image",nil], nil] retain];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[tableViewData objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.imageView.image = [UIImage imageNamed:[[tableViewData objectAtIndex:indexPath.row] objectForKey:@"image"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString* class = [[tableViewData objectAtIndex:indexPath.row] objectForKey:@"class"];
  Class detailClass = NSClassFromString(class);
  UIViewController* detailViewController = [[[detailClass alloc] initWithNibName:nil bundle:nil] autorelease];
  detailViewController.title = [[tableViewData objectAtIndex:indexPath.row] objectForKey:@"title"];
  [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)dealloc
{
  [super dealloc];
  [tableViewData release];
}

@end

