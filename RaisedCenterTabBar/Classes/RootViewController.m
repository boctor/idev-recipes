//
//  RootViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void)dealloc
{
  [super dealloc];
  [tableViewData release];
}

@end

